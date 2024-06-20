//
//  ConversationsViewController.swift
//  Message_chat
//
//  Created by Minh Vũ on 20/06/2024.
//

import UIKit

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
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
        
        // Do any additional setup after loading the view.
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
    }
    private func makeCircularViews() {
        avatarImage.layer.cornerRadius = avatarImage.frame.width / 2
        avatarImage.layer.masksToBounds = true
        borderPhotoView.layer.cornerRadius = avatarImage.frame.width / 2
        borderPhotoView.layer.masksToBounds = true
    }
    private func setupTableView() {
        let nib = UINib(nibName: "TextMessageTableViewCell", bundle: nil)
        messageTable.register(nib, forCellReuseIdentifier: "TextMessageTableViewCell")
        messageTable.delegate = self
        messageTable.dataSource = self
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
   
}
extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextMessageTableViewCell", for: indexPath) as? TextMessageTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
}
