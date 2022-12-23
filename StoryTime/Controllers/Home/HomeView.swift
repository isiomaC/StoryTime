//
//  HomeView.swift
//  StoryTime
//
//  Created by Chuck on 25/11/2022.
//

import Foundation
import UIKit

class HomeView: BaseView{
    
    lazy var container = UIView()
    
//    lazy var heading = ViewGenerator.getLabel(LabelOptions(text: "Pick Your Preferences", color: .label, fontStyle: AppFonts.Bold(.h4)))
    
//    lazy var showMore = ViewGenerator.getLabel(LabelOptions(text: "Show more", color: .label, fontStyle: AppFonts.Italic(.caption)))
    
    lazy var inputField = ViewGenerator.getTextField(TextFieldOptions(placeholder: "Enter initial prompts*", fontStyle: AppFonts.body))
    
    lazy var nextBtn = ViewGenerator.getGradientButton(ButtonOptions(title: "Next", color: MyColors.primary,  image: nil, smiley: nil, titleColor: .label))
    
    
    override func setUpViews() {
        
        inputField.textAlignment = .center
        
        addSubview(container)
        addSubview(inputField)
        addSubview(nextBtn)
                
        triggerConstraints()
        backgroundColor = .systemBackground
        

    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
        MyColors.setGradientBackground(
            view: nextBtn,
            top: MyColors.topGradient,
            bottom: MyColors.bottomGradient
        )
        
//        inputField.layer.borderColor = MyColors.primary.cgColor
//        inputField.layer.borderWidth = CGFloat(1)
        
        inputField.addBottomBorder(MyColors.primary)
    }
    
    private func triggerConstraints(){
        container.translatesAutoresizingMaskIntoConstraints = false
              
        container.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        container.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        container.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7).isActive = true
        
        
        inputField.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 5).isActive = true
        inputField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        inputField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        inputField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.07).isActive = true
       
        
        nextBtn.topAnchor.constraint(equalTo: inputField.bottomAnchor, constant: 5).isActive = true
        nextBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        nextBtn.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive = true
        nextBtn.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.07).isActive = true
    }
}
