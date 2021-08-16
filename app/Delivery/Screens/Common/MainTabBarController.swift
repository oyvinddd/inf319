//
//  MainTabBarController.swift
//  Delivery
//
//  Created by Øyvind Hauge on 12/05/2021.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTabBarItems()
    }
    
    private func configureUI() {
        tabBar.barTintColor = .white
        tabBar.tintColor = UIColor.Text.primary
        tabBar.unselectedItemTintColor = UIColor.Text.secondary
        // Apply drop shadow to tab bar
        tabBar.layer.shadowColor = UIColor.Text.primary.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        tabBar.layer.shadowRadius = 8
        tabBar.layer.shadowOpacity = 0.4
        tabBar.layer.masksToBounds = false
        
        let attrsNormal = [NSAttributedString.Key.foregroundColor: UIColor.Text.primary,
                           NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)]
        UITabBarItem.appearance().setTitleTextAttributes(attrsNormal,
                                                         for: UIControl.State.normal)
    }
    
    private func setTabBarItems() {
        let homeItem = (self.tabBar.items?[0])! as UITabBarItem
        homeItem.image = createImage(title: "TabBarHome")
        homeItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let mapItem = (self.tabBar.items?[1])! as UITabBarItem
        mapItem.image = createImage(title: "TabBarMap")
        mapItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let cartItem = (self.tabBar.items?[2])! as UITabBarItem
        cartItem.image = createImage(title: "TabBarCart")
        cartItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let settingsItem = (self.tabBar.items?[3])! as UITabBarItem
        settingsItem.image = createImage(title: "TabBarSettings")
        settingsItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    }
    
    private func createImage(title: String) -> UIImage {
        let image = UIImage(named: title)?.withRenderingMode(.alwaysTemplate)
        return image!
    }
}
