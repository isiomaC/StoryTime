//
//  AccountView.swift
//  StoryTime
//
//  Created by Chuck on 28/11/2022.
//

import Foundation
import UIKit

class PwdResetView: BaseView{
    
    lazy var container = UIView()
    
  
    lazy var newPwd = ViewGenerator.getTextField(TextFieldOptions(
                                                        placeholder: "Enter new password",
                                                        fontStyle: AppFonts.body,
                                                        keyboardType: .default,
                                                        secured: .secured ))
    
    lazy var newPwd2 = ViewGenerator.getTextField(TextFieldOptions(
                                                        placeholder: "Enter new password again",
                                                        fontStyle: AppFonts.body,
                                                        keyboardType: .default,
                                                        secured: .secured ))
    
    lazy var resetPwdBtn = ViewGenerator.getGradientButton(ButtonOptions(title: "Continue", color: MyColors.primary,  image: nil, smiley: nil, titleColor: .label))
    
    
    override func setUpViews(){
        addSubview(newPwd)
        addSubview(newPwd2)
        addSubview(resetPwdBtn)
        addConstraints()
        
        backgroundColor = .systemBackground
        
        newPwd.addRightIcon(image: UIImage(systemName: "eye.fill")!)
        newPwd2.addRightIcon(image: UIImage(systemName: "eye.fill")!) //eye.slash.fill
    }
    
   
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        accountImage.roundCorners(corners: [.allCorners], radius: 20)
//        accountImage.contentMode = .redraw
        
        MyColors.setGradientBackground(view: resetPwdBtn, top: MyColors.topGradient, bottom: MyColors.bottomGradient)
        
//        oldPwd.addBottomBorder()
        newPwd.addBottomBorder()
        newPwd2.addBottomBorder()
    }
    
    private func addConstraints() {

        
        newPwd.topAnchor.constraint(equalTo: topAnchor, constant: 60).isActive = true
        newPwd.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        newPwd.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        newPwd.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        newPwd2.topAnchor.constraint(equalTo: newPwd.bottomAnchor, constant: 20).isActive = true
        newPwd2.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
        newPwd2.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        newPwd2.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        resetPwdBtn.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        resetPwdBtn.topAnchor.constraint(equalTo: newPwd2.bottomAnchor, constant: 60).isActive = true
        resetPwdBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        resetPwdBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

    }
    
}
