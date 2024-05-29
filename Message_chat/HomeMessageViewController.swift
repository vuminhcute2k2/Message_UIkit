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
    @IBOutlet weak var viewTableMessage: UIView!
    @IBOutlet weak var tableMessage: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        view.sendSubviewToBack(backgroundColorHome)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundColorHome.updateGradientFrame()
        updateBoderViewMessage()
    }
    //hàm chuyển đổi chế độ ngang và dọc
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.backgroundColorHome.updateGradientFrame()
            self.updateBoderViewMessage()
        }, completion: nil)
    }
    private func setupUI() {
        backgroundColorHome.applyGradient()
        extendViewToTopSafeArea(view: backgroundColorHome)
        
        textFieldSearch.placeholder = "Tìm kiếm tin nhắn..."
        textFieldSearch.borderStyle = .none
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
        
        // Setup Auto Layout constraints for tableMessage
        tableMessage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableMessage.topAnchor.constraint(equalTo: viewTableMessage.topAnchor),
            tableMessage.bottomAnchor.constraint(equalTo: viewTableMessage.bottomAnchor),
            tableMessage.leadingAnchor.constraint(equalTo: viewTableMessage.leadingAnchor),
            tableMessage.trailingAnchor.constraint(equalTo: viewTableMessage.trailingAnchor)
        ])
    }
    private func extendViewToTopSafeArea(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        if let superview = view.superview {
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
                view.topAnchor.constraint(equalTo: superview.topAnchor),
                view.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            ])
        }
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
extension UIView {
    func applyGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0.24, green: 0.81, blue: 0.81, alpha: 1.00).cgColor,
            UIColor(red: 0.26, green: 0.34, blue: 0.71, alpha: 1.00).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = self.layer.cornerRadius
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.layer.gradientLayer = gradientLayer
    }
    
    func updateGradientFrame() {
        if let gradientLayer = self.layer.gradientLayer {
            gradientLayer.frame = self.bounds
        }
    }
}
// lưu trữ gradient layer
extension CALayer {
    private struct AssociatedKeys {
        static var gradientLayer = "gradientLayer"
    }
    
    var gradientLayer: CAGradientLayer? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.gradientLayer) as? CAGradientLayer
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.gradientLayer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension HomeMessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesTableViewCell", for: indexPath) as? MessagesTableViewCell else {
            return UITableViewCell()
        }
        cell.imageAvatar.image = UIImage(named: "image_avatar")
        cell.textname.text = "Vũ Minh"
        cell.textmessage.text = "Xin chào gọi là Shicalo"
        cell.texttime.text = "10:11"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Đã chọn hàng \(indexPath.row + 1)")
    }
}
