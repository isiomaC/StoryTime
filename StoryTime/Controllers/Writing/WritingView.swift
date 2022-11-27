//
//  WritingView.swift
//  StoryTime
//
//  Created by Chuck on 27/11/2022.
//

import Foundation
import UIKit

class WritingView: BaseView {
    
    lazy var inputTextView = ViewGenerator.getTextView(TextViewOptions(backgroundColor: .systemBackground, placeholder: "dummy text here", alignment: .left, textColor: .label, fontStyle: AppFonts.body))
    
    lazy var saveBtn = ViewGenerator.getGradientButton(ButtonOptions(title: "Save", color: MyColors.primary,  image: nil, smiley: nil, titleColor: .label))
    
    lazy var continueBtn = ViewGenerator.getGradientButton(ButtonOptions(title: "Continue Writing", color: MyColors.primary,  image: nil, smiley: nil, titleColor: .label))
    
    lazy var iconBtn = ViewGenerator.getSimpleImageButton(image: UIImage(systemName: "person.fill")!)
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
        MyColors.setGradientBackground(view: saveBtn, top: MyColors.topGradient, bottom: MyColors.bottomGradient)
        MyColors.setGradientBackground(view: continueBtn, top: MyColors.topGradient, bottom: MyColors.bottomGradient)
        
        MyColors.setGradientBackground(view: inputTextView, top: MyColors.topGradient, bottom: .white)
        
        inputTextView.layer.cornerRadius = 20
    }
    
    override func setUpViews() {
        
        backgroundColor = .systemBackground
        addSubview(inputTextView)
        addSubview(saveBtn)
        addSubview(continueBtn)
        addSubview(iconBtn)
        triggerConstraints()
    }
    
    private func triggerConstraints(){
        
        inputTextView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.8).isActive = true
        inputTextView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        inputTextView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        inputTextView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        
        continueBtn.topAnchor.constraint(equalTo: inputTextView.bottomAnchor, constant: 20).isActive = true
        continueBtn.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        continueBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
//        continueBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        continueBtn.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -5).isActive = true
        
        
        saveBtn.topAnchor.constraint(equalTo: inputTextView.bottomAnchor, constant: 20).isActive = true
        saveBtn.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true
        saveBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        saveBtn.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 5).isActive = true
       
        
        
        iconBtn.topAnchor.constraint(equalTo: inputTextView.bottomAnchor, constant: 20).isActive = true
        iconBtn.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.15).isActive = true
        iconBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        iconBtn.leadingAnchor.constraint(equalTo: saveBtn.trailingAnchor, constant: 10).isActive = true
        
    }
    
}
