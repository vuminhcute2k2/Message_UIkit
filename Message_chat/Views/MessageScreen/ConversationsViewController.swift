//
//  ConversationsViewController.swift
//  Message_chat
//
//  Created by Minh Vũ on 20/06/2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
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
    var selectedImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
        displayFriendInformation()
        messageTable.separatorStyle = .none
        // Ensure chatID is set before fetching messages
        setupBorderPhotoViewGesture()
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
        messageTable.register(UINib(nibName: "SentImageMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "SentImageMessageCell")
        messageTable.register(UINib(nibName: "ReceivedMessagesTableViewCell", bundle: nil), forCellReuseIdentifier: "ReceivedMessageCell")
        messageTable.register(UINib(nibName: "ReceivedIsmagesTableViewCell", bundle: nil), forCellReuseIdentifier: "ReceivedImagesCell")
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
                                                action: #selector(handleSendTap))
        sendImage.addGestureRecognizer(tapGesture)
        sendImage.isUserInteractionEnabled = true
    }
    private func setupBorderPhotoViewGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBorderPhotoViewTap))
        borderPhotoView.addGestureRecognizer(tapGesture)
        borderPhotoView.isUserInteractionEnabled = true
    }

    @objc private func handleBorderPhotoViewTap() {
        presentImagePicker()
    }

    private func presentImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    @objc private func handleSendTap() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            return
        }
        guard let friendID = friend?.uid else {
            return
        }
        let text = messageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let hasText = !text.isEmpty
        let hasImage = selectedImage != nil
        
        if hasImage {
            sendImageMessage(selectedImage!, withText: hasText ? text : nil)
        } else if hasText {
            sendTextMessage(text)
        }
    }
    private func sendTextMessage(_ text: String) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            return
        }
        guard let friendID = friend?.uid else {
            return
        }
        let messageData: [String: Any] = [
            "senderID": currentUserID,
            "receiverID": friendID,
            "messageContent": text,
            "timestamp": Timestamp(date: Date())
        ]
        
        FirebaseService.shared.sendMessage(chatID: self.chatID ?? "",
                                           senderID: currentUserID,
                                           receiverID: friendID,
                                           imageURL: "", messageContent: text) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.messageTextField.text = ""
                    self.fetchMessages(chatID: self.chatID ?? "")
                }
            case .failure(let error):
                print("Failed to send message: \(error.localizedDescription)")
            }
        }
    }
    private func sendImageMessage(_ image: UIImage, withText text: String?) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            return
        }
        guard let friendID = friend?.uid else {
            return
        }
        uploadImageToStorage(image) { [weak self] result in
            switch result {
            case .success(let imageURL):
                var messageData: [String: Any] = [
                    "senderID": currentUserID,
                    "receiverID": friendID,
                    "imageURL": imageURL,
                    "timestamp": Timestamp(date: Date())
                ]
                if let text = text {
                    messageData["messageContent"] = text
                }
                
                FirebaseService.shared.sendMessage(chatID: self?.chatID ?? "",
                                                   senderID: currentUserID,
                                                   receiverID: friendID,
                                                   imageURL: imageURL,
                                                   messageContent: text ?? "") { result in
                    switch result {
                    case .success:
                        DispatchQueue.main.async {
                            self?.messageTextField.text = ""
                            self?.selectedImage = nil
                            self?.sendImage.image = UIImage(named: "icon_send")
                            self?.fetchMessages(chatID: self?.chatID ?? "")
                        }
                    case .failure(let error):
                        print("Failed to send message: \(error.localizedDescription)")
                    }
                }
                
            case .failure(let error):
                print("Failed to upload image: \(error.localizedDescription)")
            }
        }
    }
    private func uploadImageToStorage(_ image: UIImage, 
                                      completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageConversion", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])))
            return
        }
        let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let downloadURL = url else {
                    completion(.failure(NSError(domain: "URLFetch", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL"])))
                    return
                }
                
                completion(.success(downloadURL.absoluteString))
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
extension ConversationsViewController: UITableViewDelegate,
                                       UITableViewDataSource,
                                       UIImagePickerControllerDelegate,
                                       UINavigationControllerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let currentUserID = Auth.auth().currentUser?.uid
        if message.senderID == currentUserID {
            if let imageUrl = message.imageURL, !imageUrl.isEmpty {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SentImageMessageCell", for: indexPath) as? SentImageMessageTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(with: message)
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SentMessageCell", for: indexPath) as? SentMessagesTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(with: message)
                return cell
            }
        } else {
            if let imageUrl = message.imageURL, !imageUrl.isEmpty {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReceivedImagesCell", for: indexPath) as? ReceivedIsmagesTableViewCell else {
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

    func imagePickerController(_ picker: UIImagePickerController, 
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Dismiss the picker view controller
        picker.dismiss(animated: true, completion: nil)
        if let selectedImage = info[.originalImage] as? UIImage {
            sendImage.image = selectedImage
            self.selectedImage = selectedImage
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
