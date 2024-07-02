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
        makeCircularViews()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    private func makeCircularViews() {
        imageAvatar.layer.cornerRadius = imageAvatar.frame.width / 4
        imageAvatar.layer.masksToBounds = true

    }
    func configure(with conversation: Conversation) {
        if let url = URL(string: conversation.friendImage) {
            imageAvatar.loadImage(from: url)
        }
        textname.text = conversation.friendName
        textmessage.text = conversation.lastMessage
        texttime.text = formatTimestamp(conversation.timestamp)
    }

    private func formatTimestamp(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }

}
