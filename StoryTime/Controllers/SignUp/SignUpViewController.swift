//
//  SignUpViewController.swift
//  StoryTime
//
//  Created by Chuck on 27/11/2022.
//

import Foundation
import UIKit
import FirebaseFirestore

class SignUpViewController: BaseViewController{
    
    let signUpView = SignUpView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = signUpView
        
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
        view.isHidden = true
    }
    
    
    private func setUpActions(){
        signUpView.loginBtn.addTarget(self, action: #selector(goToLogin), for: .touchUpInside)
        
        signUpView.signupBtn.addTarget(self, action: #selector(signUp), for: .touchUpInside)
    }
    
    private func handleAuthError(_ error: NSError){
        switch(error.code){
        case FIREBASENOINTERNETCODE:
            showAlert(.error, (title: "Offline", message: "No internet connection"))
            break
            
//        case AUTHUNREGISTEREDEMAIL, AUTHINVALIDPWD, AUTHBADEMAILFORMAT:
//            showAlert(.error, (title: "Error", message: "Email or Password is invalid"))
//            break
            
        default:
            showAlert(.error, (title: "Error", message: "Email or Password is invalid"))
            break
        }
    }
}


extension SignUpViewController {
    @objc func goToLogin(){
        dismiss(animated: true)
    }
    
    @objc func signUp(){
        
        guard let email = signUpView.emailField.text,
              let password = signUpView.pwdField.text,
              let password2 = signUpView.pwdField2.text else {
            return
        }
        
        if email == "" || password == "" || password2 == ""{
            showAlert(.error, (title: "Error", message: "Please include valid credentials"))
        }else{
            if (password == password2){
                startActivityIndicator()
                
                FirebaseService.shared.auth?.createUser(withEmail: email.trim(), password: password) { [weak self] (data, error) in
                    
                    guard let strongSelf = self, let userData = data else { return }
                    
                    if let err = error as? NSError{
                        
                        self?.handleAuthError(err)
                        
                    }else{
                        
                        UserDefaults.standard.setValue(true, forKey: UserDefaultkeys.isAuthenticated)
                        
                        var userDto = User(id: "",
                                              email: userData.user.email ?? email,
                                              guid: userData.user.uid,
                                              timestamp: Date())
                        
                        guard let userSaveDto = userDto.removeKey() else {
                            strongSelf.showAlert(.error, (title: "Error", message: "No internet connection"))
                            return
                        }
                        
                        FirebaseService.shared.saveDocument(.user, data: userSaveDto) { [weak self] (usersRef, error) in
                            guard let strongSelf = self, let ref = usersRef else { return }
                            
                            if let _ = error{
                                strongSelf.showAlert(.error, (title: "Error", message: "Something went wrong, Please try again"))
                            }else{
                                
                                userDto.id = ref.documentID
                                
                                TokenManager.shared.initializeFirstUserToken {
                                    DispatchQueue.main.async { [weak self] in
                                        self?.stopActivityIndicator()
                                        self?.dismiss(animated: true)
                                        let appDelegate = UIApplication.shared.delegate as? AppDelegate
                                        appDelegate?.setRootViewController(TabBarController())
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
