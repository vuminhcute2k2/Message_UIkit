//
//  ViewController.swift
//  Message_chat
//
//  Created by Minh Vũ on 15/05/2024.
//

import UIKit
import SwiftSVG
import UserNotifications

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
            self.performSegue(withIdentifier: "goToLogin", sender: nil)
        })
        backgroundColor.applyGradiend()
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
}
    extension UIView {
        func applyGradiend(){
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [UIColor(red: 0.24, green: 0.81, blue: 0.81, alpha: 1.00).cgColor,UIColor(red: 0.26, green: 0.34, blue: 0.71, alpha: 1.00).cgColor]
            gradientLayer.cornerRadius = layer.cornerRadius
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 0, y: 0)
            gradientLayer.frame = bounds
            layer.insertSublayer(gradientLayer, at: 0)
            
        }
        
    }
    extension UILabel {
        func setAwesomeText(_ text: String) {
            let attributedString = NSMutableAttributedString(string: text)
            
            // Đặt phông chữ đậm và màu trắng cho từ "awesome"
            attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: 7)) // Độ dài của từ "awesome"
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: font.pointSize, weight: UIFont.Weight(30)), range: NSRange(location: 0, length: 7))
            
            // Đặt phông chữ và màu cho từ "chat"
            attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 7, length: text.count - 7))
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: font.pointSize), range: NSRange(location: 7, length: text.count - 7))
            
            
            self.attributedText = attributedString
                }
            }






