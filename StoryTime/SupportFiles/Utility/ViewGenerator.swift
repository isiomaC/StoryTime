//
//  ViewGenerator.swift
//  StoryTime
//
//  Created by Chuck on 24/11/2022.
//


import Foundation
import UIKit

class ViewGenerator {
    static func getSimpleImageButton(image: UIImage, bgColor: UIColor = .clear, tintColor: UIColor = MyColors.primary) -> UIButton{
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 10
        btn.clipsToBounds = true
        btn.tintColor = tintColor
        btn.setImage(image, for: .normal)
        btn.backgroundColor = bgColor
        return btn
    }
    
    static func getGradientButton(_ props: ButtonOptions) -> GradientButton{
        
        var btn: GradientButton?
        
        if let img = props.image {
            
            btn = GradientButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            btn?.translatesAutoresizingMaskIntoConstraints = false
            btn?.setImage(img, for: .normal)
            btn?.tintColor = props.color
        } else {
            btn = GradientButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            btn?.translatesAutoresizingMaskIntoConstraints = false
            btn?.setTitle(props.title, for: .normal)
            btn?.setTitleColor(props.titleColor, for: .normal)
        }
        
        btn?.sizeToFit()
        
        return btn!
        
    }
    
    static func getButton(_ props: ButtonOptions, circular: Bool = false, bordered: Bool = true) -> UIButton {
        
        if circular {
            var btn: UIButton?
            if let img = props.image {
                btn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                btn?.translatesAutoresizingMaskIntoConstraints = false
                btn?.setImage(img, for: .normal)
                btn?.tintColor = props.color
            } else {
                btn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                btn?.translatesAutoresizingMaskIntoConstraints = false
                btn?.setTitle(props.smiley, for: .normal)
                btn?.backgroundColor = .white
                btn?.layer.cornerRadius = (btn?.frame.height)!/2
            }
            return btn!
        } else {
            let btn = UIButton(frame: CGRect(x: 0, y: 0, width: Dimensions.SCREENSIZE.width, height: 44))
            btn.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 30.0, bottom: 10.0, right: 30.0)
            
            btn.translatesAutoresizingMaskIntoConstraints = false
//            btn.backgroundColor = .systemBackground
//            btn.setImage(UIImage(systemName: "search"), for: .normal)
            btn.setImage(props.image,
                    for: .normal)
            
            btn.setTitle(props.title, for: .normal)
            btn.setTitleColor(props.titleColor, for: .normal)
            
            btn.backgroundColor = props.color
            
            btn.titleLabel?.font = props.font
            
            if bordered == true{
                btn.layer.cornerRadius = props.radius
                btn.layer.borderWidth = props.borderWidth
                btn.layer.borderColor = props.color.cgColor
            }
            
            btn.sizeToFit()
            return btn
        }
    }
    
    static func styledImageView(withProps props: ImageViewOptions) -> UIImageView{
    
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: Dimensions.SCREENSIZE.width, height: Dimensions.halfScreenHeight))
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = props.image
        return imgView
    }

    static func styledLabled( withProps props : LabelOptions) -> UILabel{
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: Dimensions.SCREENSIZE.width, height: 44))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = props.color
        label.font = props.fontStyle  ?? AppFonts.body
        label.text =  props.text  //C.appName
        return label
    }
    
    static func circularButton(image : UIImage?, smiley: String?) -> UIButton{
       
        var btn : UIButton?
        if let img = image {
            btn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            btn?.translatesAutoresizingMaskIntoConstraints = false
            btn?.setImage(img, for: .normal)
        }else{
            btn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            btn?.translatesAutoresizingMaskIntoConstraints = false
            btn?.setTitle(smiley, for: .normal)
            btn?.backgroundColor = .systemGray6
            
//            btn?.layer.cornerRadius = (btn?.frame.height)!/2
        }
        
        
        
//        btn.imageView?.layer.cornerRadius = btn.bounds.height/2
        
        return btn!
    }
    
    static func getTextField(_ props: TextFieldOptions, copyPaste: Bool = true) -> UITextField {
        if copyPaste {
            let field = UITextField(frame: CGRect(x: 0, y: 0, width: Dimensions.SCREENSIZE.width, height: 44))
            field.translatesAutoresizingMaskIntoConstraints = false
            field.textAlignment = props.alignment
            field.textColor = props.textColor
            field.backgroundColor = props.backgroundColor
            field.tintColor = .green
            field.keyboardType = props.keyboardType
    //        field.placeholder = props.placeholder
            field.isSecureTextEntry = props.secured
            field.attributedPlaceholder = NSAttributedString(string: props.placeholder,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            field.layer.cornerRadius = 15
            field.font = props.fontStyle
            return field
            
        } else {
            
            let field = TextFieldPasteDisabled(frame: CGRect(x: 0, y: 0, width: Dimensions.SCREENSIZE.width, height: 44))
            field.translatesAutoresizingMaskIntoConstraints = false
            field.textAlignment = props.alignment
            field.textColor = props.textColor
            field.backgroundColor = props.backgroundColor
            field.tintColor = .green
            field.autocorrectionType = .no
            field.keyboardType = props.keyboardType
            field.isSecureTextEntry = props.secured
            field.attributedPlaceholder = NSAttributedString(string: props.placeholder,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            field.layer.cornerRadius = 15
            field.font = props.fontStyle
            return field
        }
    }
    
    static func getLabel(_ props: LabelOptions, _ insets: LabelInsets = LabelInsets(3, 3, 8, 8)) -> UILabel {
        
        let label = PaddedLabel(insets.topInset, insets.bottomInset, insets.leftInset, insets.rightInset)
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: Dimensions.screenSize.width, height: 44))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = props.color
        label.font = props.fontStyle // Font(type: .custom("HelveticaNeue-Medium"), size: .custom(45)).instance
        label.text =  props.text  // C.appName
        
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        return label
    }
    
    static func getRoundedImageView(_ props: ImageViewOptions) -> UIImageView {
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: props.size!.width, height: props.size!.height))
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.cornerRadius = imgView.frame.size.height/2
        imgView.layer.masksToBounds = false
        imgView.clipsToBounds = true
        
        if let img = props.image {
            imgView.image = img
        } else {
            imgView.backgroundColor = .systemGray
        }
        return imgView
    }
    
    static func getImageView(_ props: ImageViewOptions) -> UIImageView {
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: props.size!.width, height: props.size!.height))
        imgView.translatesAutoresizingMaskIntoConstraints = false
        
//        imgView.layer.cornerRadius = imgView.frame.size.height/2
//        imgView.layer.masksToBounds = false
        
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        
        if let img = props.image {
            imgView.image = img
        } else {
            imgView.backgroundColor = .systemGray
        }
        return imgView
    }
    
    static func getSwitch() -> UISwitch {
        return UISwitch()
    }
    
    static func getTextView(_ props: TextViewOptions) -> UITextView {
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: Dimensions.SCREENSIZE.width, height: Dimensions.SCREENSIZE.height * 0.2))
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainer.maximumNumberOfLines = 20
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textColor = props.textColor
        textView.font = props.fontStyle
        textView.textAlignment = .natural
        textView.text = props.placeholder
        return textView
    }
}
