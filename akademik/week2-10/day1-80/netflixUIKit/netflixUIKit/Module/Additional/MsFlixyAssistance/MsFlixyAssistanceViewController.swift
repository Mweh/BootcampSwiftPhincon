//
//  MsFlixyAssistanceViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 14/12/23.
//

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
    var currentInputMode: InputMode = .text
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChatTableView()
        setupNavi()
        setupSendMessageButtonPressed()
        setupInsertPhoto()
        voiceButtonPressed()
        if chatMessages.count != 0 { scrollToBottom() }
        setKeyboard()
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
            let modelText = GenerativeModel(name: "gemini-pro", apiKey: BaseConstant.geminiApiKey)
            let modelVision = GenerativeModel(name: "gemini-pro-vision", apiKey: BaseConstant.geminiApiKey)
            
//            if selectedImage != nil {
//                currentInputMode = .image
//            } else if voiceMessage != "" {
//                currentInputMode = .speech
//            } else {
//                currentInputMode = .text
//            }
            
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
                let response = try await modelText.generateContent(prompt)
                if let text = response.text {
                    addMessageToChat(text, isMsFlixy: true) // Ms. Flixy
                }
                break
            case .image:
                // Handle image input
b                guard let userInput = userInputTextField.text, !userInput.isEmpty else {
                    // Handle the case where the user input is empty
                    return
                }
                
                addMessageToChat(userInput, isMsFlixy: false, image: selectedImage) // user
                userInputTextField.text = "" // Clear the text field after sending
                
                if let selectedImage = selectedImage {
                    let resizedImage = selectedImage.resizedTo(maxWidth: 300, maxHeight: 300)
                    let image = resizedImage
                    let prompt = userInput
                    let response = try await modelVision.generateContent(prompt, image)
                    if let text = response.text {
                        addMessageToChat(text, isMsFlixy: true) // Ms. Flixy
                    }
                }
                self.selectedImage = nil
                self.currentInputMode = .text
                break
            case .speech:
                // Handle speech input
                let voicePrompt = voiceMessage
                
                let responseVoice = try await modelText.generateContent(voicePrompt) //voice only
                if let text = responseVoice.text {
                    addMessageToChat(text, isMsFlixy: true) // Ms. Flixy
                }
                break
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func addMessageToChat(_ text: String, isMsFlixy: Bool, image: UIImage? = nil) {
        let message = ChatMessage(text: text, isMsFlixy: isMsFlixy, image: image)
        chatMessages.append(message)
        chatTableView.reloadData()
        scrollToBottom()
    }
    
    func scrollToBottom() {
        let indexPath = IndexPath(row: chatMessages.count - 1, section: 0)
        chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

extension MsFlixyAssistanceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "MsFlixyAssistanceTableViewCell", for: indexPath) as! MsFlixyAssistanceTableViewCell
        cell.photoImageView.makeRounded(20)
        let message = chatMessages[indexPath.row]
        cell.configure(with: message)
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
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [copyAction])
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

// A custom UITableViewHeaderFooterView for displaying a centered UILabel as the header view.
class DateUIHeaderView: UITableViewHeaderFooterView {
    
    // UILabel for displaying the header text.
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    // Initialize the header view with a reuseIdentifier.
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI() // Call the setupUI method to configure the UI.
    }
    
    // Required initializer for NSCoder. Not implemented, as this class is not meant to be loaded from a nib or storyboard.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Set up the UI by adding the label as a subview to the contentView.
    private func setupUI() {
        contentView.addSubview(label)
    }
    
    // Adjust the layout of the label to fill the contentView when the view's bounds change.
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = contentView.bounds
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

struct ChatMessage: Codable {
    let text: String
    let isMsFlixy: Bool
    let timestamp: Date
    let imageData: Data?
    
    var image: UIImage? {
        if let imageData = imageData {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    init(text: String, isMsFlixy: Bool, image: UIImage? = nil) {
        self.text = text
        self.isMsFlixy = isMsFlixy
        self.timestamp = Date()
        self.imageData = image?.jpegData(compressionQuality: 1.0) // Convert UIImage to Data
    }
}

enum InputMode {
    case text, image, speech
}

// TODO:
/*
 - Format the text like .md like bold instead of "**"
 - Ss typing lottie file
 - Implement paste for chat text
 - Implement speech to text
 */
