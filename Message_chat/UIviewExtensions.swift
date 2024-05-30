//
//  UIviewExtensions.swift
//  Message_chat
//
//  Created by Minh Vũ on 30/05/2024.
//

import Foundation
import UIKit
extension UIView {
    func applyGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0.24, green: 0.81, blue: 0.81, alpha: 1.00).cgColor,
            UIColor(red: 0.26, green: 0.34, blue: 0.71, alpha: 1.00).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = self.layer.cornerRadius
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.layer.gradientLayer = gradientLayer
    }
    
    func updateGradientFrame() {
        if let gradientLayer = self.layer.gradientLayer {
            gradientLayer.frame = self.bounds
        }
    }
}
