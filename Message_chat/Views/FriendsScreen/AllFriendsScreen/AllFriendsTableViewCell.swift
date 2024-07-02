//
//  AllFriendsTableViewCell.swift
//  Message_chat
//
//  Created by Minh Vũ on 06/06/2024.
//

import UIKit

class AllFriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addFriendsButton: UIButton!
    var user: User?
    var addFriendAction: ((User) -> Void)?
    var cancelFriendAction: ((User) -> Void)?
    var isFriendRequestSent: Bool = false {
        didSet {
            updateButtonTitle()
        }
    }
    var isAlreadyFriend: Bool = false {
        didSet {
            updateButtonVisibility()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImage.makeCircular()
        addFriendsButton.titleLabel?.font = UIFont(name: "Palatino-BoldItalic", size: 16)
        updateButtonVisibility()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setData(user: User, isAlreadyFriend: Bool) {
        self.user = user
        nameLabel.text = user.fullName
        if let imageURL = URL(string: user.image) {
            DispatchQueue.global().async { [weak self] in
                if let imageData = try? Data(contentsOf: imageURL) {
                    DispatchQueue.main.async {
                        self?.avatarImage.image = UIImage(data: imageData)
                    }
                }
            }
        } else {
            avatarImage.image = UIImage(named: "image_avatar")
        }
        FirebaseService.shared.checkFriendRequestStatus(for: user) { [weak self] result in
            switch result {
            case .success(let isSent):
                DispatchQueue.main.async {
                    self?.isFriendRequestSent = isSent
                    self?.addFriendsButton.isHidden = isAlreadyFriend
                }
            case .failure(let error):
                print("Error checking friend request status: \(error.localizedDescription)")
                // Handle error if needed
            }
        }
    }
    private func updateButtonTitle() {
        if isFriendRequestSent {
            addFriendsButton.setTitle("Cancel", for: .normal)
        } else {
            addFriendsButton.setTitle("Add", for: .normal)
        }
        updateButtonVisibility()
    }
    private func updateButtonVisibility() {
        addFriendsButton.isHidden = user == nil || isFriendRequestSent
    }
    @IBAction func addFriendsTapped(_ sender: Any) {
        guard let user = user else { return }
        if isFriendRequestSent {
            cancelFriendAction?(user)
        } else {
            addFriendAction?(user)
        }
    }
}
