//
//  OnBoardingViewController.swift
//  StoryTime
//
//  Created by Chuck on 25/11/2022.
//

import Foundation
import UIKit

class OnBoardingViewController: UIViewController{
    
    var coordinator: Coordinator?
    
    let onBoardView = OnBoardView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = onBoardView
        view.backgroundColor = .systemBackground
        
        onBoardView.getStartedBtn.addTarget(self, action: #selector(getStarted), for: .touchUpInside)
        
    }
}

//MARK: ObjC functions
extension OnBoardingViewController {
    @objc func getStarted(){
        
        UserDefaults.standard.set(true, forKey: UserDefaultkeys.hasLaunched)
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        //MARK: TODO - Decide on where to go after on boarding..
        appDelegate?.setRootViewController(TabBarController())
    }

}
