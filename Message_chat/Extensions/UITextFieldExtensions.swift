//
//  UITextFieldExtensions.swift
//  Message_chat
//
//  Created by Minh Vũ on 31/05/2024.
//

import Foundation
import UIKit
extension UITextField {
    func addLeftIcon(_ icon: UIImage, iconSize: CGSize = CGSize(width: 24, height: 14)) {
        let iconView = UIImageView(image: icon)
        iconView.contentMode = .scaleAspectFit
        iconView.frame = CGRect(x: 0, y: 0, width: iconSize.width, height: iconSize.height)
        self.leftView = iconView
        self.leftViewMode = .always
    }
    func addRightIcon(_ icon: UIImage, iconSize: CGSize = CGSize(width: 24, height: 14)) {
        let iconView = UIImageView(image: icon)
        iconView.contentMode = .scaleAspectFit
        iconView.frame = CGRect(x: 0, y: 0,  width: iconSize.width, height: iconSize.height)
        self.rightView = iconView
        self.rightViewMode = .always
    }
    func addBottomLine(to textField: UITextField) {
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
    
}
