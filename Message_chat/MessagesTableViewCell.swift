//
//  MessagesTableViewCell.swift
//  Message_chat
//
//  Created by Minh Vũ on 29/05/2024.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {

    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var textname: UILabel!
    @IBOutlet weak var textmessage: UILabel!
    @IBOutlet weak var texttime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
