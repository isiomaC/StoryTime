//
//  HomeCell.swift
//  StoryTime
//
//  Created by Chuck on 25/11/2022.
//

import Foundation
import UIKit

class HomeCell: UICollectionViewListCell, Providable {
    typealias ProvidedItem = ListItem
    
    public func provide(_ homeDto: ListItem) {
        
        
    }
}


//class HomeCell: UICollectionViewCell, Providable{
//
////    typealias ProvidedItem = HomeDto
//    typealias ProvidedItem = ListItem
//
//    lazy var imageView = ViewGenerator.getImageView(ImageViewOptions(image: nil, size: (100, 100)))
//
//    lazy var title = ViewGenerator.getLabel(LabelOptions(text: "title", color: .label, fontStyle: AppFonts.Bold(.subtitle)))
//
//    lazy var subTitle = ViewGenerator.getLabel(LabelOptions(text: "subtitle", color: .label, fontStyle: AppFonts.caption))
//
//    let cornerRadius: CGFloat = 10
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setUpViews()
//    }
//
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//    public func provide(_ homeDto: ListItem) {
//        //set values for views here
////        imageView.image = UIImage(named: homeDto.imageName)
////        title.text = homeDto.title
////        subTitle.text = homeDto.subTitle
//    }
//
//
//    private func addDropShadow(){
//
//        // Drop Shadows
//        layer.cornerRadius = cornerRadius
//        layer.masksToBounds = false
//
//        // How blurred the shadow is
//        layer.shadowRadius = 8.0
//
//        // The color of the drop shadow
//        let isDark = UIScreen.main.traitCollection.userInterfaceStyle == .dark ? true : false
//
//        layer.shadowColor = isDark ? UIColor.white.cgColor : UIColor.black.cgColor
//
//        // How transparent the drop shadow is
//        layer.shadowOpacity = 0.10
//
//        // How far the shadow is offset from the UICollectionViewCell’s frame
//        layer.shadowOffset = CGSize(width: 0, height: 10)
//
//    }
//
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        contentView.layer.masksToBounds = true
//        contentView.layer.cornerRadius = cornerRadius
////        contentView.layer.borderWidth = 1
//        contentView.layer.borderColor = MyColors.primary.cgColor
//
//        // Specify a shadowPath to improve shadow drawing performance
//        layer.shadowPath = UIBezierPath(
//            roundedRect: bounds,
//            cornerRadius: cornerRadius
//        ).cgPath
//    }
//
//
//    //MARK: Detect dark and light Mode Changes
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//
//        if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
//
//            if traitCollection.userInterfaceStyle == .dark {
//                layer.shadowColor = UIColor.white.cgColor
//            }else{
//                layer.shadowColor = UIColor.black.cgColor
//            }
//        }
//    }
//
//
//    private func setUpViews(){
//
//        title.textAlignment = .left
//        subTitle.textAlignment = .left
//
//        addDropShadow()
//
//        contentView.sizeToFit()
//        contentView.addSubview(imageView)
//        contentView.addSubview(title)
//        contentView.addSubview(subTitle)
//        contentView.backgroundColor = .systemBackground
//        addConstraint()
//    }
//
//    private func addConstraint(){
//
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//
//        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        contentView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        contentView.widthAnchor.constraint(equalToConstant: Dimensions.SCREENSIZE.width - 25).isActive = true
//
////        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleTopMargin]
//
//        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
//        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
//
//        title.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10).isActive = true
//        title.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10).isActive = true
//        title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
//
//        subTitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5).isActive = true
//        subTitle.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10).isActive = true
//        subTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
//
//    }
//}
