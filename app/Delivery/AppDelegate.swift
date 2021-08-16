//
//  AppDelegate.swift
//  Delivery
//
//  Created by Øyvind Hauge on 20/01/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // set initial view controller
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = setupInitialViewController()
        window?.makeKeyAndVisible()
        // Remove 1px top border on tab bar
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = .white
        return true
    }
    
    private func setupInitialViewController() -> UIViewController {
        // create and initialize all view controllers
        let restaurantsNavigationController = createNavigationController(rootVC: RestaurantsViewController())
        let mapNavigationController = createNavigationController(rootVC: MapViewController())
        let myOrdersNavigationController = createNavigationController(rootVC: MyOrdersViewController())
        let settingsNavigationController = createNavigationController(rootVC: SettingsViewController())
        
        let viewControllers: [UIViewController] = [
            restaurantsNavigationController,
            mapNavigationController,
            myOrdersNavigationController,
            settingsNavigationController
        ]
        // create tab bar contoller and embed all view controllers
        let mainTabBarController = createTabBarController()
        mainTabBarController.setViewControllers(viewControllers, animated: false)
        return mainTabBarController
    }
    
    private func createTabBarController() -> UITabBarController {
        let tabBarController = MainTabBarController()
        tabBarController.tabBar.isTranslucent = false
        return tabBarController
    }
    
    private func createNavigationController(rootVC: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.isNavigationBarHidden = true
        return navigationController
    }
}
