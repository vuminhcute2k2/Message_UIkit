//
//  ConversationsViewController.swift
//  Message_chat
//
//  Created by Minh Vũ on 20/06/2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
class ConversationsViewController: UIViewController{
    
    @IBOutlet weak var messageTable: UITableView!
    
    @IBOutlet weak var popImage: UIImageView!
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var borderPhotoView: UIView!
    
    @IBOutlet weak var borderTextField: UIView!
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageView: UIView!
    
    @IBOutlet weak var sendImage: UIImageView!
    var friend: Friend?
    var messages: [Messages] = []
    var chatID: String?
    var messagesListener: ListenerRegistration?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
        displayFriendInformation()
        messageTable.separatorStyle = .none
        // Ensure chatID is set before fetching messages
        guard let chatID = chatID else {
            fatalError("chatID must be set before fetching messages")
        }
        fetchMessages(chatID: chatID)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        messageView.updateBorderView(corners: [.topLeft, .topRight], radius: 25, borderColor: .white, borderWidth: 1)
        borderTextField.updateBorderView(corners: [.topRight,.topLeft,.bottomLeft,.bottomRight], radius: 25, borderColor: .gray, borderWidth: 1)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.messageView.updateBorderView(corners: [.topLeft, .topRight], radius: 18, borderColor: .white, borderWidth: 1)
        }, completion: nil)
    }
    private func setupUI() {
        makeCircularViews()
        setupPopImageGesture()
        setupSendImageGesture()
    }
    private func makeCircularViews() {
        avatarImage.layer.cornerRadius = avatarImage.frame.width / 2
        avatarImage.layer.masksToBounds = true
        borderPhotoView.layer.cornerRadius = avatarImage.frame.width / 2
        borderPhotoView.layer.masksToBounds = true
    }
    private func setupTableView() {
        messageTable.register(UINib(nibName: "SentMessagesTableViewCell", bundle: nil), forCellReuseIdentifier: "SentMessageCell")
        messageTable.register(UINib(nibName: "ReceivedMessagesTableViewCell", bundle: nil), forCellReuseIdentifier: "ReceivedMessageCell")
        messageTable.delegate = self
        messageTable.dataSource = self
        // UITableViewAutomaticDimension
        messageTable.estimatedRowHeight = 44.0
        messageTable.rowHeight = UITableView.automaticDimension
        messageTable.separatorStyle = .none
    }
    private func displayFriendInformation(){
        if let friend = friend {
            fullNameLabel.text = friend.fullname
            if let imageUrl = URL(string: friend.image) {
                avatarImage.loadImage(from: imageUrl)
            }
        }
    }
    private func setupPopImageGesture() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(handlePopImageTap))
        popImage.addGestureRecognizer(tapGesture)
        popImage.isUserInteractionEnabled = true
    }
    @objc private func handlePopImageTap() {
        AppRouters.homeTabBar.navigate(from: self)
    }
    private func setupSendImageGesture() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(handleSendImageTap))
        sendImage.addGestureRecognizer(tapGesture)
        sendImage.isUserInteractionEnabled = true
    }
    @objc private func handleSendImageTap() {
        guard let text = messageTextField.text, !text.isEmpty else {
            return
        }
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            return
        }
        guard let friendID = friend?.uid else {
            return
        }
        // Prepare message data
        let messageData: [String: Any] = [
            "senderID": currentUserID,
            "receiverID": friendID,
            "messageContent": text,
            "timestamp": Timestamp(date: Date())
        ]

        // Use FirebaseService to send message
        FirebaseService.shared.sendMessage(chatID: chatID ?? "",
                                           senderID: currentUserID,
                                           receiverID: friendID,
                                           messageContent: text) { [self] result in
            switch result {
                case .success:
                    self.messageTextField.text = ""
                    self.fetchMessages(chatID: chatID ?? "")
                case .failure(let error):
                    print("Failed to send message: \(error.localizedDescription)")
            }
        }
        
    }
    private func fetchMessages(chatID: String) {
        messagesListener = FirebaseService.shared.addMessagesListener(chatID: chatID) {
            [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let messages):
                print("Fetched messages: \(messages)")
                DispatchQueue.main.async {
                    self.messages = messages
                    self.messageTable.reloadData()
                    self.scrollToBottom()
                }
            case .failure(let error):
                print("Failed to fetch messages: \(error.localizedDescription)")
            }
        }
    }
    private func scrollToBottom() {
        guard !messages.isEmpty else { return }
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        messageTable.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    deinit {
        messagesListener?.remove()
    }
}
extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let currentUserID = Auth.auth().currentUser?.uid
        if message.senderID == currentUserID {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SentMessageCell", for: indexPath) as? SentMessagesTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: message)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReceivedMessageCell", for: indexPath) as? ReceivedMessagesTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: message)
            return cell
        }
    }
    
    
}
