//
//  CALayerExtensions.swift
//  Message_chat
//
//  Created by Minh Vũ on 30/05/2024.
//

import Foundation
import UIKit
extension CALayer {
    private struct AssociatedKeys {
        static var gradientLayer = "gradientLayer"
    }
    
    var gradientLayer: CAGradientLayer? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.gradientLayer) as? CAGradientLayer
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.gradientLayer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
