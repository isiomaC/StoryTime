//
//  AppDelegate.swift
//  StoryTime
//
//  Created by Chuck on 23/11/2022.
//

import UIKit
import FirebaseCore
import IQKeyboardManagerSwift
import FirebaseRemoteConfig
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
        getRemoteConfigData()
        startWindow()
        return true
    }
    
    private func startWindow(){
        
        window = UIWindow(frame: Dimensions.SCREENSIZE)
        
        let launchScreenStoryboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
            
         _ = launchScreenStoryboard.instantiateViewController(withIdentifier: "LaunchScreen")
    
        let hasLaunched = UserDefaults.standard.bool(forKey: UserDefaultkeys.hasLaunched)
        
        if hasLaunched == false {
            
            self.window?.rootViewController = OnBoardingViewController()
            
        }else{
            
            let isCurrentAuth = FirebaseService.shared.auth?.currentUser == nil ? false : true
            
            UserDefaults.standard.set(isCurrentAuth, forKey: UserDefaultkeys.isAuthenticated)
            
            if isCurrentAuth == true {
                self.window?.rootViewController = TabBarController()
            }else{
                self.window?.rootViewController = LoginViewController()
            }
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
        guard let window = self.window else {
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
    
    
    private func getRemoteConfigData(){

        let setting = RemoteConfigSettings()
        setting.minimumFetchInterval = 43200 //12hours

        var expirationDuration = 43200 //43200  //MARK: Test

        // If your app is using developer mode, expirationDuration is set to 0, so each fetch will
        // retrieve values from the service.
        if UserDefaults.standard.bool(forKey: STALE_CONFIG) {
            setting.minimumFetchInterval = 0
            expirationDuration = 0
        }

        RemoteConfig.remoteConfig().configSettings = setting

        RemoteConfig.remoteConfig().fetch(withExpirationDuration: TimeInterval(expirationDuration)) { status, error in
            guard error == nil else { return }

            if status == .success {
                RemoteConfig.remoteConfig().activate { [weak self] (success, error) in
                    guard error == nil else { return }

                    self?.updateConfigs()

//                    self?.showKilledVC()
                }
            }
        }
    }

    
    private func updateConfigs(){
        let defaults = UserDefaults.standard

        //Strings
        let landingText = RemoteConfig.remoteConfig().configValue(forKey: RemoteConfigKeys.landingText).stringValue
        defaults.setValue(landingText, forKey: RemoteConfigKeys.landingText)
        
        let termsLink = RemoteConfig.remoteConfig().configValue(forKey: RemoteConfigKeys.terms).stringValue
        defaults.setValue(termsLink, forKey: RemoteConfigKeys.terms)

        let privacyLink = RemoteConfig.remoteConfig().configValue(forKey: RemoteConfigKeys.privacy).stringValue
        defaults.setValue(privacyLink, forKey: RemoteConfigKeys.privacy)

        let killSwitch = RemoteConfig.remoteConfig().configValue(forKey: RemoteConfigKeys.kill_switch).boolValue
        defaults.setValue(killSwitch, forKey: RemoteConfigKeys.kill_switch)
    }
}

extension AppDelegate {
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        if (userInfo.index(forKey: STALE_CONFIG) != nil) {
            UserDefaults.standard.set(true, forKey: STALE_CONFIG)
        }

        completionHandler(UIBackgroundFetchResult.newData)
    }
        
}


extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
       
        let tokenDict = ["token": fcmToken ?? ""]
        
        NotificationCenter.default.post(
            name: .fcmToken,
            object: nil,
            userInfo: tokenDict)
        
        messaging.subscribe(toTopic: "all")
        messaging.subscribe(toTopic: "PUSH_RC") { error in
            guard error == nil else { return }
            print("Subscribed to PUSH_RC")
        }
    }
}

