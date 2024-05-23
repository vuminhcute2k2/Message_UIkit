//
//  LoginViewController.swift
//  Message_chat
//
//  Created by Minh Vũ on 15/05/2024.
//

import UIKit

class LoginViewController: UIViewController {
    
    
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
            print("Failed to load images")
        }
//        textFieldEmail.setUpRightSideImage(ImageViewNamed: "icon_email")
//        textFieldPassworld.setUpRightSideImage(ImageViewNamed: "icon_key")
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
        iconView.frame = CGRect(x: 0, y: 0, width: 24, height: 24) // Điều chỉnh kích thước icon lớn hơn

        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 24))
        containerView.addSubview(iconView)
        iconView.center = containerView.center

        textField.rightView = containerView
        textField.rightViewMode = .always
    }
}
//extension UITextField{
//    func setUpRightSideImage(ImageViewNamed: String){
//        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
//        imageView.image = UIImage(named: ImageViewNamed)
//        let imageViewContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
//        rightView = imageViewContainerView
//        rightViewMode = .always
//        self.tintColor = .lightGray
//    }
//}
