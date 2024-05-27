//
//  RegisterAccountViewController.swift
//  Message_chat
//
//  Created by Minh Vũ on 26/05/2024.
//

import UIKit

class RegisterAccountViewController: UIViewController {

    
    @IBOutlet weak var labelDangKy: UILabel!
    
    
    @IBOutlet weak var textFieldName: UITextField!
    
    
    @IBOutlet weak var textFieldEmail: UITextField!
    
    
    @IBOutlet weak var labelCheckBox: UILabel!
    @IBOutlet weak var textFieldPassworld: UITextField!
    
    
    @IBOutlet weak var checkBox: UIButton!
    
    
    @IBOutlet weak var ButtonRegister: UIButton!
    
    
    @IBOutlet weak var labelDangNhap: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelDangKy.textColor = UIColor(red: 0.26, green: 0.34, blue: 0.71, alpha: 1.00)

        // Thiết lập placeholder cho textFieldEmail và textFieldPassword
        textFieldEmail.placeholder = "yourname@gmail.com"
        textFieldPassworld.placeholder = "*******"
        textFieldName.placeholder = "Họ và tên"
        // Xóa viền cho textField
        textFieldName.borderStyle = .none
        textFieldEmail.borderStyle = .none
        textFieldPassworld.borderStyle = .none
        // Thêm đường kẻ bên dưới textField
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
        
        // Thiết lập hình ảnh cho trạng thái không chọn và chọn của checkbox
        checkBox.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        checkBox.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        checkBox.tintColor = .systemBlue
        // Loại bỏ nền và viền của UIButton
        checkBox.setTitle("", for: .normal)
        checkBox.backgroundColor = UIColor.white
        checkBox.layer.borderWidth = 0
        
        labelCheckBox.setCheckBoxText("Tôi đồng ý với chính sách và điều khoản")
        setUpButtonRegister(button: ButtonRegister)
        
        labelDangNhap.setDangNhapText("Đã có tài khoản? Đăng nhập ngay")
       
    }
 
    @IBAction func checkBoxTapper(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    private func setUpButtonRegister(button: UIButton) {
        button.layer.backgroundColor = UIColor(red: 0.26, green: 0.34, blue: 0.71, alpha: 1.00).cgColor
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true // Đảm bảo rằng các góc của button bị cắt đi theo cornerRadius
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
        iconView.frame = CGRect(x: 0, y: 0, width: 24, height: 14) // Điều chỉnh kích thước icon lớn hơn

        textField.rightView = iconView
        textField.rightViewMode = .always
    }

    
}
extension UILabel {
    func setCheckBoxText(_ text: String) {
            let attributedString = NSMutableAttributedString(string: text)
            
            // Đặt phông chữ và màu xám cho toàn bộ chuỗi
            attributedString.addAttribute(.foregroundColor, value: UIColor.gray, range: NSRange(location: 0, length: text.count))
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: self.font.pointSize), range: NSRange(location: 0, length: text.count))
            
            // Tìm và đặt màu xanh cho từ "chính sách"
            if let range = text.range(of: "chính sách") {
                let nsRange = NSRange(range, in: text)
                attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: nsRange)
                attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: self.font.pointSize, weight: .bold), range: nsRange)
            }
            
            // Tìm và đặt màu xanh cho từ "điều khoản"
            if let range = text.range(of: "điều khoản") {
                let nsRange = NSRange(range, in: text)
                attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: nsRange)
                attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: self.font.pointSize, weight: .bold), range: nsRange)
            }
            
            self.attributedText = attributedString
        }
    
        func setDangNhapText(_ text: String){
            let attributedString = NSMutableAttributedString(string: text)
            
            // Đặt phông chữ và màu xám cho toàn bộ chuỗi
            attributedString.addAttribute(.foregroundColor, value: UIColor.gray, range: NSRange(location: 0, length: text.count))
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: self.font.pointSize), range: NSRange(location: 0, length: text.count))
            
            // Tìm và đặt màu xanh cho từ "chính sách"
            if let range = text.range(of: "Đăng nhập ngay") {
                let nsRange = NSRange(range, in: text)
                attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: nsRange)
                attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: self.font.pointSize, weight: .bold), range: nsRange)
            }
            self.attributedText = attributedString
        }
    }
