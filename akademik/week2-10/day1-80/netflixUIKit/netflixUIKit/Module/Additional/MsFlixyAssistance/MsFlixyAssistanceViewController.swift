//
//  MsFlixyAssistanceViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 14/12/23.
//

import AVFoundation
import GoogleGenerativeAI
import InstantSearchVoiceOverlay
import IQKeyboardManagerSwift
import RxCocoa
import RxSwift
import UIKit

class MsFlixyAssistanceViewController: UIViewController {
    
    @IBOutlet weak var userInputTextField: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var sendMessageButtonPressed: UIButton!
    @IBOutlet weak var insertPhotoButton: UIButton!
    @IBOutlet weak var voiceButton: UIButton!
    
    var selectedImage: UIImage?{
        didSet{
            chatTableView.reloadData()
        }
    }
    let bag = DisposeBag()
    var picker: UIImagePickerController? = UIImagePickerController()
    
    lazy var voiceOverlayController: VoiceOverlayController = {
        let recordableHandler = {
            return SpeechController(locale: Locale(identifier: "id_ID")) // "en_US" or "id_ID"
        }
        return VoiceOverlayController(speechControllerHandler: recordableHandler)
    }()
    
    var chatMessages: [ChatMessage] {
        get {
            if let data = UserDefaults.standard.data(forKey: "chatMessages"),
               let messages = try? JSONDecoder().decode([ChatMessage].self, from: data) {
                return messages
            }
            return []
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: "chatMessages")
            }
        }
    }
    
    var voiceMessage: String = ""
    let isTyping: String = "Ms. Flixy is typing..."
    var tryAgain: String = "Please try again..."
    var currentInputMode: InputMode = .text
    var stateAISubject: PublishSubject<StateAI> = PublishSubject()
    var delay = 0.5
    
    private let synthesizer = AVSpeechSynthesizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChatTableView()
        setupNavi()
        setupSendMessageButtonPressed()
        setupInsertPhoto()
        voiceButtonPressed()
        if chatMessages.count != 0 { scrollToBottom() }
        setKeyboard()
        bindStateAI()
    }
    
    func bindStateAI(){
        stateAISubject.asObservable().subscribe(onNext: {[weak self] state in

            if let isTyping = self?.isTyping, let tryAgain = self?.tryAgain {
                switch state {
                case .loading:
                        self?.addMessageToChat(isTyping, isMsFlixy: true, isTypingLoading: true) // Ms. Flixy
                    removeAllTryAgainWithDelay()
                    self?.chatTableView.reloadData()
                    break
                case .isFinished:
                    removeAllISTyping()
                    self?.chatTableView.reloadData()
                    break
                case .failed:
                    self?.addMessageToChat(tryAgain, isMsFlixy: true) // Ms. Flixy
                    
                    removeAllISTyping()
                    self?.chatTableView.reloadData()
                    break
                }
            }
             
        })
        .disposed(by: bag)
        
        func removeAllISTyping(){
            // Remove all messages with the text "isTyping"
            self.chatMessages.removeAll { $0.text == self.isTyping }
            removeAllTryAgainWithDelay()
        }
        
        func removeAllTryAgainWithDelay(){
            delay = 5
            DispatchQueue.main.asyncAfter(deadline: .now() + delay){
                self.chatMessages.removeAll { $0.text == self.tryAgain }
            }
            self.chatTableView.reloadData()
        }
    }
    
    func voiceButtonPressed() {
        voiceOverlayController.settings.layout.inputScreen.inputButtonConstants.pulseColor = .systemRed
        voiceButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.voiceOverlayController.start(on: self!, textHandler: { (text, final, context) in
                    if final {
                        self?.addMessageToChat(text, isMsFlixy: false)
                        self?.voiceMessage = text
                        Task {
                            await self?.setupAI(.speech)
                        }
                    }
                }, errorHandler: { (error) in
                    print("voice output: error \(String(describing: error))")
                })
            })
            .disposed(by: bag)
    }
    
    func setKeyboard(){
        // Set the text field delegate
        userInputTextField.delegate = self
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    func setupNavi(){
        self.navigationItem.title = "Ms. Flixy (powered by Gemini)"
        
        // Create a UIView with the desired image
        let imageView = UIImageView(image: UIImage(named: "femaleAINoBG"))
        imageView.contentMode = .scaleAspectFit
        
        // Set a fixed width constraint for the custom view
        imageView.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        // Create a UIBarButtonItem with the custom view
        let leftBarButtonItem = UIBarButtonItem(customView: imageView)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let removeChat = UIBarButtonItem(systemItem: .trash)
        removeChat.target = self
        removeChat.action = #selector(removeChatButtonTapped)
        self.navigationItem.rightBarButtonItem = removeChat
        
        // Show both the custom left bar button item and the back button
        self.navigationItem.leftItemsSupplementBackButton = true
    }
    
    @objc func removeChatButtonTapped() {
        // Logic to remove all chat
        chatMessages.removeAll()
        chatTableView.reloadData()
    }
    
    func setupChatTableView() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.register(UINib(nibName: "MsFlixyAssistanceTableViewCell", bundle: nil), forCellReuseIdentifier: "MsFlixyAssistanceTableViewCell")
        chatTableView.separatorStyle = .none
    }
    
    func setupAI(_ currentInputMode: InputMode) async {
        self.currentInputMode = currentInputMode

        do {
            let modelText = GenerativeModel(name: "gemini-pro", apiKey: ConstantAPIStuff.geminiApiKey)
            let modelVision = GenerativeModel(name: "gemini-pro-vision", apiKey: ConstantAPIStuff.geminiApiKey)
            
            switch currentInputMode {
            case .text:
                // Handle text input
                guard let userInput = userInputTextField.text, !userInput.isEmpty else {
                    // Handle the case where the user input is empty
                    return
                }
                
                addMessageToChat(userInput, isMsFlixy: false) // user
                userInputTextField.text = "" // Clear the text field after sending
                
                let prompt = userInput
                do {
                    stateAISubject.onNext(.loading)
                    let response = try await modelText.generateContent(prompt)
                    if let text = response.text {
                        stateAISubject.onNext(.isFinished)
                        addMessageToChat(text, isMsFlixy: true) // Ms. Flixy
                    }
                } catch {
                    tryAgain = "Error: \(error.localizedDescription)"
                    stateAISubject.onNext(.failed)
                }
                break
            case .image:
                // Handle image input
                guard let userInput = userInputTextField.text, !userInput.isEmpty else {
                    // Handle the case where the user input is empty
                    return
                }
                addMessageToChat(userInput, isMsFlixy: false, image: selectedImage) // user
                stateAISubject.onNext(.loading)
                userInputTextField.text = "" // Clear the text field after sending
                
                if let selectedImage = selectedImage {
                    let resizedImage = selectedImage.resizedTo(maxWidth: 300, maxHeight: 300)
                    let image = resizedImage
                    let prompt = userInput
                    let response = try await modelVision.generateContent(prompt, image)
                    if let text = response.text {
                        stateAISubject.onNext(.isFinished)
                        addMessageToChat(text, isMsFlixy: true) // Ms. Flixy
                    }
                }
                self.selectedImage = nil
                self.currentInputMode = .text
                break
            case .speech:
                // Handle speech input
                stateAISubject.onNext(.loading)
                let voicePrompt = voiceMessage
                
                let responseVoice = try await modelText.generateContent(voicePrompt) //voice only
                if let text = responseVoice.text {
                    stateAISubject.onNext(.isFinished)
                    addMessageToChat(text, isMsFlixy: true) // Ms. Flixy
                }
                break
            }
        } catch {
            tryAgain = "Error: \(error.localizedDescription)"
            stateAISubject.onNext(.failed)
        }
    }
    
    func addMessageToChat(_ text: String, isMsFlixy: Bool, image: UIImage? = nil, isTypingLoading: Bool = false) {
        let message = ChatMessage(text: text, isMsFlixy: isMsFlixy, image: image, isTypingLoading: isTypingLoading)
        chatMessages.append(message)
        chatTableView.reloadData()
        scrollToBottom()
        
    }

    func scrollToBottom() {
        let indexPath = IndexPath(row: chatMessages.count - 1, section: 0)
        chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

// MARK: -- UITableViewDelegate, UITableViewDataSource
extension MsFlixyAssistanceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "MsFlixyAssistanceTableViewCell", for: indexPath) as! MsFlixyAssistanceTableViewCell
        let message = chatMessages[indexPath.row]
        cell.configure(with: message)
        cell.photoImageView.makeAllRounded(devidedBy: 20)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // UITableViewDataSource method for providing a custom view for the header of a section.
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Create an instance of DateUIHeaderView with a specified reuseIdentifier.
        let dateUIHeaderView = DateUIHeaderView(reuseIdentifier: "headerReuseIdentifier")
        
        // Set the text of the label in the header view.
        dateUIHeaderView.label.text = "Today"
        
        return dateUIHeaderView // Return the configured header view.
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) { [weak self] _ in
                let copyAction = UIAction(title: "Copy", subtitle: nil, image: UIImage(systemName: "doc.on.doc"), identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                                        
                    // Copy the content to the clipboard
                    UIPasteboard.general.string = self?.chatMessages[indexPath.row].text
                }
                
                let speakAction = UIAction(title: "Speak", image: UIImage(systemName: "speaker.wave.2")) { [weak self] _ in
                    guard let textToSpeak = self?.chatMessages[indexPath.row].text else { return }
                    
                    // Create an utterance. it Refers to a piece of spoken language
                    let utterance = AVSpeechUtterance(string: textToSpeak)
                    
                    // Configure the utterance if needed.
                    utterance.rate = 0.35 // speed the sound
                    utterance.pitchMultiplier = 0.8
                    utterance.postUtteranceDelay = 0.2
                    utterance.volume = 0.8
                    
                    // Pass the utterance to the synthesizer to produce spoken audio.
                    self?.synthesizer.speak(utterance)
                }
                
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [copyAction, speakAction])
            }
        return config
    }

}

