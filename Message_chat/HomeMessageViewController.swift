//
//  HomeMessageViewController.swift
//  Message_chat
//
//  Created by Minh Vũ on 28/05/2024.
//

import UIKit

class HomeMessageViewController: UIViewController {
    @IBOutlet weak var homeBackgroundView: UIView!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var boderViewSearch: UIView!
    @IBOutlet weak var buttonSearchMessage: UIButton!
    @IBOutlet weak var viewTableMessage: UIView!
    @IBOutlet weak var tableMessage: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeBackgroundView.updateGradientFrame()
        updateBoderViewMessage()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.homeBackgroundView.updateGradientFrame()
            self.updateBoderViewMessage()
        }, completion: nil)
    }
    private func setupUI() {
        homeBackgroundView.applyGradient()
        if let searchIcon = UIImage(named: "icon_search") {
            addLeftIcon(to: textFieldSearch, icon: searchIcon)
        } else {
            print("Failed images")
        }
        
        customizeBoderViewSearch()
        customizeButtonSearchMessage()
    }
    private func setupTableView() {
        let nib = UINib(nibName: "MessagesTableViewCell", bundle: nil)
        tableMessage.register(nib, forCellReuseIdentifier: "MessagesTableViewCell")
        tableMessage.delegate = self
        tableMessage.dataSource = self
    }
    private func addLeftIcon(to textField: UITextField, icon: UIImage) {
        let iconView = UIImageView(image: icon)
        iconView.contentMode = .scaleAspectFit
        iconView.frame = CGRect(x: 0, y: 0, width: 24, height: 14)
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
    private func updateBoderViewMessage() {
        let radius: CGFloat = 18
        let path = UIBezierPath(
            roundedRect: viewTableMessage.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        viewTableMessage.layer.mask = mask
        // Removing existing border layers
        if let sublayers = viewTableMessage.layer.sublayers {
            for layer in sublayers {
                if layer is CAShapeLayer {
                    layer.removeFromSuperlayer()
                }
            }
        }
        // Adding new border layer
        let borderLayer = CAShapeLayer()
        borderLayer.path = path.cgPath
        borderLayer.strokeColor = UIColor.white.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 1
        viewTableMessage.layer.addSublayer(borderLayer)
    }
}

