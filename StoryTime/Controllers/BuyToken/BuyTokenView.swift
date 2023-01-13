//
//  BuyTokenView.swift
//  StoryTime
//
//  Created by Chuck on 07/01/2023.
//

import Foundation
import UIKit

class BuyTokenView: BaseView{
    
    lazy var topArea = UIView()
    
    lazy var bottomArea = UIView()
    
    lazy var title = ViewGenerator.getLabel(LabelOptions(text: "Choose a plan", color: .label, fontStyle: AppFonts.title))
    lazy var iconImage = ViewGenerator.getImageView(ImageViewOptions(image: UIImage(named: "myIcon")!, size: (100, 100)))
    
    lazy var button_199 = ViewGenerator.getGradientButton(ButtonOptions(title: "$1.99", color: MyColors.primary,  image: nil, smiley: nil, titleColor: .label))
    lazy var button_299 = ViewGenerator.getGradientButton(ButtonOptions(title: "$2.99", color: MyColors.primary,  image: nil, smiley: nil, titleColor: .label))
    lazy var button_399 = ViewGenerator.getGradientButton(ButtonOptions(title: "$3.99", color: MyColors.primary,  image: nil, smiley: nil, titleColor: .label))
    
    lazy var infoList = UITableView(frame: CGRect.zero, style: .plain)
    
    override func setUpViews() {
        
        backgroundColor = .systemBackground
        
        addSubview(topArea)
        addSubview(bottomArea)
        topArea.addSubview(title)
        topArea.addSubview(iconImage)
        
        bottomArea.addSubview(infoList)
        
        bottomArea.addSubview(button_199)
        bottomArea.addSubview(button_299)
        bottomArea.addSubview(button_399)
        
        button_199.tag = BuyButtonTags.aiBuddy_001.rawValue
        button_299.tag = BuyButtonTags.aiBuddy_002.rawValue
        button_399.tag = BuyButtonTags.aiBuddy_003.rawValue
        
        
        triggerConstraints()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        MyColors.setGradientBackground(view: topArea, top: MyColors.topGradient, bottom: .systemBackground)
        MyColors.setGradientBackground(view: button_199, top: MyColors.topGradient, bottom: MyColors.bottomGradient)
        MyColors.setGradientBackground(view: button_299, top: MyColors.topGradient, bottom: MyColors.bottomGradient)
        MyColors.setGradientBackground(view: button_399, top: MyColors.topGradient, bottom: MyColors.bottomGradient)
    }
    
    //MARK: Detect dark and light Mode Changes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {

            if traitCollection.userInterfaceStyle == .dark {
                MyColors.setGradientBackground(view: topArea, top: MyColors.topGradient, bottom: .black)

            }else{
                MyColors.setGradientBackground(view: topArea, top: MyColors.topGradient, bottom: .white)

            }
        }
    }
    
    private func triggerConstraints(){
        bottomArea.translatesAutoresizingMaskIntoConstraints = false
        topArea.translatesAutoresizingMaskIntoConstraints = false
        infoList.translatesAutoresizingMaskIntoConstraints = false
        
        topArea.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topArea.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        topArea.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.35).isActive = true
        
        bottomArea.translatesAutoresizingMaskIntoConstraints = false
        bottomArea.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        bottomArea.topAnchor.constraint(equalTo: topArea.bottomAnchor).isActive = true
        bottomArea.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.65).isActive = true

        title.topAnchor.constraint(equalTo: topArea.topAnchor, constant: 20).isActive = true
        title.centerXAnchor.constraint(equalTo: topArea.centerXAnchor).isActive = true
        
        iconImage.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        iconImage.centerXAnchor.constraint(equalTo: topArea.centerXAnchor).isActive = true
        
        infoList.topAnchor.constraint(equalTo: bottomArea.topAnchor, constant: 10).isActive = true
        infoList.leadingAnchor.constraint(equalTo: bottomArea.leadingAnchor).isActive = true
        infoList.trailingAnchor.constraint(equalTo: bottomArea.trailingAnchor).isActive = true
        infoList.heightAnchor.constraint(equalTo: bottomArea.heightAnchor, multiplier: 0.6).isActive = true
        
        button_199.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        button_199.topAnchor.constraint(equalTo: infoList.bottomAnchor, constant: 5).isActive = true
        button_199.centerXAnchor.constraint(equalTo: bottomArea.centerXAnchor).isActive = true
        button_199.heightAnchor.constraint(equalToConstant: 45).isActive = true

        button_299.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        button_299.topAnchor.constraint(equalTo: button_199.bottomAnchor, constant: 5).isActive = true
        button_299.centerXAnchor.constraint(equalTo: bottomArea.centerXAnchor).isActive = true
        button_299.heightAnchor.constraint(equalToConstant: 45).isActive = true

        button_399.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        button_399.topAnchor.constraint(equalTo: button_299.bottomAnchor, constant: 5).isActive = true
        button_399.centerXAnchor.constraint(equalTo: bottomArea.centerXAnchor).isActive = true
        button_399.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
}
