//
//  UIButtonExtensions.swift
//  Message_chat
//
//  Created by Minh Vũ on 31/05/2024.
//

import Foundation
import UIKit
extension UIButton {
    func customizeButton(withImage imageName: String, backgroundColor: UIColor, cornerRadius: CGFloat) {
        if let image = UIImage(named: imageName) {
            self.setImage(image, for: .normal)
        } else {
            print("Failed to load image \(imageName)")
        }
        self.setTitle("", for: .normal)
        self.backgroundColor = backgroundColor
        self.layer.borderWidth = 0
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
}
