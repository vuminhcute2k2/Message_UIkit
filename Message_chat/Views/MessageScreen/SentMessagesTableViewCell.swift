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
        borderMessage.updateBorderView(corners: [.topRight, .topLeft, .bottomLeft, .bottomRight], radius: 25, borderColor: .clear, borderWidth: 1)
        setupConstraints()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.layoutIfNeeded()
//        setupConstraints()
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
        self.layoutIfNeeded()
    }
    private func setupConstraints() {
//        messageLabel.translatesAutoresizingMaskIntoConstraints = false
//        borderMessage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.6)
        ])
    }
}
