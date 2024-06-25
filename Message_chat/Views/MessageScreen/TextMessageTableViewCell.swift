//
//  TextMessageTableViewCell.swift
//  Message_chat
//
//  Created by Minh Vũ on 20/06/2024.
//

import UIKit

class TextMessageTableViewCell: UITableViewCell {

    
    @IBOutlet weak var borderContentView: UIView!
    @IBOutlet weak var borderMessage: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        //borderContentView.updateBorderView(corners: [.topRight, .topLeft, .bottomLeft, .bottomRight], radius: 25, borderColor: .blue, borderWidth: 1)
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
