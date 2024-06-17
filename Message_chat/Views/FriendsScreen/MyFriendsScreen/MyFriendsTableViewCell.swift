//
//  MyFriendsTableViewCell.swift
//  Message_chat
//
//  Created by Minh Vũ on 04/06/2024.
//

import UIKit

class MyFriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImage.makeCircular()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    func setData(friend: Friend) {
        nameLabel.text = friend.fullname
        if !friend.image.isEmpty, let imageURL = URL(string: friend.image) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL) {
                    DispatchQueue.main.async {
                        self.avatarImage.image = UIImage(data: imageData)
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.avatarImage.image = UIImage(named: "image_avatar")
            }
        }
    }
    
}
