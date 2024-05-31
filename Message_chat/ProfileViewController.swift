//
//  ProfileViewController.swift
//  Message_chat
//
//  Created by Minh Vũ on 28/05/2024.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var homeBackgroundView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var borderMessageTextField: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var languageIcon: UIImageView!
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var reuseView: UIView!
    @IBOutlet weak var profileView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeBackgroundView.updateGradientFrame()
        profileView.updateBorderView(corners: [.topLeft, .topRight], radius: 18, borderColor: .white, borderWidth: 1)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.profileView.updateBorderView(corners: [.topLeft, .topRight], radius: 18, borderColor: .white, borderWidth: 1)
        }, completion: nil)
    }
    private func setupUI() {
        if let searchIcon = UIImage(named: "icon_search") {
            searchTextField.addLeftIcon(searchIcon)
        } else {
            print("Failed images")
        }
        borderMessageTextField.customizeBorder(cornerRadius: 18, borderWidth: 1, borderColor: .white)
        searchButton.customizeButton(withImage: "message_add", backgroundColor: .white, cornerRadius: 20)
        makeImageProfileCircular()
        customizeButtonEditProfile()
        //add border bottom view
        languageView.addBottomBorder(with: .gray, width: 1)
        notificationView.addBottomBorder(with: .gray, width: 1)
        reuseView.addBottomBorder(with: .gray, width: 1)
    }
    private func customizeButtonEditProfile() {
        editProfileButton.setImage(UIImage(named: "icon_editProfile"), for: .normal)
        editProfileButton.setTitle("", for: .normal)
        editProfileButton.backgroundColor = .none
        editProfileButton.layer.borderWidth = 0
        editProfileButton.layer.cornerRadius = 20
        editProfileButton.layer.masksToBounds = true
    }
    private func makeImageProfileCircular() {
        // profileImage circle
        profileImage.layer.cornerRadius =
        profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 2.0
        profileImage.layer.borderColor = UIColor.blue.cgColor
        profileImage.contentMode = .scaleToFill
    }
}
