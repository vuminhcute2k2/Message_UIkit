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
    func loadImage(from url: URL, completion: ((UIImage?) -> Void)? = nil) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                    completion?(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion?(nil)
                }
            }
        }
    }
}
