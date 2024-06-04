//
//  AcceptFriendsTableViewCell.swift
//  Message_chat
//
//  Created by Minh Vũ on 01/06/2024.
//

import UIKit

class AcceptFriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setData(friendsrequest:FriendRequest) {
        avatarImage.image = UIImage(named: friendsrequest.avatarImageName)
        nameLabel.text = friendsrequest.name
    }
}
