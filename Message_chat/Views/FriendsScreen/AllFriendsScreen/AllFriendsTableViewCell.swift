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
    var user: User?
    var addFriendAction: ((User) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        makeCircularViews()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    private func makeCircularViews() {
        avatarImage.layer.cornerRadius = avatarImage.frame.width / 2
        avatarImage.layer.masksToBounds = true
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
    }
    
    @IBAction func addFriendsTapped(_ sender: Any) {
        if let user = user{
            print("Nhấn kết bạn cho người dùng: \(user.fullName)")
            addFriendAction?(user)
        }else{
            print("Không có gì sảy ra")
        }
    }
}
