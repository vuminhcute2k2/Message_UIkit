//
//  AcceptFriendsTableViewCell.swift
//  Message_chat
//
//  Created by Minh Vũ on 01/06/2024.
//

import UIKit

class AcceptFriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    var acceptButtonTapped: (() -> Void)?
    var user: User? 
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImage.makeCircular()
        acceptButton.addTarget(self, action: #selector(handleAcceptButtonTapped), for: .touchUpInside)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func handleAcceptButtonTapped(_ sender: Any) {
        acceptButtonTapped?()
    }
    func setData(user: User) {
        self.user = user
        nameLabel.text = user.fullName
        if !user.image.isEmpty, let imageURL = URL(string: user.image) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL) {
                    DispatchQueue.main.async {
                        self.avatarImage.image = UIImage(data: imageData)
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.avatarImage.image = UIImage(named: "image_avatar")
            }
        }
    }
}
