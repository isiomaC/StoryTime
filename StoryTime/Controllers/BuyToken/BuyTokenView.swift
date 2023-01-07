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
    lazy var title = ViewGenerator.getLabel(LabelOptions(text: "Choose a token plan", color: .black, fontStyle: AppFonts.title))
    lazy var iconImage = ViewGenerator.getImageView(ImageViewOptions(image: UIImage(named: "myIcon")!, size: (100, 100)))
    
    lazy var infoIcon1 = ViewGenerator.getImageView(ImageViewOptions(image: UIImage(named: "check")!, size: (20, 20)))
    lazy var info1 = ViewGenerator.getLabel(LabelOptions(text: "Save countless prompt output", color: .black, fontStyle: AppFonts.caption))
    
    lazy var infoIcon2 = ViewGenerator.getImageView(ImageViewOptions(image: UIImage(named: "check")!, size: (20, 20)))
    lazy var info2 = ViewGenerator.getLabel(LabelOptions(text: "Limitless prompts", color: .black, fontStyle: AppFonts.caption))
    
    lazy var infoIcon3 = ViewGenerator.getImageView(ImageViewOptions(image: UIImage(named: "check")!, size: (20, 20)))
    lazy var info3 = ViewGenerator.getLabel(LabelOptions(text: "Mobile AI assitant", color: .black, fontStyle: AppFonts.caption))
    
    lazy var button_199 = ViewGenerator.getGradientButton(ButtonOptions(title: "$1.99", color: MyColors.primary,  image: nil, smiley: nil, titleColor: .label))
    lazy var button_299 = ViewGenerator.getGradientButton(ButtonOptions(title: "$1.99", color: MyColors.primary,  image: nil, smiley: nil, titleColor: .label))
    lazy var button_399 = ViewGenerator.getGradientButton(ButtonOptions(title: "$1.99", color: MyColors.primary,  image: nil, smiley: nil, titleColor: .label))
    
    override func setUpViews() {
        
        // MARK: Remove - Testing
        topArea.backgroundColor = .systemPink
        
        addSubview(topArea)
        topArea.addSubview(title)
        topArea.addSubview(iconImage)
        
        addSubview(infoIcon1)
        addSubview(info1)
        addSubview(infoIcon2)
        addSubview(info2)
        addSubview(infoIcon3)
        addSubview(info3)
        
        addSubview(button_199)
        addSubview(button_299)
        addSubview(button_399)
        triggerConstraints()
    }
    
    private func triggerConstraints(){
        
        topArea.translatesAutoresizingMaskIntoConstraints = false
        topArea.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topArea.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        topArea.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.35).isActive = true

        title.topAnchor.constraint(equalTo: topArea.topAnchor, constant: 20).isActive = true
        title.centerXAnchor.constraint(equalTo: topArea.centerXAnchor).isActive = true
        
        iconImage.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        iconImage.centerXAnchor.constraint(equalTo: topArea.centerXAnchor).isActive = true
        
        
    }
}
