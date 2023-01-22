//
//  HomeCell.swift
//  StoryTime
//
//  Created by Chuck on 25/11/2022.
//

import Foundation
import UIKit

class HomeCell: UICollectionViewCell, Providable {
    
    typealias ProvidedItem = PromptDTO
    
//    lazy var imageView = ViewGenerator.getImageView(ImageViewOptions(image: nil, size: (100, 100)))

    lazy var title = ViewGenerator.getLabel(LabelOptions(text: "title", color: .label, fontStyle: AppFonts.Bold(.body)))

    lazy var subTitle = ViewGenerator.getLabel(LabelOptions(text: "subtitle", color: .label, fontStyle: AppFonts.small))
    
    lazy var time = ViewGenerator.getLabel(LabelOptions(text: "", color: .label, fontStyle: AppFonts.small))

    let cornerRadius: CGFloat = 10

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        
        contentView.backgroundColor = MyColors.topGradient
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func provide(_ promptDto: PromptDTO) {
        title.text = "''"+promptDto.prompt!+"''"
        subTitle.text = promptDto.outputText
        
        if let createdDate = promptDto.promptOutput?.created {
            let date = Date(timeIntervalSince1970:  TimeInterval(createdDate))
            time.text = date.timeAgoSinceDate()
        }
        
    }


    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 0))
        
        contentView.layer.masksToBounds = false
        contentView.layer.cornerRadius = cornerRadius
        
//        contentView.layer.borderWidth = 1
//        addDropShadow()
        // Specify a shadowPath to improve shadow drawing performance
    }


    //MARK: Detect dark and light Mode Changes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {

            if traitCollection.userInterfaceStyle == .dark {
                layer.shadowColor = UIColor.white.cgColor
            }else{
                layer.shadowColor = UIColor.black.cgColor
            }
        }
    }


    private func setUpViews(){

        title.textAlignment = .left
        title.numberOfLines = 1
        title.adjustsFontSizeToFitWidth = false
        title.lineBreakMode = .byTruncatingTail
        
        subTitle.textAlignment = .left
        subTitle.numberOfLines = 1
        subTitle.adjustsFontSizeToFitWidth = false
        subTitle.lineBreakMode = .byTruncatingTail
        
//        contentView.addSubview(imageView)
        contentView.addSubview(title)
        contentView.addSubview(subTitle)
        contentView.addSubview(time)
        contentView.backgroundColor = .systemBackground
        contentView.sizeToFit()
        addConstraint()
    }

    private func addConstraint(){

        contentView.translatesAutoresizingMaskIntoConstraints = false

        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        contentView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        contentView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

//        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleTopMargin]

//        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
//        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        time.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        time.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        
        title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
//        title.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10).isActive = true
        title.bottomAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        title.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.95).isActive = true

        subTitle.topAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        subTitle.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.95).isActive = true
    }

}
