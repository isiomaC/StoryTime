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
    
    lazy var heading = ViewGenerator.getLabel(LabelOptions(text: "Pick Your Preferences", color: .label, fontStyle: AppFonts.Bold(.h4)))
    
    lazy var showMore = ViewGenerator.getLabel(LabelOptions(text: "Show more", color: .label, fontStyle: AppFonts.Italic(.caption)))
    
    lazy var inputField = ViewGenerator.getTextField(TextFieldOptions(placeholder: "Prompts (seperate by comma)*", fontStyle: AppFonts.body))
    
    lazy var nextBtn = ViewGenerator.getGradientButton(ButtonOptions(title: "Next", color: MyColors.primary,  image: nil, smiley: nil, titleColor: .label))
    
    
    override func setUpViews() {
        
        addSubview(heading)
        addSubview(container)
        addSubview(inputField)
        addSubview(showMore)
        addSubview(nextBtn)
                
        triggerConstraints()
        backgroundColor = .systemBackground

    }
    
    private func addBottomBorderInputField(){
        inputField.textAlignment = .center
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: inputField.frame.height - 1, width: inputField.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.label.cgColor
        inputField.borderStyle = UITextField.BorderStyle.none
        inputField.layer.addSublayer(bottomLine)
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        MyColors.setGradientBackground(view: nextBtn, top: MyColors.topGradient, bottom: MyColors.bottomGradient)
        addBottomBorderInputField()
    }
    
    private func triggerConstraints(){
        container.translatesAutoresizingMaskIntoConstraints = false
        
        heading.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        heading.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        heading.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        
        container.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        container.topAnchor.constraint(equalTo: heading.bottomAnchor, constant: 15).isActive = true
        container.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6).isActive = true
        
        showMore.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 10).isActive =  true
        showMore.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive =  true
        showMore.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3).isActive = true
        
        inputField.topAnchor.constraint(equalTo: showMore.bottomAnchor, constant: 10).isActive = true
        inputField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        inputField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        inputField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        nextBtn.topAnchor.constraint(equalTo: inputField.bottomAnchor, constant: 20).isActive = true
        nextBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        nextBtn.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive = true
        nextBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
}
