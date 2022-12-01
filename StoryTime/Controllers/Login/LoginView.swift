//
//  LoginView.swift
//  StoryTime
//
//  Created by Chuck on 27/11/2022.
//

import Foundation
import UIKit


class LoginView: BaseView{
    
   
    lazy var topArea = UIView()
    lazy var iconImage = ViewGenerator.getImageView(ImageViewOptions(image: UIImage(named: "myIcon")!, size: (100, 100)))
    
    lazy var title = ViewGenerator.getLabel(LabelOptions(text: "Login", color: .black, fontStyle: AppFonts.title))
    lazy var subTitle = ViewGenerator.getLabel(LabelOptions(text: "It only takes a minute", color: .black, fontStyle: AppFonts.caption))
    
    
    lazy var googleBtn = ViewGenerator.getGradientButton(ButtonOptions(title: "Continue with Google", color: MyColors.primary,  image: nil, smiley: nil, titleColor: .label))
    
    lazy var loginBtn = ViewGenerator.getGradientButton(ButtonOptions(title: "Login", color: MyColors.primary,  image: nil, smiley: nil, titleColor: .label))
    
    lazy var emailField  =  ViewGenerator.getTextField(TextFieldOptions(
                                                            placeholder: "Enter email",
                                                            fontStyle: AppFonts.body,
                                                            keyboardType: .emailAddress
                                                            ))
          
    lazy var pwdField =  ViewGenerator.getTextField(TextFieldOptions(
                                                        placeholder: "Enter Password",
                                                        fontStyle: AppFonts.body,
                                                        keyboardType: .default,
                                                        secured: .secured ))
    
    lazy var orText = ViewGenerator.getLabel(LabelOptions(text: "Or", color: .secondaryLabel, fontStyle: AppFonts.body))
    
    lazy var createAcctBn = ViewGenerator.getButton(ButtonOptions(title: "Create account", color: .systemBackground,  image: nil, smiley: nil, titleColor: MyColors.primary), circular: false, bordered: false)
    
    
    override func setUpViews() {
        
        backgroundColor = .systemBackground
                     
        topArea.addSubview(iconImage)
        topArea.addSubview(title)
        topArea.addSubview(subTitle)
        addSubview(topArea)
        
        addSubview(googleBtn)
        addSubview(loginBtn)
        addSubview(emailField)
        addSubview(pwdField)
        
        
        emailField.setPaddingX(4)
        pwdField.setPaddingX(4)
        
        addSubview(orText)
        addSubview(createAcctBn)
        
        triggerConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        MyColors.setGradientBackground(view: topArea, top: MyColors.topGradient, bottom: .white)
        MyColors.setGradientBackground(view: googleBtn, top: MyColors.topGradient, bottom: MyColors.bottomGradient)
        MyColors.setGradientBackground(view: loginBtn, top: MyColors.topGradient, bottom: MyColors.bottomGradient)
        
        emailField.addBottomBorder()
        pwdField.addBottomBorder()
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
        
        pwdField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20).isActive = true
        pwdField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        pwdField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pwdField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        
        loginBtn.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        loginBtn.topAnchor.constraint(equalTo: pwdField.bottomAnchor, constant: 40).isActive = true
        loginBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        loginBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        
        googleBtn.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        googleBtn.topAnchor.constraint(equalTo: loginBtn.bottomAnchor, constant: 20).isActive = true
        googleBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        googleBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        

        orText.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        orText.topAnchor.constraint(equalTo: googleBtn.bottomAnchor, constant: 20).isActive = true

        createAcctBn.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        createAcctBn.topAnchor.constraint(equalTo: orText.bottomAnchor, constant: 20).isActive = true
        createAcctBn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        createAcctBn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
