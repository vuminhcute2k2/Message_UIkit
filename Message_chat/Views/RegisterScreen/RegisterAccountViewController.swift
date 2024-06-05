//
//  RegisterAccountViewController.swift
//  Message_chat
//
//  Created by Minh Vũ on 26/05/2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
class RegisterAccountViewController: UIViewController {
    @IBOutlet weak var labelDangKy: UILabel!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var labelCheckBox: UILabel!
    @IBOutlet weak var textFieldPassworld: UITextField!
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var ButtonRegister: UIButton!
    @IBOutlet weak var labelDangNhap: UILabel!
    @IBOutlet weak var buttonBackLogin: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        labelDangKy.textColor = UIColor(red: 0.26, green: 0.34, blue: 0.71, alpha: 1.00)
        textFieldEmail.placeholder = "yourname@gmail.com"
        textFieldPassworld.placeholder = "*******"
        textFieldName.placeholder = "Họ và tên"
        textFieldName.borderStyle = .none
        textFieldEmail.borderStyle = .none
        textFieldPassworld.borderStyle = .none
        // bottomline textField
        addBottomLine(to: textFieldName)
        addBottomLine(to: textFieldEmail)
        addBottomLine(to: textFieldPassworld)
        // Thêm icon vào bên phải của textFieldEmail và textFieldPassword
        if let userIcon = UIImage(named: "icon_user"), let emailIcon = UIImage(named: "icon_email"), let passwordIcon = UIImage(named: "icon_key") {
            addRightIcon(to: textFieldEmail, icon: emailIcon)
            addRightIcon(to: textFieldPassworld, icon: passwordIcon)
            addRightIcon(to: textFieldName, icon: userIcon)
        } else {
            print("Failed images")
        }
        // imageCheckbox
        checkBox.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        checkBox.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        checkBox.tintColor = .systemBlue
        // delete background and border UIButton
        checkBox.setTitle("", for: .normal)
        checkBox.backgroundColor = UIColor.white
        checkBox.layer.borderWidth = 0
        labelCheckBox.setCheckBoxText("Tôi đồng ý với chính sách và điều khoản")
        setUpButtonRegister(button: ButtonRegister)
        labelDangNhap.setDangNhapText("Đã có tài khoản? Đăng nhập ngay")
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backToLogin))
        buttonBackLogin.isUserInteractionEnabled = true
        buttonBackLogin.addGestureRecognizer(tapGestureRecognizer)
    }
    @IBAction func registerTapped(_ sender: UIButton) {
        guard let email = textFieldEmail.text, !email.isEmpty,
              let password = textFieldPassworld.text, !password.isEmpty,
              let name = textFieldName.text, !name.isEmpty else {
            // Hiển thị một cảnh báo hoặc thông báo cho người dùng
            print("Vui lòng điền đầy đủ thông tin")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Lỗi khi tạo tài khoản: \(error.localizedDescription)")
                return
            }
            guard let user = authResult?.user else { return }

            let newUser = User(email: email, numberPhone: "", uid: user.uid, image: "", birthday: "", fullName: name, password: password, followers: [], following: [])
            let db = Firestore.firestore()
            db.collection("users").document(user.uid).setData(newUser.toJson()) { error in
                if let error = error {
                    print("Lỗi khi lưu thông tin người dùng: \(error.localizedDescription)")
                } else {
                    let homeTabBarController = HomeTabBarController(nibName: "HomeTabBarController", bundle: nil)
                    homeTabBarController.modalPresentationStyle = .fullScreen
                    self.present(homeTabBarController, animated: true, completion: nil)
                }
            }
        }
    }
    @IBAction func checkBoxTapper(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @objc private func backToLogin() {
        self.dismiss(animated: true, completion: nil)
    }
    private func setUpButtonRegister(button: UIButton) {
        button.layer.backgroundColor = UIColor(red: 0.26, green: 0.34, blue: 0.71, alpha: 1.00).cgColor
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
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
    private func addRightIcon(to textField: UITextField, icon: UIImage) {
        let iconView = UIImageView(image: icon)
        iconView.contentMode = .scaleAspectFit
        iconView.frame = CGRect(x: 0, y: 0, width: 24, height: 14)
        textField.rightView = iconView
        textField.rightViewMode = .always
    }
}
