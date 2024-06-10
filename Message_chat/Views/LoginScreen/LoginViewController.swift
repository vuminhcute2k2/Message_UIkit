//
//  LoginViewController.swift
//  Message_chat
//
//  Created by Minh Vũ on 15/05/2024.
//

import UIKit
final class LoginViewController: UIViewController {
    @IBOutlet weak var labelDangNhap: UILabel!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassworld: UITextField!
    @IBOutlet weak var labelRegister: UILabel!
    @IBOutlet weak var buttonLogin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        labelDangNhap.textColor = UIColor(red: 0.26, green: 0.34, blue: 0.71, alpha: 1.00)
        textFieldEmail.placeholder = "yourname@gmail.com"
        textFieldPassworld.placeholder = "Password"
        textFieldEmail.borderStyle = .none
        textFieldPassworld.borderStyle = .none
        addBottomLine(to: textFieldEmail)
        addBottomLine(to: textFieldPassworld)
        //button login
        setUpButtonLogin(button: buttonLogin)
        if let emailIcon = UIImage(named: "icon_email"),
           let passwordIcon = UIImage(named: "icon_key") {
            addRightIcon(to: textFieldEmail, icon: emailIcon)
            addRightIcon(to: textFieldPassworld, icon: passwordIcon)
        } else {
            print("Failed images")
        }
        // Thêm gesture recognizer cho labelDangKy
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(navigateToRegister))
        labelRegister.isUserInteractionEnabled = true
        labelRegister.addGestureRecognizer(tapGestureRecognizer)

    }
    private func addBottomLine(to textField: UITextField) {
        let bottomLineView = UIView()
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        bottomLineView.backgroundColor = UIColor.gray
        textField.addSubview(bottomLineView)
        NSLayoutConstraint.activate([
        bottomLineView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
        bottomLineView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
        bottomLineView.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
        bottomLineView.heightAnchor.constraint(equalToConstant: 1.0)
        ])
    }
    private func setUpButtonLogin(button: UIButton) {
        button.layer.backgroundColor = UIColor(red: 0.26, green: 0.34, blue: 0.71, alpha: 1.00).cgColor
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
    }
    private func addRightIcon(to textField: UITextField, icon: UIImage) {
        let iconView = UIImageView(image: icon)
        iconView.contentMode = .scaleAspectFit
        iconView.frame = CGRect(x: 0, y: 0, width: 24, height: 14)
        textField.rightView = iconView
        textField.rightViewMode = .always
    }
    @IBAction func navigationButtonLogin(_ sender: Any) {
        AppRouters.homeTabBar.navigate(from: self)
    }
    @objc private func navigateToRegister() {
        let registerController = RegisterAccountViewController(nibName: "RegisterAccountViewController", bundle: nil)
        registerController.modalPresentationStyle = .fullScreen
        self.present(registerController, animated: true, completion: nil)
    }
}
