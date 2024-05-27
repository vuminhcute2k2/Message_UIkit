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

    
    @IBOutlet weak var buttonLogin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Thiết lập màu cho text
        labelDangNhap.textColor = UIColor(red: 0.26, green: 0.34, blue: 0.71, alpha: 1.00)

        // Thiết lập placeholder cho textFieldEmail và textFieldPassword
        textFieldEmail.placeholder = "yourname@gmail.com"
        textFieldPassworld.placeholder = "Password"

        // Xóa viền cho textField
        textFieldEmail.borderStyle = .none
            textFieldPassworld.borderStyle = .none

        // Thêm đường kẻ bên dưới textFieldEmail và textFieldPassword
        addBottomLine(to: textFieldEmail)
        addBottomLine(to: textFieldPassworld)

        // Thiết lập button login
        setUpButtonLogin(button: buttonLogin)

        // Thêm icon vào bên phải của textFieldEmail và textFieldPassword

        if let emailIcon = UIImage(named: "icon_email"), let passwordIcon = UIImage(named: "icon_key") {
            addRightIcon(to: textFieldEmail, icon: emailIcon)
            addRightIcon(to: textFieldPassworld, icon: passwordIcon)
        } else {
            print("Failed images")
        }

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
        button.layer.masksToBounds = true // Đảm bảo rằng các góc của button bị cắt đi theo cornerRadius
    }

    private func addRightIcon(to textField: UITextField, icon: UIImage) {
        let iconView = UIImageView(image: icon)
        iconView.contentMode = .scaleAspectFit
        iconView.frame = CGRect(x: 0, y: 0, width: 24, height: 14) // Điều chỉnh kích thước icon lớn hơn

        textField.rightView = iconView
        textField.rightViewMode = .always
    }


    @IBAction func navigationButtonLogin(_ sender: Any) {
        let registerController = RegisterAccountViewController(nibName: "RegisterAccountViewController", bundle: nil)
                registerController.modalPresentationStyle = .fullScreen // Hoặc kiểu trình bày khác mà bạn muốn
                self.present(registerController, animated: true, completion: nil)
       
    }
    

}
