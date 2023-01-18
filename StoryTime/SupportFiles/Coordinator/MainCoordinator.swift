//
//  MainCoordinator.swift
//  Common
//
//  Created by Chuck on 24/11/2022.
//

import Foundation
import UIKit

typealias CoordinatingDelegate = UIViewController & Coordinating

class MainCoordinator: Coordinator {
    
    var children: [Coordinating]?
    
    var navigationController: MyNavigationController?
    
    var currentChild: CoordinatingDelegate!

    init(viewName: String) {
        switch(viewName) {
            
        case VCNames.HOME:
            currentChild = HomeViewController()
            children = [currentChild]
            self.navigationController = MyNavigationController(rootViewController: currentChild)
            break
//        case VCNames.ACCOUNT:
//            currentChild = AccountViewController()
//            children = [currentChild]
//            self.navigationController = MyNavigationController(rootViewController: currentChild)
//            break
        case VCNames.SETTINGS:
            currentChild = SettingsViewController()
            children = [currentChild]
            self.navigationController = MyNavigationController(rootViewController: currentChild)
            break
        default:break
        }
        
        currentChild?.coordinator = self
    }
    
    init(navigationController: MyNavigationController) {
        self.navigationController = navigationController
    }
    
    //MARK: Fix for IQKeyboardmanager jumping in View Controller
    func wrapScrollView(_ view: UIView) -> UIScrollView {
        
        let y = navigationController?.navigationBar.frame.height ?? 0
        
        let scrollView: UIScrollView = UIScrollView(frame: CGRect(x: 0, y: y , width: Dimensions.SCREENSIZE.width, height: Dimensions.SCREENSIZE.height))
        
        scrollView.backgroundColor = .systemBackground
        
        scrollView.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        view.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        
        return scrollView
    }
    
    //MARK: Helper funcs
    func toggleNavDisplay(hidden: Bool){
        navigationController?.navigationBar.isHidden = hidden
    }

    // MARK: Presentation Functions (Prsent, Push, Pop)
    func present(_ currentVC: CoordinatingDelegate, _ nextVC: CoordinatingDelegate, wrapNav: Bool = false, presentation: UIModalPresentationStyle = .automatic) {
        
        let index = children?.firstIndex(where: { child in
            if let castedChild = child as? CoordinatingDelegate{
                return castedChild.isEqual(currentVC)
            }
            
            return false
        })
        
        if let i = index{
            children?.remove(at: i)
            children?.append(currentVC)
        }else{
            children?.append(currentVC)
        }
            
        currentChild = currentVC
        currentChild?.coordinator = self
        
        var newVc = nextVC
        newVc.coordinator = self
        newVc.modalPresentationStyle = presentation
        
        if wrapNav {
            let navWrappedVC = UINavigationController(rootViewController: newVc)
            currentVC.present(navWrappedVC, animated: true, completion: nil)
            return
        }
        
        currentVC.present(newVc, animated: true, completion: nil)
    }
    
    func push(_ viewController: CoordinatingDelegate) {
        navigationController?.pushViewController(viewController, animated: true)
        
        currentChild = viewController
        children?.append(viewController)
        
        currentChild.coordinator = self
    }
    
    func pop(toRoot: Bool = false) {
        if (toRoot == true){
            navigationController?.popToRootViewController(animated: true)
            return
        }
        navigationController?.popViewController(animated: true)
        
        currentChild = navigationController?.viewControllers.first as? CoordinatingDelegate
        children = navigationController?.viewControllers as? [CoordinatingDelegate]
    }
    
    func setRoot(_ vc: UIViewController){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        appDelegate?.setRootViewController(vc, animated: true)
    }
}
