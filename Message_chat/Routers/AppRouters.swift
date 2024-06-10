//
//  AppRouters.swift
//  Message_chat
//
//  Created by Minh Vũ on 06/06/2024.
//

import Foundation
import UIKit
enum AppRouters {
    case homeTabBar
    case register
    case login
    var viewController: UIViewController {
        switch self {
        case .homeTabBar:
            return createHomeTabBarController()
        case .register:
            return createRegisterViewController()
        case .login:
            return createlogInViewController()
        }
    }
    private func createHomeTabBarController() -> UIViewController {
        let homeTabBarController = HomeTabBarController(nibName: "HomeTabBarController", bundle: nil)
        homeTabBarController.modalPresentationStyle = .fullScreen
        return homeTabBarController
    }
    private func createRegisterViewController() -> UIViewController {
        let registerAccountViewController = RegisterAccountViewController(nibName: "RegisterAccountViewController", bundle: nil)
        registerAccountViewController.modalPresentationStyle = .fullScreen
        return registerAccountViewController
    }
    private func createlogInViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        loginViewController.modalPresentationStyle = .fullScreen
        return loginViewController
    }

    func navigate(from viewController: UIViewController) {
        viewController.present(self.viewController, animated: true, completion: nil)
    }
}
