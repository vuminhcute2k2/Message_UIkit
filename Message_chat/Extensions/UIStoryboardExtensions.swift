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
        bundle: Bundle? = nil,
        errorHandler: ((String) -> Void)? = nil) -> T? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as? T else {
            errorHandler?("Could not instantiate view controller with identifier \(viewControllerIdentifier) from storyboard \(storyboardName)")
            return nil
        }
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
}
