//
//  TabBarController.swift
//  StoryTime
//
//  Created by Chuck on 24/11/2022.
//


import Foundation
import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    static let shared: TabBarController = {
        let instance = TabBarController()
        return instance
    }()
    
    var tabBarHeight: CGFloat? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        setUpNavigationController()
        tabBarHeight = tabBar.frame.height
       
        self.tabBar.isTranslucent = false
        tabBar.tintColor = MyColors.primary
        
        tabBar.backgroundColor = .systemBackground
        
//        tabBar.unselectedItemTintColor = .systemGray3
//        tabBar.tintColor = .systemGray
        
        setUpTabController()
        
    }
    
    private func setUpTabController(){
        
        // MARK: Home View Controller
        
        let homeCoordinator = MainCoordinator(viewName: VCNames.HOME)
        
        let homeTabIcon = UITabBarItem(title: VCNames.HOME, image: UIImage(systemName: "house"), tag: 0)
        
        guard let homeNavController = homeCoordinator.navigationController else{
            return
        }
        homeNavController.tabBarItem = homeTabIcon
        
        
        // MARK: Account View Controller
        
        let accountCoordinator = MainCoordinator(viewName: VCNames.ACCOUNT)
        
        let addedIcon = UITabBarItem(title: VCNames.ACCOUNT, image: UIImage(systemName: "person.fill"), tag: 1)
        
        guard let accountNavController = accountCoordinator.navigationController else{
            return
        }
        accountNavController.tabBarItem = addedIcon
        
        
        // MARK: Settings View Controller
        
        let settingsCoordinator = MainCoordinator(viewName: VCNames.SETTINGS)
        
        let settingsIcon = UITabBarItem(title: VCNames.SETTINGS, image: UIImage(systemName: "line.horizontal.3"), tag: 2)
        
        guard let settingsNavController = settingsCoordinator.navigationController else{
            return
        }
        settingsNavController.tabBarItem = settingsIcon
        
      
        self.viewControllers = [homeNavController, accountNavController, settingsNavController].map({ (viewController) in
            viewController
        })
    }
    
    @objc func openMenu(){
        
    }
    
    func setUpNavigationController(){
//         navigationController?.navigationBar.tintColor = .black
//         navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        
       
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        print(viewController.children.first?.navigationItem.title as Any)
        return true
    }
}
