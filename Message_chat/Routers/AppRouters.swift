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
    case account
    case profile
    var viewController: UIViewController {
        switch self {
        case .homeTabBar:
            return createHomeTabBarController()
        case .register:
            return createRegisterViewController()
        case .login:
            return createlogInViewController()
        case .account:
            return createEditAccountController()
        case .profile:
            return createProfileController()
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
    private func createEditAccountController() -> UIViewController {
        let editAccountController = EditAccountViewController(nibName: "EditAccountViewController", bundle: nil)
        editAccountController.modalPresentationStyle = .fullScreen
        return editAccountController
    }
    private func createProfileController() -> UIViewController {
        let profileController = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        profileController.modalPresentationStyle = .fullScreen
        return profileController
    }
    private func createlogInViewController() -> UIViewController {
        return UIStoryboard.instantiateViewController(storyboardName: "Main", viewControllerIdentifier: "LoginViewController")!
    }

    func navigate(from viewController: UIViewController) {
        viewController.present(self.viewController, animated: true, completion: nil)
    }
}
