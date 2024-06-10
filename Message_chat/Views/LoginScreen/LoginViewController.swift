//
//  LoginViewController.swift
//  Message_chat
//
//  Created by Minh Vũ on 15/05/2024.
//

import UIKit
import FirebaseAuth

final class LoginViewController: UIViewController {
    @IBOutlet weak var labelDangNhap: UILabel!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassworld: UITextField!
    @IBOutlet weak var labelRegister: UILabel!
    @IBOutlet weak var buttonLogin: UIButton!
    let MINIMUM_PASSWORD_CHARACTERS = 8
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
        guard let email = textFieldEmail.text, !email.isEmpty,
              let password = textFieldPassworld.text, !password.isEmpty else {
            showAlert(message: "Vui lòng nhập đầy đủ email và password.")
            return
        }
        guard password.count >= MINIMUM_PASSWORD_CHARACTERS else {
            showAlert(message: "Mật khẩu phải có ít nhất \(MINIMUM_PASSWORD_CHARACTERS) ký tự.")
            return
        }
        FirebaseService.shared.login(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                UserDefaults.standard.set(user.uid, forKey: "uid")
                UserDefaults.standard.set(email, forKey: "email")
                UserDefaults.standard.set(password, forKey: "password")
                print("User logged in with UID: \(user.uid)")
                AppRouters.homeTabBar.navigate(from: self)
            case .failure(let error):
                var errorMessage: String
                let errorCode = (error as NSError).code
                switch errorCode {
                case AuthErrorCode.invalidEmail.rawValue:
                    errorMessage = "Địa chỉ email không đúng định dạng."
                default:
                    errorMessage = "Đã xảy ra lỗi khi đăng nhập: \(error.localizedDescription)"
                    print("Đã xảy ra lỗi khi đăng nhập: \(error.localizedDescription)")
                }
                self.showAlert(message: errorMessage)
            }
        }
    }
    @objc private func navigateToRegister() {
        AppRouters.register.navigate(from: self)
    }
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true, completion: nil)
    }
}
