//
//  AccountView.swift
//  StoryTime
//
//  Created by Chuck on 28/11/2022.
//

import Foundation
import UIKit

class AccountView: BaseView{
    
    let imageWidth = Dimensions.halfScreenWidth * 0.65
    
    lazy var accountImage = ViewGenerator.getImageView(ImageViewOptions(image: UIImage(systemName: "trash"), size: (width: imageWidth, height: imageWidth)))

    lazy var email = ViewGenerator.getLabel(LabelOptions(text: "title@email.test", color: .label, fontStyle: AppFonts.Bold(.title)))
    
    lazy var tokensLabel = ViewGenerator.getLabel(LabelOptions(text: "tokens", color: .label, fontStyle: AppFonts.Bold(.body)))
    
    lazy var container = UIView()
    
    override func setUpViews(){
        addSubview(container)
        container.addSubview(accountImage)
        container.addSubview(email)
        accountImage.backgroundColor = .systemGray3
        addConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        accountImage.roundCorners(corners: [.allCorners], radius: 20)
//        accountImage.contentMode = .redraw
    }
    
    private func addConstraints() {
        
        container.translatesAutoresizingMaskIntoConstraints = false
        container.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        container.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3).isActive = true
        container.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        accountImage.topAnchor.constraint(equalTo: container.topAnchor, constant: 30).isActive = true
        accountImage.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        accountImage.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        accountImage.heightAnchor.constraint(equalToConstant: imageWidth).isActive = true
        
        email.topAnchor.constraint(equalTo: accountImage.bottomAnchor, constant: 10).isActive = true
        email.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        
    }
    
}
