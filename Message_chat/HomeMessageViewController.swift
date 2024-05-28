//
//  HomeMessageViewController.swift
//  Message_chat
//
//  Created by Minh Vũ on 28/05/2024.
//

import UIKit

class HomeMessageViewController: UIViewController {

   
    
    @IBOutlet weak var labelTinNhan: UILabel!
    @IBOutlet weak var backgroundColorHome: UIView!
    
    @IBOutlet weak var textFieldSearch: UITextField!
    
    @IBOutlet weak var boderViewSearch: UIView!
    
    @IBOutlet weak var buttonSearchMessage: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
//        backgroundColorHome.applyGradiend1()
        
       extendViewToTopSafeArea(view: backgroundColorHome)
        
        //custom item search
        textFieldSearch.placeholder = "Tìm kiếm tin nhắn..."
        textFieldSearch.borderStyle = .none

        if let searchIcon = UIImage(named: "icon_search"){
            addLeftIcon(to: textFieldSearch, icon: searchIcon)
            
        } else {
            print("Failed images")
        }
        customizeBoderViewSearch()
        
        //custom buttonSearchMessage
        customizeButtonSearchMessage()
       
    }
    private func extendViewToTopSafeArea(view: UIView) {
            // Disable autoresizing mask translation into constraints
            view.translatesAutoresizingMaskIntoConstraints = false
            // Add constraints to extend the view to the top of the superview
            if let superview = view.superview {
                NSLayoutConstraint.activate([
                    view.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                    view.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
                    view.topAnchor.constraint(equalTo: superview.topAnchor),
                    view.heightAnchor.constraint(equalToConstant: view.frame.height + view.safeAreaInsets.top) // Increase height to cover safe area
                ])
            }
        }
    private func addLeftIcon(to textField: UITextField, icon: UIImage) {
        let iconView = UIImageView(image: icon)
        iconView.contentMode = .scaleAspectFit
        iconView.frame = CGRect(x: 0, y: 0, width: 24, height: 14) // Điều chỉnh kích thước icon lớn hơn
        textField.leftView = iconView
        textField.leftViewMode = .always
    }
    
    private func customizeBoderViewSearch() {
           boderViewSearch.layer.cornerRadius = 18
           boderViewSearch.layer.masksToBounds = true
           boderViewSearch.layer.borderWidth = 1
           boderViewSearch.layer.borderColor = UIColor.white.cgColor
       }
    private func customizeButtonSearchMessage() {
           buttonSearchMessage.setImage(UIImage(named: "message_add"), for: .normal)
           buttonSearchMessage.setTitle("", for: .normal)
           buttonSearchMessage.backgroundColor = UIColor.white
           buttonSearchMessage.layer.borderWidth = 0
           buttonSearchMessage.layer.cornerRadius = 20
           buttonSearchMessage.layer.masksToBounds = true
       }

}
extension UIView {
    func applyGradiend1(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(red: 0.24, green: 0.81, blue: 0.81, alpha: 1.00).cgColor,UIColor(red: 0.26, green: 0.34, blue: 0.71, alpha: 1.00).cgColor]
        gradientLayer.cornerRadius = layer.cornerRadius
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
}