// MARK: -- UITextFieldDelegate
// Conform to UITextFieldDelegate
extension MsFlixyAssistanceViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Dismiss the keyboard
        // Call setupAI() when the return key is pressed
        if currentInputMode == .image {
            Task {
                await setupAI(.image)
            }
        } else {
            Task {
                await setupAI(.text)
            }
        }
        return true
    }    
    
    func setupSendMessageButtonPressed(){
        sendMessageButtonPressed.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.userInputTextField.resignFirstResponder() // Dismiss the keyboard
                // Call setupAI() when the return key is pressed
                if self?.currentInputMode == .image {
                    Task {
                        await self?.setupAI(.image)
                    }
                } else {
                    Task {
                        await self?.setupAI(.text)
                    }
                }
            })
            .disposed(by: bag)
    }
}

// MARK: -- UIImagePickerControllerDelegate
extension MsFlixyAssistanceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func setupInsertPhoto(){
        picker!.allowsEditing = false
        picker!.delegate = self
        
        insertPhotoButton.rx.tap
            .subscribe(onNext: {[weak self] in
                Task {
                    await self?.setupAI(.image)
                }
                if let picker = self?.picker{
                    self?.showImagePicker(picker: picker)
                }
            })
            .disposed(by: bag)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        
        if let selectedImage = info[.originalImage] as? UIImage {
            // Store the selected image
            self.selectedImage = selectedImage
        }
    }
}
