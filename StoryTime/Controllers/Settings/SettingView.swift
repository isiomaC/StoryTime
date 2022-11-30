//
//  SettingView.swift
//  StoryTime
//
//  Created by Chuck on 29/11/2022.
//

import Foundation
import UIKit

class SettingView: BaseView{
    
    lazy var logOutBtn = ViewGenerator.getGradientButton(ButtonOptions(title: "Log Out", color: MyColors.primary,  image: nil, smiley: nil, titleColor: .label))
    
    
    override func setUpViews() {
        addSubview(logOutBtn)
        backgroundColor = .red
        addConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        MyColors.setGradientBackground(view: logOutBtn, top: MyColors.topGradient, bottom: MyColors.bottomGradient)
        
    }
    
    func addConstraints(){
        
        logOutBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logOutBtn.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        logOutBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        logOutBtn.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive = true
    }
    
    
}
