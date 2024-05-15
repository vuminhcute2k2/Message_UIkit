//
//  ViewController.swift
//  Message_chat
//
//  Created by Minh Vũ on 15/05/2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2, execute: {
            self.performSegue(withIdentifier: "goToLogin", sender: nil)
        })
        backgroundColor.applyGradiend()
        labelName.setAwesomeText("Awesome Chat")
        
    }
    
    
    @IBOutlet weak var labelName: UILabel!
        
    @IBOutlet var backgroundColor: UIView!
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






