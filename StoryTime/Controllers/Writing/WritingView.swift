//
//  WritingView.swift
//  StoryTime
//
//  Created by Chuck on 27/11/2022.
//

import Foundation
import UIKit

class WritingView: BaseView {
    
    lazy var outputField = ViewGenerator.getTextView(TextViewOptions(backgroundColor: .systemBackground, placeholder: "dummy text here", alignment: .left, textColor: .label, fontStyle: AppFonts.body))
    
    lazy var saveBtn = ViewGenerator.getGradientButton(ButtonOptions(title: "Save", color: MyColors.primary,  image: nil, smiley: nil, titleColor: .label))
    
    lazy var promptBtn = ViewGenerator.getGradientButton(ButtonOptions(title: "Prompt", color: MyColors.primary,  image: nil, smiley: nil, titleColor: .label))
    
    lazy var iconBtn = ViewGenerator.getSimpleImageButton(image: UIImage(systemName: "square.and.arrow.up")!)
    
    
    lazy var wordCount = ViewGenerator.getLabel(LabelOptions(text: "words", color: .secondaryLabel, fontStyle: AppFonts.Italic(.caption)))
    
    lazy var promptField = ViewGenerator.getTextField(TextFieldOptions(placeholder: "Enter prompt*", fontStyle: AppFonts.body))

    
    override func layoutSubviews(){
        super.layoutSubviews()
        
        MyColors.setGradientBackground(view: saveBtn, top: MyColors.topGradient, bottom: MyColors.bottomGradient)
        
        MyColors.setGradientBackground(view: promptBtn, top: MyColors.topGradient, bottom: MyColors.bottomGradient)
        
        MyColors.setGradientBackground(view: outputField, top: MyColors.topGradient, bottom: .white)
        
        outputField.layer.cornerRadius = 20
        
        promptField.layer.borderColor = MyColors.primary.cgColor
        promptField.layer.borderWidth = CGFloat(1)
        promptField.setLeftPaddingPoints(5)
        promptField.setRightPaddingPoints(5)
        
        wordCount.textAlignment = .right
    }
    
    func setWordCount(_ count: Int){
        wordCount.text = "\(count) words"
    }
    
    override func setUpViews() {
        
        backgroundColor = .systemBackground
        addSubview(outputField)
        addSubview(saveBtn)
        addSubview(promptBtn)
        addSubview(iconBtn)
        
        
        addSubview(wordCount)
        addSubview(promptField)
        
        triggerConstraints()
    }
    
    private func triggerConstraints(){
        
        outputField.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.6).isActive = true
        outputField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        outputField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        outputField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        
        wordCount.trailingAnchor.constraint(equalTo: outputField.trailingAnchor).isActive = true
        wordCount.topAnchor.constraint(equalTo: outputField.bottomAnchor, constant: 10).isActive = true
        wordCount.leadingAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        promptField.topAnchor.constraint(equalTo: wordCount.bottomAnchor, constant: 20).isActive = true
        promptField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        promptField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        promptField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.07).isActive = true
        
        
        promptBtn.topAnchor.constraint(equalTo: promptField.bottomAnchor, constant: 20).isActive = true
        promptBtn.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        promptBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
//        continueBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        promptBtn.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -5).isActive = true
        
        
        saveBtn.topAnchor.constraint(equalTo: promptField.bottomAnchor, constant: 20).isActive = true
        saveBtn.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true
        saveBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        saveBtn.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 5).isActive = true
       
        
        iconBtn.topAnchor.constraint(equalTo: promptField.bottomAnchor, constant: 20).isActive = true
        iconBtn.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.15).isActive = true
        iconBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        iconBtn.leadingAnchor.constraint(equalTo: saveBtn.trailingAnchor, constant: 10).isActive = true
        
    }
    
}
