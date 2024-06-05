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
    func setData(allFriends: AllFriends){
        avatarImage.image = UIImage(named:allFriends.avatarImage)
        nameLabel.text = allFriends.name
    }
    
}
