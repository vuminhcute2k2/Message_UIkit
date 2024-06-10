//
//  UIStoryboardExtensions.swift
//  Message_chat
//
//  Created by Minh Vũ on 11/06/2024.
//

import Foundation
import UIKit

extension UIStoryboard {
    static func instantiateViewController<T: UIViewController>(
        storyboardName: String,
        viewControllerIdentifier: String,
        bundle: Bundle? = nil) -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as? T else {
            fatalError("Không thể khởi tạo view controller với identifier \(viewControllerIdentifier) từ storyboard \(storyboardName)")
        }
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
}
