//
//  FriendsViewController.swift
//  Message_chat
//
//  Created by Minh Vũ on 28/05/2024.
//

import UIKit
import LZViewPager
class FriendsViewController: UIViewController,LZViewPagerDelegate,LZViewPagerDataSource {
    
    @IBOutlet weak var homeBackgroundView: UIView!
    @IBOutlet weak var borderSearchView: UIView!
    @IBOutlet weak var friendAddButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
//    @IBOutlet weak var borderFriendsView: UIView!
    
    @IBOutlet weak var viewPager: LZViewPager!
    private var subController:[UIViewController] = []
    private let tabTitles = ["BẠN BÈ", "TẤT CẢ","YÊU CẦU"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewPagerProperties()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeBackgroundView.updateGradientFrame()
        viewPager.updateBorderView(corners: [.topLeft, .topRight], radius: 18, borderColor: .white, borderWidth: 1)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.homeBackgroundView.updateGradientFrame()
            self.viewPager.updateBorderView(corners: [.topLeft, .topRight], radius: 18, borderColor: .white, borderWidth: 1)
        }, completion: nil)
    }
    private func setupUI() {
        homeBackgroundView.applyGradient()
        if let searchIcon = UIImage(named: "icon_search") {
            searchTextField.addLeftIcon(searchIcon)
        } else {
            print("Failed images")
        }
        borderSearchView.customizeBorder(cornerRadius: 18, borderWidth: 1, borderColor: .white)
        friendAddButton.customizeButton(withImage: "icon_addFriends", backgroundColor: .white, cornerRadius: 20)
    }
    func viewPagerProperties(){
        viewPager.delegate = self
        viewPager.dataSource = self
        viewPager.hostController = self
        
        let vc1 = MyFriendsViewController(nibName: "MyFriendsViewController", bundle: nil)
        let vc2 =  AllFriendsViewController(nibName: "AllFriendsViewController", bundle: nil)
        let vc3 =  RequestFriendsViewController(nibName: "RequestFriendsViewController", bundle: nil)


        subController = [vc1,vc2,vc3]
        viewPager.reload()
        
    }
    func numberOfItems() -> Int {
        return self.subController.count
    }
    
    func controller(at index: Int) -> UIViewController {
        return subController[index]
    }
    
    func button(at index: Int) -> UIButton {
        let button = UIButton()
        button.setTitle(tabTitles[index], for: .normal) 
        button.setTitleColor(UIColor.gray, for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }
    func colorForIndicator(at index: Int) -> UIColor {
        return .darkGray
    }
    
    

}
