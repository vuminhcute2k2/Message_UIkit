//
//  UIImageExtensions.swift
//  Message_chat
//
//  Created by Minh Vũ on 13/06/2024.
//

import Foundation
import UIKit
extension UIImageView {
    func makeCircular() {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true
    }
}
