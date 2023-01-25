//
//  AccountViewController.swift
//  StoryTime
//
//  Created by Chuck on 23/11/2022.
//

import UIKit

class PasswordResetViewController: BaseViewController {
    
    var pwdResetView = PwdResetView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Reset Password"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view = (coordinator as? MainCoordinator)?.wrapScrollView(pwdResetView)
        
        addActions()
    }
    
    private func addActions(){
        pwdResetView.resetPwdBtn.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        
        pwdResetView.newPwd.rightView?.isUserInteractionEnabled = true
        pwdResetView.newPwd.rightView?.tag = 1
        pwdResetView.newPwd.rightView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(togglePwdHidden)))
        
        pwdResetView.newPwd2.rightView?.isUserInteractionEnabled = true
        pwdResetView.newPwd2.rightView?.tag = 2
        pwdResetView.newPwd2.rightView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(togglePwdHidden)))
    }
}

extension PasswordResetViewController{
    
    @objc func togglePwdHidden(sender: UITapGestureRecognizer){
                
        let tag = sender.view?.tag
        
        if tag == 1 {
            
            pwdResetView.newPwd.isSecureTextEntry.toggle()
            let imageName = pwdResetView.newPwd.isSecureTextEntry ? "eye.fill" : "eye.slash.fill"
            
            if let img = pwdResetView.newPwd.rightView as? UIImageView {
                img.image = UIImage(systemName: imageName)!
            }
           
            
        }else if tag == 2 {
            pwdResetView.newPwd2.isSecureTextEntry.toggle()
            let imageName = pwdResetView.newPwd2.isSecureTextEntry ? "eye.fill" : "eye.slash.fill"
           
            if let img = pwdResetView.newPwd2.rightView as? UIImageView {
                img.image = UIImage(systemName: imageName)!
            }
        }

    }
    
    @objc func resetPassword(){
        
        guard let newPwd = pwdResetView.newPwd.text,
               let newPwd2 = pwdResetView.newPwd2.text else { return }
        
        startActivityIndicator()
        if newPwd.isEmpty || newPwd2.isEmpty  {
            
            showAlert(.error, (title: "Error", message: "Please include all fields"))
            
        }else{
            
            if newPwd == newPwd2 {
                FirebaseService.shared.updatePasssword(password: newPwd) { error in
                    guard error == nil else {
                        return
                    }
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.stopActivityIndicator()
                        self?.logOut()
                    }
                }
            }else {
                showAlert(.error, (title: "Error", message: "New password doesn't match"))
            }
        }
    }
    
    func logOut(){
        do {
            try FirebaseService.shared.auth?.signOut()
            
            UserDefaults.standard.setValue(false, forKey: UserDefaultkeys.isAuthenticated)
  
            dismiss(animated: true) { [weak self] in
                (self?.coordinator as? MainCoordinator)?.setRoot(LoginViewController())
            }
            
        } catch let signOutError as NSError {
            showAlert(.error, (title: "Error", message: signOutError.localizedDescription))
        }
    }
}
