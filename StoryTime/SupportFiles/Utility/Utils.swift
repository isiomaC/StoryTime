//
//  Utils.swift
//  StoryTime
//
//  Created by Chuck on 27/11/2022.
//

import Foundation
import UIKit
import StoreKit
import SafariServices

struct Utils {
    
    static let appId = readFromPList("Config", key: "APP_ID")
    
    static var apiUrl : String {
        get {
            let value = readFromPList("Config", key: "BASE_API_URL")
            return value
        }
    }
    
    static var webRoute : String {
        get{
            let value = readFromPList("Config", key: "WEB_ROUTE")
            return value
        }
    }
    
    static var appStoreUrl : String {
        get{
            let value = readFromPList("Config", key: "APP_STORE_URL")
            return value
        }
    }
    
    
    static var privacyPolicyUrl : String {
        get{
            let value = readFromPList("Config", key: "PRIVACY_POLICY")
            return value
        }
    }

    static var termsAppleEula : String {
        get{
            let value = readFromPList("Config", key: "TERMS_EULA")
            return value
        }
    }
    
    static func readFromPList(_ filename: String, key: String) -> String{
        guard let filePath = Bundle.main.path(forResource: filename, ofType: "plist") else {
          fatalError("Couldn't find file '\(filename).plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: key) as? String else {
          fatalError("Couldn't find key '\(key)' in '\(filename).plist'.")
        }
        return value
    }
    
    static func attributedText(_ string: String, targetString: String, font: UIFont) -> NSAttributedString {
        
        let attributedString = NSMutableAttributedString(string: string,
                                                     attributes: [NSAttributedString.Key.font: font])
        
//        attributedString.removeAttribute(<#T##name: NSAttributedString.Key##NSAttributedString.Key#>, range: <#T##NSRange#>)
        
        let boldFontAttribute: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        
        let underlineAttribute = [
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue
        ]
        
        let colorAttributed = [
            NSAttributedString.Key.foregroundColor: UIColor.label
        ]
        
        
        let range = (string as NSString).range(of: targetString)
        
        attributedString.addAttributes(underlineAttribute, range: range)
        attributedString.addAttributes(boldFontAttribute, range: range)
        
        attributedString.addAttributes(colorAttributed, range: NSMakeRange(0, attributedString.length))
        
        return attributedString
    }
    
    static func rateApp() {
        
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReviewInCurrentScene()
        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + appId) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    static func showSafariLink(_ viewController: UIViewController, pageRoute: String){
        guard let url = URL(string: pageRoute) else { return }
        let vc = SFSafariViewController(url: url)
        viewController.present(vc, animated: true, completion: nil)
    }
    
    static func shareExternal(controller: CoordinatingDelegate, itemToShare: AnyObject){
       
        let sheet = UIActivityViewController(activityItems: [itemToShare as Any], applicationActivities: nil)
        
        controller.present(sheet, animated: true, completion: nil)
        
        let hapticFeedback = UINotificationFeedbackGenerator()
        hapticFeedback.notificationOccurred(.success)
    }
}
