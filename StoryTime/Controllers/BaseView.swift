//
//  BaseView.swift
//  StoryTime
//
//  Created by Chuck on 25/11/2022.
//

import Foundation
import UIKit

class BaseView : UIView {
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        setUpViews()
    }
    
    func setUpViews(){
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
}
