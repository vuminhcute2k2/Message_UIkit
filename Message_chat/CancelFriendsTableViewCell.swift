//
//  CancelFriendsTableViewCell.swift
//  Message_chat
//
//  Created by Minh Vũ on 01/06/2024.
//

import UIKit

class CancelFriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setData(cancel:CancelFriends) {
        avatarImage.image = UIImage(named: cancel.avatarImageName)
        nameLabel.text = cancel.name
    }
}
