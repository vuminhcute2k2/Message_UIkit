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
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImage.makeCircular()
        addFriendsButton.titleLabel?.font = UIFont(name: "Palatino-BoldItalic", size: 16)

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setData(user: User) {
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
        FirebaseService.shared.checkFriendRequestStatus(for: user) { [weak self] isSent in
            DispatchQueue.main.async {
                self?.isFriendRequestSent = isSent
            }
        }
    }
    private func updateButtonTitle() {
        if isFriendRequestSent {
            addFriendsButton.setTitle("Hủy", for: .normal)
        } else {
            addFriendsButton.setTitle("Kết bạn", for: .normal)
        }
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
