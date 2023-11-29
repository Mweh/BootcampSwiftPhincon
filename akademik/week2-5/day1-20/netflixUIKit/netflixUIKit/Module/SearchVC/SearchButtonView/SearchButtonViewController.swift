//
//  SearchButtonViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 08/11/23.
//

import Kingfisher
import Lottie
import RxCocoa
import RxSwift
import UIKit
import Vision

class SearchButtonViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var animationView: LottieAnimationView!
    @IBOutlet weak var scanButton: UIButton!
    
    var picker: UIImagePickerController? = UIImagePickerController()
    var visionTextRecognitionRequest: VNRecognizeTextRequest?
    var selectedImage: UIImage? // Add this variable
    
    var nowPlaying: NowPlaying?  {
        didSet {
            self.collectionView.reloadData()
        }
    }
    // Update the data source for your collection view
    let disposeBag = DisposeBag() // Create a DisposeBag to manage disposables
    let vm = SearchViewModel()
    
    // Create a BehaviorRelay to hold the search query
    var searchSubject: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAnimation()
        configure()
        showNaviItem()
        toBackVC()
        scanButtonTap()
        setupVision()
        setupImagePicker()
    }
    
    func toBackVC(){
        backButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else {
                    return
                }
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func settextFieldSearchInsideNavItem() {
        
        // Create the custom view with the container view
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 20, height: 40)) //takes no effect
        customView.addSubview(textFieldSearch)
        
        // Set the custom view as the title view
        self.navigationItem.titleView = customView
    }
    
    func setupAnimation() {
        animationView.animation = LottieAnimation.named("movieLoading")
        animationView.loopMode = .loop
        animationView.play()
    }
    
    func configure() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "SearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SearchCollectionViewCell")
        
        // Bind the text field's text to the searchSubject
        textFieldSearch.rx.text.orEmpty
            .bind(to: searchSubject)
            .disposed(by: disposeBag)
        
        // Observer for changes in the text field's content
        textFieldSearch.rx.text
            .orEmpty
            .subscribe(onNext: { [weak self] _ in
                self?.updatePlaceholderVisibility()
            })
            .disposed(by: disposeBag)
        
        // Use the searchSubject to trigger the network request
        searchSubject
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { (query: String) -> Observable<NowPlaying> in
                return Observable.create { observer in
                    self.vm.loadData(for: .searchMovie(query: query), resultType: NowPlaying.self)
                    self.vm.api.makeAPICall(endpoint: .searchMovie(query: query)){
                        (result: Result<NowPlaying, Error>) in
                        switch result {
                        case .success(let movies):
                            observer.onNext(movies)
                            observer.onCompleted()
                        case .failure(let error):
                            observer.onError(error)
                        }
                    }
                    return Disposables.create()
                }
            }
            .subscribe(onNext: { [weak self] (results: NowPlaying ) in
                self?.nowPlaying = results
            })
            .disposed(by: disposeBag)
        // Initial update of placeholder visibility
        updatePlaceholderVisibility()
    }
    
    // Function to update the visibility of the placeholder view based on the text field input
    private func updatePlaceholderVisibility() {
        let isEmpty = textFieldSearch.text?.isEmpty ?? true
        animationView.isHidden = !isEmpty
    }
}

extension SearchButtonViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let validCount = self.nowPlaying?.results.count ?? 0
        return validCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let validData = self.nowPlaying?.results {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as! SearchCollectionViewCell
            let urlString = validData[indexPath.row].posterPath ?? ""
            let imageName = "https://image.tmdb.org/t/p/w500/\(urlString)"
            let url = URL(string: imageName)
            cell.imgView.kf.setImage(with: url)
            
            cell.imgView.hero.id = "\(urlString)"
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedMovie = nowPlaying?.results[indexPath.row] {
            let detailViewController = DetailViewController(nibName: "DetailViewController", bundle: nil)
            detailViewController.data = selectedMovie
            detailViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.hero.isEnabled = true
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}

extension SearchButtonViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func setupVision() {
        visionTextRecognitionRequest = VNRecognizeTextRequest(completionHandler: handleVisionTextRecognition)
        
        // You can customize the recognition level as needed. For example:
        // visionTextRecognitionRequest?.recognitionLevel = .accurate
    }
    
    func handleVisionTextRecognition(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
        
        var recognizedText = ""
        for observation in observations {
            guard let topCandidate = observation.topCandidates(1).first else { continue }
            recognizedText += topCandidate.string + "\n"
        }
        
        DispatchQueue.main.async {
            // Update the searchSubject with the recognized text
            self.searchSubject.accept(recognizedText)
            
            // Set the recognized text to the textFieldSearch
            self.textFieldSearch.text = recognizedText.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Show a popup message with the recognized text
            if !recognizedText.isEmpty {
                self.showPopupMessage(title: "Scanned Image's Result[AI]:\n", message: recognizedText)
            }
        }
    }
    
    func performVisionTextRecognition(on image: UIImage?) {
        guard let image = image,
              let cgImage = image.cgImage else {
            print("Selected image is nil")
            return
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage)
        
        do {
            try handler.perform([visionTextRecognitionRequest!])
        } catch {
            print("Error performing Vision request: \(error)")
        }
    }
    
    func scanButtonTap() {
        scanButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showImagePicker()
            })
            .disposed(by: disposeBag)
    }
    
    func setupImagePicker() {
        picker!.allowsEditing = false
        picker!.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        
        if let selectedImage = info[.originalImage] as? UIImage {
            // Store the selected image
            self.selectedImage = selectedImage
            
            // Perform vision text recognition on the selected image
            performVisionTextRecognition(on: selectedImage)
            
            // Hide the animation view when an image is selected
            animationView.isHidden = true
        }
    }
    
    func showImagePicker() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.picker!.sourceType = .camera
            self.present(self.picker!, animated: true, completion: nil)
        }
        alert.addAction(cameraAction)
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { _ in
            self.picker!.sourceType = .photoLibrary
            self.present(self.picker!, animated: true, completion: nil)
        }
        alert.addAction(galleryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(alert, animated: true, completion: nil)
    }
}

class ContentContainerViewController: UIViewController {
    let contentContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentContainer()
    }
    
    func setupContentContainer() {
        view.addSubview(contentContainerView)
        // Adjust the frame of contentContainerView to position it beside the navigation item
        // You may also want to consider safe area insets
        contentContainerView.frame = CGRect(x: 20, y: 40, width: view.bounds.width, height: view.bounds.height)
    }
}

extension SearchButtonViewController{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar
        showNaviItem()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Re-enable the navigation bar when leaving this view
        showNaviItem()
    }
    
    func showNaviItem(){
        navigationController?.navigationBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
