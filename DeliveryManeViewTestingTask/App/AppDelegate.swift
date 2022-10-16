//
//  AppDelegate.swift
//  DeliveryManeViewTestingTask
//
//  Created by Александр Макаров on 13.10.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        // Экземпляр класса MainViewController
        let mainVC = MainViewController()
        mainVC.title = "Меню"
        
        // Экземпляр класса MeasureListViewController
        let contactsVC = ContactsViewController()
        contactsVC.title = "Контакты"
        
        // Экземпляр класса AboutViewController
        let profileVC = ProfileViewController()
        profileVC.title = "Профиль"
        
        //  Экземпляр класса BasketViewController
        let basketVC = ProfileViewController()
        basketVC.title = "Корзина"
        
        // Настройка тапБара
        let tabBarVC = UITabBarController()
        tabBarVC.tabBar.backgroundColor = .white
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.setViewControllers([mainVC, contactsVC, profileVC, basketVC], animated: true)
        tabBarVC.tabBar.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 0.5)
        tabBarVC.tabBar.layer.borderWidth = 0.5
        
        // Устанавливаем цвет иконок тапБара
        tabBarVC.tabBar.tintColor = .red
       
        guard let items = tabBarVC.tabBar.items else { return false }
        
        let images = ["Food", "Contacts", "Profile", "Basket"]
        
        let titleFont : UIFont = UIFont.systemFont(ofSize: 13, weight: .light)

        let attributes = [
            NSAttributedString.Key.font : titleFont
        ]
        
        for i in 0..<items.count {
            items[i].image = UIImage(named: images[i])
            items[i].setTitleTextAttributes(attributes, for: .normal)
        }
        
        window?.rootViewController = tabBarVC
        return true
    }
}

