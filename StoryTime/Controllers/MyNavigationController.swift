//
//  MyNavigationController.swift
//  StoryTime
//
//  Created by Chuck on 27/11/2022.
//

import Foundation
import UIKit

class MyNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    func startActivityIndicator(){

        DispatchQueue.main.async { [weak self] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.activityIndicator.backgroundColor = UIColor.init(white: 1, alpha: 0.9)
            strongSelf.activityIndicator.color = MyColors.bottomGradient
            strongSelf.activityIndicator.isOpaque = true
            
            strongSelf.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            strongSelf.activityIndicator.widthAnchor.constraint(equalToConstant: Dimensions.SCREENSIZE.width).isActive = true
            strongSelf.activityIndicator.heightAnchor.constraint(equalToConstant: Dimensions.SCREENSIZE.height).isActive = true
            
            strongSelf.activityIndicator.startAnimating()
            strongSelf.view.addSubview(strongSelf.activityIndicator)
        }
    }
    
    func stopActivityIndicator(){
        DispatchQueue.main.async { [weak self] in
            
            guard let strongSelf = self else { return }
            strongSelf.activityIndicator.stopAnimating()
            strongSelf.activityIndicator.removeFromSuperview()
        }
    }
}
