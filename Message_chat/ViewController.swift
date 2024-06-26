//
//  ViewController.swift
//  Message_chat
//
//  Created by Minh Vũ on 15/05/2024.
//

import UIKit
import SwiftSVG
import UserNotifications
import FirebaseAuth
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Đăng ký để theo dõi sự thay đổi trạng thái của ứng dụng
        //theo dõi sự kiện khi ứng dụng sắp chuyển trạng thái Active sang trạng thái Inactive.
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppStateChange), name: UIApplication.willResignActiveNotification, object: nil)
        // theo dõi sự kiện khi ứng dụng đã trở lại trạng thái Active sau khi trước đó là Inactive.
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppStateChange), name: UIApplication.didBecomeActiveNotification, object: nil)
        //theo dõi sự kiện khi ứng dụng sắp chuyển từ trạng thái Background sang trạng thái Active hoặc Inactive.
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppStateChange), name: UIApplication.willEnterForegroundNotification, object: nil)
        // theo dõi sự kiện khi ứng dụng đã chuyển sang trạng thái Background.
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppStateChange), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2, execute: {
            self.checkLoginStatus()
        })
        backgroundColor.applyGradient()
        labelName.setAwesomeText("Awesome Chat")
    }
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet var backgroundColor: UIView!
    // Hàm xử lý sự kiện khi trạng thái của ứng dụng thay đổi
    @objc func handleAppStateChange() {
        switch UIApplication.shared.applicationState {
        case .active:
            print("Ứng dụng đang hoạt động trên màn hình.")
        case .inactive:
            print("Ứng dụng đang chuyển đổi giữa trạng thái hoạt động và không hoạt động.")
        case .background:
            print("Ứng dụng đang chạy ở nền.")
        default:
            print("Ứng dụng đã bị tạm dừng.")
        }
    }
    func checkLoginStatus() {
        FirebaseService.shared.autoSignIn { [weak self] result in
            switch result {
            case .success(let user):
                print("Auto login success: \(user.email)")
                self?.showHomeScreen()
            case .failure(let error):
                print("Auto login error: \(error.localizedDescription)")
                self?.showLoginScreen()
            }
        }
    }
    func showLoginScreen() {
        let loginVC = AppRouters.login.viewController
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
    func showHomeScreen() {
        let homeTabBarVC = AppRouters.homeTabBar.viewController
        homeTabBarVC.modalPresentationStyle = .fullScreen
        present(homeTabBarVC, animated: true, completion: nil)
    }
}
