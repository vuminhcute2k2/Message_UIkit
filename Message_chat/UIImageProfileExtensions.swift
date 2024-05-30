//
//  UIImageProfileExtensions.swift
//  Message_chat
//
//  Created by Minh Vũ on 30/05/2024.
//

import Foundation
import UIKit
extension UIImage{
    static func imageWithBackground(image: UIImage, backgroundColor: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        backgroundColor.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        image.draw(in: CGRect(origin: CGPoint(x: (size.width - image.size.width) / 2, y: (size.height - image.size.height) / 2), size: image.size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
