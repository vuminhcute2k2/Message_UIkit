//
//  ProfileViewController.swift
//  Message_chat
//
//  Created by Minh Vũ on 28/05/2024.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var homeBackgroundView: UIView!
    @IBOutlet weak var buttonSearch: UIButton!
    @IBOutlet weak var borderTextFeildMessage: UIView!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var buttonEditProfile: UIButton!
    @IBOutlet weak var iconLanguage: UIImageView!
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var reuseView: UIView!
    @IBOutlet weak var profileView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBackgroundImage()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeBackgroundView.updateGradientFrame()
        updateBoderViewProfile()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.setupBackgroundImage()
            self.updateBoderViewProfile()
        }, completion: nil)
    }
    private func setupBackgroundImage() {
        if let backgroundImage = UIImage(named: "image_backgroud") {
            imageBackground.image = backgroundImage
            imageBackground.contentMode = .scaleToFill
        } else {
            print("Failed to set background image")
        }
    }
    private func setupUI() {
        if let searchIcon = UIImage(named: "icon_search") {
            addLeftIcon(to: textFieldSearch, icon: searchIcon)
        } else {
            print("Failed images")
        }
        customizeBoderViewSearch()
        customizeButtonSearchMessage()
        makeImageProfileCircular()
        customizeButtonEditProfile()
        //add border bottom view
        languageView.addBottomBorder(with: .gray, width: 1)
        notificationView.addBottomBorder(with: .gray, width: 1)
        reuseView.addBottomBorder(with: .gray, width: 1)
    }
    private func addLeftIcon(to textField: UITextField, icon: UIImage) {
        let iconView = UIImageView(image: icon)
        iconView.contentMode = .scaleAspectFit
        iconView.frame = CGRect(x: 0, y: 0, width: 24, height: 14)
        textField.leftView = iconView
        textField.leftViewMode = .always
    }
    private func customizeBoderViewSearch() {
        borderTextFeildMessage.layer.cornerRadius = 18
        borderTextFeildMessage.layer.masksToBounds = true
        borderTextFeildMessage.layer.borderWidth = 1
        borderTextFeildMessage.layer.borderColor = UIColor.white.cgColor
    }
    private func customizeButtonSearchMessage() {
        buttonSearch.setImage(UIImage(named: "message_add"), for: .normal)
        buttonSearch.setTitle("", for: .normal)
        buttonSearch.backgroundColor = UIColor.white
        buttonSearch.layer.borderWidth = 0
        buttonSearch.layer.cornerRadius = 20
        buttonSearch.layer.masksToBounds = true
    }
    private func customizeButtonEditProfile() {
        buttonEditProfile.setImage(UIImage(named: "icon_editProfile"), for: .normal)
        buttonEditProfile.setTitle("", for: .normal)
        buttonEditProfile.backgroundColor = .none
        buttonEditProfile.layer.borderWidth = 0
        buttonEditProfile.layer.cornerRadius = 20
        buttonEditProfile.layer.masksToBounds = true
    }
    private func makeImageProfileCircular() {
        // Thiết lập cho imageProfile để nó trở thành hình tròn
        imageProfile.layer.cornerRadius =
        imageProfile.frame.size.width / 2
        imageProfile.clipsToBounds = true
        imageProfile.layer.borderWidth = 2.0
        imageProfile.layer.borderColor = UIColor.blue.cgColor
        imageProfile.contentMode = .scaleToFill
    }
    private func updateBoderViewProfile() {
        let radius: CGFloat = 18
        let path = UIBezierPath(
            roundedRect: profileView.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        profileView.layer.mask = mask
        // Removing existing border layers
        if let sublayers = profileView.layer.sublayers {
            for layer in sublayers {
                if layer is CAShapeLayer {
                    layer.removeFromSuperlayer()
                }
            }
        }
        // Adding new border layer
        let borderLayer = CAShapeLayer()
        borderLayer.path = path.cgPath
        borderLayer.strokeColor = UIColor.white.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 1
        profileView.layer.addSublayer(borderLayer)
    }
}
