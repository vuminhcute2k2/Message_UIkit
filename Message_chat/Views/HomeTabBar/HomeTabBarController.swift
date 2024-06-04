//
//  HomeTabBarController.swift
//  Message_chat
//
//  Created by Minh Vũ on 28/05/2024.
//

import UIKit

class HomeTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let homeMessage = HomeMessageViewController(nibName: "HomeMessageViewController", bundle: nil)
        homeMessage.tabBarItem = UITabBarItem(title: "Tin nhắn", image: UIImage(systemName: "ellipsis.message"), tag: 0)
        let friends = FriendsViewController(nibName: "FriendsViewController", bundle: nil)
        friends.tabBarItem = UITabBarItem(title: "Bạn bè", image: UIImage(systemName: "person.2.fill"), tag: 1)
        let profile = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        profile.tabBarItem = UITabBarItem(title: "Trang cá nhân", image: UIImage(systemName: "person.crop.circle.fill") , tag: 2)
        self.viewControllers = [homeMessage,friends,profile]
        self.tabBar.barTintColor = .white
        self.tabBar.backgroundColor = .white
    }
}
