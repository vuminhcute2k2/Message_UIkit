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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    func setData(myFriends: Friends){
        avatarImage.image = UIImage(named: myFriends.avatarImage)
        nameLabel.text = myFriends.name
    }
    
}
