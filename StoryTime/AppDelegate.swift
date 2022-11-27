//
//  AppDelegate.swift
//  StoryTime
//
//  Created by Chuck on 23/11/2022.
//

import UIKit
//import FirebaseCore
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        startWindow()
        return true
    }
    
    private func startWindow(){
        
        //MARK: Remove - for testing
//        UserDefaults.standard.set(false, forKey: UserDefaultkeys.hasLaunched)
        
        window = UIWindow(frame: Dimensions.SCREENSIZE)
        
        let launchScreenStoryboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
            
         _ = launchScreenStoryboard.instantiateViewController(withIdentifier: "LaunchScreen")
    
        let hasLaunched = UserDefaults.standard.bool(forKey: UserDefaultkeys.hasLaunched)
        
        if hasLaunched == false{
            
            self.window?.rootViewController = OnBoardingViewController()
            
        }else{
            
            //MARK: TODO - Auth Logic
            let isAuth = UserDefaults.standard.bool(forKey: UserDefaultkeys.isAuthenticated)
            if (isAuth){
                // show app else show auth screen
                
            }
            self.window?.rootViewController = TabBarController()
        }
        
        self.window?.makeKeyAndVisible()
        
        UIView.transition(with: self.window!,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
        
        //Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(startApplication), userInfo: nil, repeats: false)
    }
    
    func setRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard animated, let window = self.window else {
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            return
        }

        window.rootViewController = vc
        window.makeKeyAndVisible()
        
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
}
