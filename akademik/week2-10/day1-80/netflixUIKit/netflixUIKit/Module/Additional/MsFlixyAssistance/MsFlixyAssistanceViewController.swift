//
//  MsFlixyAssistanceViewController.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 14/12/23.
//

import GoogleGenerativeAI
import UIKit

class MsFlixyAssistanceViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userInputTextField: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    
    var generatedText: String? {
        didSet {
            chatTableView.reloadData() // Trigger a reload when the text is available
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userInputTextField.delegate = self
        // Ensure that the function is called in an asynchronous context
        
        Task {
            await setupAI()
        }
        
        setupChatTableView()
        setupNavi()
    }
    
    func setupNavi() {
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
        
    }
    
    func setupChatTableView(){
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.register(UINib(nibName: "MsFlixyAssistanceTableViewCell", bundle: nil), forCellReuseIdentifier: "MsFlixyAssistanceTableViewCell")
    }
    
    // Mark the function as asynchronous
    func setupAI() async {
        do {
//            guard let userInput = userInputTextField.text, !userInput.isEmpty else {
//                // Handle the case where the user input is empty
//                return
//            }
            
            // For text-only input, use the gemini-pro model
            // Access your API key from your on-demand resource .plist file (see "Set up your API key" above)
            let model = GenerativeModel(name: "gemini-pro", apiKey: BaseConstant.geminiApiKey)
            
            // let prompt = userInput
            let prompt = "Hi I am Fahmi, I am having trouble with this netflix App, can u explain in depth how to use this app? Like the entire guide"
            let response = try await model.generateContent(prompt)
            
            if let text = response.text {
                print(text)
                generatedText = text // Update the property with the generated text
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}


extension MsFlixyAssistanceViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "MsFlixyAssistanceTableViewCell", for: indexPath) as! MsFlixyAssistanceTableViewCell
        
        // Set the chatLabel.text using the generatedText property
        if let generatedText = generatedText{
            cell.chatLabel.text = generatedText
        }
        
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

