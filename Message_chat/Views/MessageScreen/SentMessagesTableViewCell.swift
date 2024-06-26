//
//  SentMessagesTableViewCell.swift
//  Message_chat
//
//  Created by Minh Vũ on 26/06/2024.
//

import UIKit

class SentMessagesTableViewCell: UITableViewCell {

    @IBOutlet weak var borderMessage: UIView!
    
    @IBOutlet weak var messageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        setupConstraints()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
       setupBorder()
    }
    private func setupBorder() {
        borderMessage.layer.cornerRadius = 20
        borderMessage.layer.borderWidth = 1
        borderMessage.layer.borderColor = UIColor.clear.cgColor
        borderMessage.layer.masksToBounds = true
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func configure(with message: Messages) {
        messageLabel.text = message.messageContent
    }
    private func setupConstraints() {        
        NSLayoutConstraint.activate([
            messageLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.6)
        ])
    }
}
