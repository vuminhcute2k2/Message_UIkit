//
//  HomeViewController.swift
//  Message_chat
//
//  Created by Minh Vũ on 28/05/2024.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundColor.applyGradiend1()
        // Do any additional setup after loading the view.
    }


    @IBOutlet var backgroundColor: UIView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
