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
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setData(user: User) {
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
}
