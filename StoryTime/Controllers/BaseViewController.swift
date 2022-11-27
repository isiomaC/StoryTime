//
//  BaseViewController.swift
//  StoryTime
//
//  Created by Chuck on 27/11/2022.
//

import Foundation
import UIKit

class BaseViewController: CoordinatingDelegate {
    
    var coordinator: Coordinator?
    
    //MARK: Detect dark and light Mode Changes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            
            if traitCollection.userInterfaceStyle == .dark {
                navigationController?.navigationBar.tintColor = .white
            }else{
                navigationController?.navigationBar.tintColor = .black
            }
        }
    }
}
