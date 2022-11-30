//
//  SettingsViewController.swift
//  StoryTime
//
//  Created by Chuck on 27/11/2022.
//

import Foundation
import UIKit

class SettingsViewController: CoordinatingDelegate{
    var coordinator: Coordinator?
    
    let settingView = SettingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        view = settingView
        
        setUpActions()
    }
    
    private func setUpActions(){
        settingView.logOutBtn.addTarget(self, action: #selector(logOut), for: .touchUpInside)
    }
}

extension SettingsViewController {
    
    //MARK: Will remove to another place
    @objc func logOut(){
        do {
            try FirebaseService.shared.auth?.signOut()
            
            UserDefaults.standard.setValue(false, forKey: UserDefaultkeys.isAuthenticated)
            
    //        let LoginViewController = LoginVewController()
    //        LoginViewController.modalPresentationStyle = .fullScreen
    //        present(LoginViewController, animated: true, completion: nil)
            
            dismiss(animated: true) { [weak self] in
                (self?.coordinator as? MainCoordinator)?.setRoot(LoginViewController())
            }
            
        } catch let signOutError as NSError {
            showAlert(.error, (title: "Error", message: signOutError.localizedDescription))
        }
    }
    
}
