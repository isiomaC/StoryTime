//
//  LoginViewController.swift
//  StoryTime
//
//  Created by Chuck on 27/11/2022.
//

import Foundation
import UIKit

class LoginViewController: BaseViewController {
    
    var loginView = LoginView()
    
    //MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = loginView
        
        setUpActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
        view.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
        navigationController?.navigationBar.isHidden = false
        
        UIView.transition(with: view,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: { [weak self]_ in
            guard let strongSelf = self else { return }
            strongSelf.view.isHidden = true
        })
      
    }
    
    private func setUpActions(){
        loginView.loginBtn.addTarget(self, action: #selector(authenticate), for: .touchUpInside)
        
        loginView.createAcctBn.addTarget(self, action: #selector(goToSignUp), for: .touchUpInside)
        
        loginView.googleBtn.addTarget(self, action: #selector(authenticateWithGoogle), for: .touchUpInside)
    }
    
    private func handleAuthError(_ error: NSError){
        switch(error.code){
        case FIREBASENOINTERNETCODE:
            showAlert(.error, (title: "Offline", message: "No internet connection"))
            break
            
//        case AUTHUNREGISTEREDEMAIL, AUTHINVALIDPWD, AUTHBADEMAILFORMAT:
//            showAlert(.error, (title: "Error", message: "Email or Password is invalid"))
//            break
//
            
        default:
            showAlert(.error, (title: "Error", message: "Email or Password is invalid"))
            break
        }
    }
}

extension LoginViewController{

    @objc func authenticate(){
        
        guard let email = loginView.emailField.text,
               let password = loginView.pwdField.text else { return }
        
        if email.isEmpty || password.isEmpty {
            showAlert(.error, (title: "Error", message: "Please include valid email or password"))
        }else{
            startActivityIndicator()
            FirebaseService.shared.auth?.signIn(withEmail: email.trim(), password: password) {[weak self] (data, error) in
                
                if let err = error as? NSError {
                    
                    self?.handleAuthError(err)
                   
                } else {
                    
                    UserDefaults.standard.setValue(true, forKey: UserDefaultkeys.isAuthenticated)
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.startActivityIndicator()
                        self?.dismiss(animated: true)
                        let appDelegate = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.setRootViewController(TabBarController())
                    }
                }
            }
        }
    }
    
    
    @objc func authenticateWithGoogle(){
        print("call google provider")
    }
    
    
    @objc func goToSignUp(){
        let nextVC = SignUpViewController()
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true)
    }
}
