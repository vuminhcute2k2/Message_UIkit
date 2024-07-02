//
//  SentImageMessageTableViewCell.swift
//  Message_chat
//
//  Created by Minh Vũ on 27/6/24.
//

import UIKit

class SentImageMessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var borderMessage: UIView!
    
    @IBOutlet weak var messageImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupConstraints()
        setupBorder()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    private func setupBorder() {
        borderMessage.layer.cornerRadius = 20
        borderMessage.layer.borderWidth = 1
        borderMessage.layer.borderColor = UIColor.clear.cgColor
        borderMessage.layer.masksToBounds = true
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        messageImageView.image = nil
    }
    func configure(with message: Messages) {
        if let imageURL = message.imageURL, let url = URL(string: imageURL) {
            messageImageView.loadImage(from: url) { [weak self] image in
                guard let self = self, let image = image else { return }
                self.updateImageViewConstraints(for: image)
            }
        }
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            messageImageView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.6)
        ])
    }
    private func updateImageViewConstraints(for image: UIImage) {
        let aspectRatio = image.size.width / image.size.height
        NSLayoutConstraint.activate([
            messageImageView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.6),
            messageImageView.heightAnchor.constraint(equalTo: messageImageView.widthAnchor, multiplier: 1/aspectRatio)
        ])
    }

}
