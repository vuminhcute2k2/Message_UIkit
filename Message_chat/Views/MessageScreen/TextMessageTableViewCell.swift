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
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        borderMessage.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //borderMessage.updateBorderView(corners: [.topRight, .topLeft, .bottomLeft, .bottomRight], radius: 25, borderColor: .blue, borderWidth: 1)
        borderMessage.layer.cornerRadius = 25
        borderMessage.layer.borderWidth = 1
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func configure(with message: Messages, currentUserID: String?) {
        messageLabel.text = message.messageContent
        let isCurrentUser = message.senderID == currentUserID
        borderMessage.backgroundColor = isCurrentUser ? UIColor.blue : UIColor.red
        borderMessage.layer.borderColor = isCurrentUser ? UIColor.blue.cgColor : UIColor.red.cgColor
        
        // Adjust alignment and constraints
        messageLabel.textAlignment = isCurrentUser ? .right : .left
        
        // Example layout adjustments
        if isCurrentUser {
            // Align message to the right
            borderMessage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
            borderMessage.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 50).isActive = true
        } else {
            // Align message to the left
            borderMessage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
            borderMessage.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -50).isActive = true
        }
        let screenWidth = UIScreen.main.bounds.width
        let messageWidth = screenWidth * 0.6
        borderMessage.widthAnchor.constraint(equalToConstant: messageWidth).isActive = true
        
    }
    
}
