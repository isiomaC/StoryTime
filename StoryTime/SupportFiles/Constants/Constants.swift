//
//  Constants.swift
//  StoryTime
//
//  Created by Chuck on 24/11/2022.
//

import Foundation
import UIKit

let FIREBASENOINTERNETCODE = 17020
let AUTHINVALIDPWD = 17009
let AUTHUNREGISTEREDEMAIL = 17011
let AUTHBADEMAILFORMAT = 17008

//MARK: Buy Button Tags
enum BuyButtonTags: Int{
    case aiBuddy_001 = 1
    case aiBuddy_002
    case aiBuddy_003
}


// MARK: Screen Dimensions
struct Dimensions{
    static let SCREENSIZE = UIScreen.main.bounds
    static let halfScreenHeight = SCREENSIZE.height*0.5
    static let halfScreenWidth = SCREENSIZE.width*0.5
}


//MARK: View Controller Names
struct VCNames{
    static let ACCOUNT = "Account"
    static let HOME = "Home"
    static let SETTINGS = "Settings"
}



// MARK: User Default Keys
struct UserDefaultkeys {
    
    static let hasLaunched = "HasLaunched"
    static let isAuthenticated = "UserAuthenticated"
    
    
    static let firstCameraCheck = "FirstCameraAccessCheck"
    static let isSubscribed = "UserSubscribed"
   
    static let reviewWorthyCount = "reviewWorthyCount"
    static let lastReviewRequestAppVersion = "lastReviewedVersion"
    
    static let seenTutorial = "seenTutorial"
}


//MARK: UIView Tags
struct Tags{
    
}


//MARK: Font Sizes

struct AppFonts {
    
    static let h1 = Font(size: .custom(40)).instance
    static let h2 = Font(size: .custom(35)).instance
    static let h3 = Font(size: .custom(30)).instance
    static let h4 = Font(size: .custom(25)).instance
    static let title = Font(size: .custom(22)).instance
    static let subTitle = Font(size: .custom(20)).instance
    static let body = Font(size: .custom(16)).instance
    static let caption = Font(size: .custom(14)).instance
    static let small = Font(size: .custom(12)).instance
    static let xsmall = Font(size: .custom(10)).instance
    
    enum Typography: Int {
        case h1 = 40
        case h2 = 35
        case h3 = 30
        case h4 = 25
        case title = 22
        case subtitle = 20
        case body = 16
        case caption = 14
        case small = 12
        case xsmall = 10
    }
    
    static func Bold(_ name: Typography) -> UIFont{
        let font = Font(type: .systemBold, size: .custom(Double(name.rawValue))).instance
        return font
    }
    
    static func Normal(_ name: Typography) -> UIFont{
        let font = Font(type: .system, size: .custom(Double(name.rawValue))).instance
        return font
    }
    
    static func Italic(_ name: Typography) -> UIFont{
        let font = Font(type: .systemItatic, size: .custom(Double(name.rawValue))).instance
        return font
    }

}
