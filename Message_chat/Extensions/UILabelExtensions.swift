//
//  UILabelExtensions.swift
//  Message_chat
//
//  Created by Minh Vũ on 30/05/2024.
//

import Foundation
import UIKit
extension UILabel {
    func setCheckBoxText(_ text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        //custom font text
        attributedString.addAttribute(.foregroundColor, value: UIColor.gray, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: self.font.pointSize), range: NSRange(location: 0, length: text.count))
        // custom color text blue
        if let range = text.range(of: "chính sách") {
            let nsRange = NSRange(range, in: text)
            attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: nsRange)
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: self.font.pointSize, weight: .bold), range: nsRange)
        }
        // custom color text blue
        if let range = text.range(of: "điều khoản") {
            let nsRange = NSRange(range, in: text)
            attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: nsRange)
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: self.font.pointSize, weight: .bold), range: nsRange)
        }
        self.attributedText = attributedString
    }
    func setDangNhapText(_ text: String){
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor.gray, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: self.font.pointSize), range: NSRange(location: 0, length: text.count))
        if let range = text.range(of: "Đăng nhập ngay") {
            let nsRange = NSRange(range, in: text)
            attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: nsRange)
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: self.font.pointSize, weight: .bold), range: nsRange)
        }
        self.attributedText = attributedString
    }
    func setAwesomeText(_ text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        // Đặt phông chữ đậm và màu trắng cho từ "awesome"
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: 7)) // Độ dài của từ "awesome"
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: font.pointSize, weight: UIFont.Weight(30)), range: NSRange(location: 0, length: 7))
        
        // Đặt phông chữ và màu cho từ "chat"
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 7, length: text.count - 7))
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: font.pointSize), range: NSRange(location: 7, length: text.count - 7))
        self.attributedText = attributedString
    }
}
