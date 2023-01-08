//
//  SignUpView.swift
//  StoryTime
//
//  Created by Chuck on 27/11/2022.
//

import Foundation
import UIKit

class SignUpView: BaseView{
    
    lazy var topArea = UIView()
    lazy var iconImage = ViewGenerator.getImageView(ImageViewOptions(image: UIImage(named: "myIcon")!, size: (100, 100)))
    
    lazy var title = ViewGenerator.getLabel(LabelOptions(text: "Sign Up", color: .black, fontStyle: AppFonts.title))
    lazy var subTitle = ViewGenerator.getLabel(LabelOptions(text: "It only takes a minute", color: .black, fontStyle: AppFonts.caption))
    
    lazy var signupBtn = ViewGenerator.getGradientButton(ButtonOptions(title: "Register", color: MyColors.primary,  image: nil, smiley: nil, titleColor: .label))
    
    lazy var emailField  =  ViewGenerator.getTextField(TextFieldOptions(
                                                            placeholder: "Enter email",
                                                            fontStyle: AppFonts.body,
                                                            keyboardType: .default
                                                            ))
          
    lazy var pwdField =  ViewGenerator.getTextField(TextFieldOptions(
                                                        placeholder: "Enter password",
                                                        fontStyle: AppFonts.body,
                                                        keyboardType: .default,
                                                        secured: .secured ))
    
    lazy var pwdField2 =  ViewGenerator.getTextField(TextFieldOptions(
                                                        placeholder: "Enter password again",
                                                        fontStyle: AppFonts.body,
                                                        keyboardType: .default,
                                                        secured: .secured ))
    
    lazy var loginBtn = ViewGenerator.getButton(ButtonOptions(title: "Login", color: .systemBackground,  image: nil, smiley: nil, titleColor: MyColors.primary), circular: false, bordered: false)
    
    override func setUpViews() {
        
        backgroundColor = .systemBackground
                     
        topArea.addSubview(iconImage)
        topArea.addSubview(title)
        topArea.addSubview(subTitle)
        addSubview(topArea)
        
        addSubview(signupBtn)
        addSubview(emailField)
        addSubview(pwdField)
        addSubview(pwdField2)
        addSubview(loginBtn)
        
        
        emailField.setPaddingX(4)
        pwdField.setPaddingX(4)
        
       
        
        triggerConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        MyColors.setGradientBackground(view: topArea, top: MyColors.topGradient, bottom: .systemBackground)
       
        MyColors.setGradientBackground(view: signupBtn, top: MyColors.topGradient, bottom: MyColors.bottomGradient)
        
        emailField.addBottomBorder()
        pwdField.addBottomBorder()
        pwdField2.addBottomBorder()
    }
    
    private func triggerConstraints(){
        topArea.translatesAutoresizingMaskIntoConstraints = false
        topArea.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topArea.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        topArea.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4).isActive = true
        
        iconImage.centerXAnchor.constraint(equalTo: topArea.centerXAnchor).isActive = true
        iconImage.centerYAnchor.constraint(equalTo: topArea.centerYAnchor, constant: -30).isActive = true

        title.topAnchor.constraint(equalTo: iconImage.bottomAnchor).isActive = true
        title.centerXAnchor.constraint(equalTo: topArea.centerXAnchor).isActive = true

        subTitle.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        subTitle.centerXAnchor.constraint(equalTo: topArea.centerXAnchor).isActive = true
        
        
        emailField.topAnchor.constraint(equalTo: topArea.bottomAnchor, constant: 30).isActive = true
        emailField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        emailField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        emailField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        pwdField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 30).isActive = true
        pwdField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        pwdField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pwdField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        
        pwdField2.topAnchor.constraint(equalTo: pwdField.bottomAnchor, constant: 30).isActive = true
        pwdField2.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        pwdField2.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pwdField2.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        
        signupBtn.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        signupBtn.topAnchor.constraint(equalTo: pwdField2.bottomAnchor, constant: 40).isActive = true
        signupBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        signupBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        loginBtn.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        loginBtn.topAnchor.constraint(equalTo: signupBtn.bottomAnchor, constant: 20).isActive = true
        loginBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        loginBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    
    }
}
