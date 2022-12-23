//
//  BaseViewController.swift
//  StoryTime
//
//  Created by Chuck on 27/11/2022.
//

import Foundation
import UIKit

class BaseViewController: CoordinatingDelegate {
    
    var coordinator: Coordinator?
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    //MARK: Detect dark and light Mode Changes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            
            if traitCollection.userInterfaceStyle == .dark {
                navigationController?.navigationBar.tintColor = .white
            }else{
                navigationController?.navigationBar.tintColor = .black
            }
        }
    }
    
    func showShareSheet(text : String){
        let shareActivity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(shareActivity, animated: true, completion: nil)
    }
    
    
    
//    func startActivityIndicator(for InView: UICollectionView){
//        DispatchQueue.main.async { [weak self] in
//            
//            guard let strongSelf = self else { return }
//            
//            strongSelf.activityIndicator.color = MyColors.topGradient
//            strongSelf.activityIndicator.frame = InView.frame
//            strongSelf.activityIndicator.center = InView.center
//            strongSelf.activityIndicator.backgroundColor = UIColor.init(white: 1, alpha: 0.9)
//            strongSelf.activityIndicator.startAnimating()
//            strongSelf.activityIndicator.isOpaque = true
//            strongSelf.view.addSubview(strongSelf.activityIndicator)
//        }
//    }
//    
//    func startActivityIndicator(){
//        DispatchQueue.main.async { [weak self] in
//            
//            guard let strongSelf = self else { return }
//            
//            strongSelf.activityIndicator.backgroundColor = UIColor.init(white: 1, alpha: 0.5)
//            strongSelf.activityIndicator.color = MyColors.bottomGradient
//            strongSelf.activityIndicator.isOpaque = true
//            
//            strongSelf.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
//            strongSelf.activityIndicator.widthAnchor.constraint(equalToConstant: Dimensions.SCREENSIZE.width).isActive = true
//            strongSelf.activityIndicator.heightAnchor.constraint(equalToConstant: Dimensions.SCREENSIZE.height).isActive = true
//            
//            strongSelf.activityIndicator.startAnimating()
//            strongSelf.view.addSubview(strongSelf.activityIndicator)
//        }
//    }
//    
//    func stopActivityIndicator(){
//        DispatchQueue.main.async { [weak self] in
//            guard let strongSelf = self else { return}
//            strongSelf.activityIndicator.stopAnimating()
//            strongSelf.activityIndicator.removeFromSuperview()
//        }
//    }
}
