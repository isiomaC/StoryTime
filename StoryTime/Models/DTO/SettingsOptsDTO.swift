//
//  SettingsViewModel.swift
//  StoryTime
//
//  Created by Chuck on 17/01/2023.
//

import Foundation
import UIKit

struct SettingsOptsDTO{
    let name: String
    let nameTint: UIColor
    let image: UIImage
    let imageTint: UIColor
    let accessoryType : UITableViewCell.AccessoryType
    
    init(name: String, nameTint: UIColor = .darkText, image: UIImage, imageTint: UIColor = .darkText, accessoryType: UITableViewCell.AccessoryType = .disclosureIndicator) {
        self.name = name
        self.nameTint = nameTint
        self.image = image
        self.imageTint = imageTint
        self.accessoryType = accessoryType
    }
    
    static func getSystemImage(name: String, defaultName: String = "app.fill") -> UIImage{
        var image: UIImage
        
        let config = UIImage.SymbolConfiguration(scale: .medium )
        
        if let unwrappedImage = UIImage(systemName: name, withConfiguration: config){
            image = unwrappedImage
        }else{
            image = UIImage(systemName: defaultName, withConfiguration: config)!
        }
        
        return image
    }
    
    static var sections: [String] {
        return ["", "ACCOUNT", "INFO", "", ""]
    }
    
    static func options() -> ([SettingsOptsDTO], [SettingsOptsDTO], [SettingsOptsDTO],[SettingsOptsDTO], [SettingsOptsDTO]) {
        let settingsOptions: [SettingsOptsDTO] = [
            SettingsOptsDTO(name: SettingsConstants.tokens, image: getSystemImage(name: "app.fill") ), //aqi.medium
        ]
        
        let accountOptions = [
            SettingsOptsDTO(name: SettingsConstants.email, image: getSystemImage(name: "app.fill") ),
            SettingsOptsDTO(name: SettingsConstants.changePwd, image: getSystemImage(name: "app.fill") ), //aqi.medium
        ]
   
        let infoOptions: [SettingsOptsDTO] = [
            SettingsOptsDTO(name: SettingsConstants.shareWithFriend,  image: getSystemImage(name: "megaphone.fill") ),
            
            SettingsOptsDTO(name: SettingsConstants.rateUs, image: getSystemImage(name: "star.leadinghalf.filled")),
            
            SettingsOptsDTO(name: SettingsConstants.termsUse,  image: getSystemImage(name: "doc.on.clipboard") ),
            
            SettingsOptsDTO(name: SettingsConstants.privacyPolicy,  image: getSystemImage(name: "lock.doc") ),
        ]
        
        let logOutOptions = [ SettingsOptsDTO(name: SettingsConstants.logOut,  image: getSystemImage(name: "app.fill") )]
        
        let deleteOptions = [SettingsOptsDTO(name: SettingsConstants.deleteAccount,  image: getSystemImage(name: "trash.fill") ),]
        
        return (settingsOptions, accountOptions, infoOptions, logOutOptions,  deleteOptions)
    }
    
}
