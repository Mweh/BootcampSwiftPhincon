//
//  MsFlixyAssistanceViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 14/12/23.
//

import GoogleGenerativeAI
import IQKeyboardManagerSwift
import RxCocoa
import RxSwift
import UIKit

class MsFlixyAssistanceViewController: UIViewController {
    
    @IBOutlet weak var userInputTextField: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var sendMessageButtonPressed: UIButton!
    
    var chatMessages: [ChatMessage] = []
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the text field delegate
        userInputTextField.delegate = self
        setupChatTableView()
        setupNavi()
        setupSendMessageButtonPressed()
    }
    
    func setupSendMessageButtonPressed(){
        sendMessageButtonPressed.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.userInputTextField.resignFirstResponder() // Dismiss the keyboard
                // Call setupAI() when the return key is pressed
                Task {
                    await self?.setupAI()
                }
            })
            .disposed(by: bag)
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
    
    // Mark the function as asynchronous
    func setupAI() async {
        do {
            guard let userInput = userInputTextField.text, !userInput.isEmpty else {
                // Handle the case where the user input is empty
                return
            }
            
            addMessageToChat(userInput, isMsFlixy: false) // user
            userInputTextField.text = "" // Clear the text field after sending
            
            let model = GenerativeModel(name: "gemini-pro", apiKey: BaseConstant.geminiApiKey)
            
            let prompt = userInput
            let response = try await model.generateContent(prompt)
            
            if let text = response.text {
                print(text)
                addMessageToChat(text, isMsFlixy: true) // Ms. Flixy
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func addMessageToChat(_ text: String, isMsFlixy: Bool) {
        let message = ChatMessage(text: text, isMsFlixy: isMsFlixy)
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
        let message = chatMessages[indexPath.row]
        cell.configure(with: message)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dateUIHeaderView = DateUIHeaderView(reuseIdentifier: "headerReuseIdentifier")
        dateUIHeaderView.label.text = "Today"
        return dateUIHeaderView
    }
}


// Conform to UITextFieldDelegate
extension MsFlixyAssistanceViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Dismiss the keyboard
        // Call setupAI() when the return key is pressed
        Task {
            await setupAI()
        }
        return true
    }
}

class DateUIHeaderView: UITableViewHeaderFooterView {
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = contentView.bounds
    }
}

struct ChatMessage {
    let text: String
    let isMsFlixy: Bool
}

// TODO:
/*
 - Set userChar's chat bubble in right side
 - fix time label "12.12 am...."
 - format the text like .md like bold instead of "**"
 - is typing lottie file
 - implement coredata/userdefault
 - implement paste for chat text
 - add images to gemini
 */
