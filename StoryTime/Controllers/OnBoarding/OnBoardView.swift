//
//  OnBoardView.swift
//  StoryTime
//
//  Created by Chuck on 25/11/2022.
//

import Foundation
import UIKit

class OnBoardView: BaseView {
    
    lazy var title = ViewGenerator.getLabel(LabelOptions(text: "Write your valuable content, save and share", color: .label, fontStyle: AppFonts.Bold(.h4)))
    
    lazy var body = ViewGenerator.getLabel(LabelOptions(text: "hey this app can lorem ipsum lorem iipsum lorem ipsum, lorem ipsum lorem iipsum lorem ipsum, lorem ipsum lorem iipsum lorem ipsum", color: .secondaryLabel, fontStyle: AppFonts.body))
    
    lazy var undrawImage = ViewGenerator.getImageView(ImageViewOptions(image: UIImage(named: "undraw"), size: (100, 100)))
    
    lazy var getStartedBtn = ViewGenerator.getGradientButton(ButtonOptions(title: "Get Started", color: MyColors.primary,  image: nil, smiley: nil, titleColor: .label))
    
    lazy var topArea = UIView()
    
    lazy var bottomArea = UIView()
    
    override func setUpViews(){
        
        addSubview(topArea)
        addSubview(bottomArea)
        topArea.addSubview(undrawImage)
        bottomArea.addSubview(title)
        bottomArea.addSubview(body)
        bottomArea.addSubview(getStartedBtn)
        addConstraints()
        
       
    }
    
    
    override func layoutSubviews(){
        super.layoutSubviews()
        MyColors.setGradientBackground(view: getStartedBtn, top: MyColors.topGradient, bottom: MyColors.bottomGradient)
    }
    
    private func addConstraints(){
        topArea.translatesAutoresizingMaskIntoConstraints = false
        topArea.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        topArea.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topArea.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6).isActive = true
        
        
        bottomArea.translatesAutoresizingMaskIntoConstraints = false
        bottomArea.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        bottomArea.topAnchor.constraint(equalTo: topArea.bottomAnchor).isActive = true
        bottomArea.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4).isActive = true
        
        
        //Image View
        undrawImage.centerYAnchor.constraint(equalTo: topArea.centerYAnchor, constant: 30).isActive = true
        undrawImage.centerXAnchor.constraint(equalTo: topArea.centerXAnchor).isActive = true
        
        
        //title
        title.topAnchor.constraint(equalTo: bottomArea.topAnchor).isActive = true
        title.centerXAnchor.constraint(equalTo: bottomArea.centerXAnchor).isActive = true
        title.heightAnchor.constraint(equalTo: bottomArea.heightAnchor, multiplier: 0.2).isActive = true
        title.widthAnchor.constraint(equalTo: bottomArea.widthAnchor, multiplier: 0.9).isActive = true
        
        body.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        body.centerXAnchor.constraint(equalTo: bottomArea.centerXAnchor).isActive = true
        body.heightAnchor.constraint(equalTo: bottomArea.heightAnchor, multiplier: 0.4).isActive = true
        body.widthAnchor.constraint(equalTo: bottomArea.widthAnchor, multiplier: 0.9).isActive = true
        
        getStartedBtn.topAnchor.constraint(equalTo: body.bottomAnchor).isActive = true
        getStartedBtn.centerXAnchor.constraint(equalTo: bottomArea.centerXAnchor).isActive = true
        getStartedBtn.heightAnchor.constraint(equalTo: bottomArea.heightAnchor, multiplier: 0.15).isActive = true
        getStartedBtn.widthAnchor.constraint(equalTo: bottomArea.widthAnchor, multiplier: 0.8).isActive = true
    }
}
