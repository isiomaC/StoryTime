//
//  LoginViewController.swift
//  StoryTime
//
//  Created by Chuck on 27/11/2022.
//

import Foundation
import UIKit
import GoogleSignIn
import FirebaseCore
import FirebaseAuth

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
                        self?.stopActivityIndicator()
                        self?.dismiss(animated: true)
                        let appDelegate = UIApplication.shared.delegate as? AppDelegate
                        appDelegate?.setRootViewController(TabBarController())
                    }
                }
            }
        }
    }
    
    
    func prepareGoogleAuth(completion: @escaping (GIDToken?, GIDToken?) -> Void){
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] gidResult, error in
            guard error == nil, let result = gidResult else {
                self?.stopActivityIndicator()
                
                if error?.localizedDescription != "The user canceled the sign-in flow." {
                    self?.showAlert(.error, (title: "Error", message: "Something went wrong"))
                }
                
                return
            }
            
            let accessToken = result.user.accessToken
            let idToken = result.user.idToken
            
            completion(accessToken, idToken)
        }
    }
    
    
    @objc func authenticateWithGoogle(){

        DispatchQueue.main.async { [weak self] in
            self?.startActivityIndicator()
            self?.prepareGoogleAuth { accessToken, idToken in
                guard let acsToken = accessToken, let identityToken = idToken else {
                    self?.stopActivityIndicator()
                    self?.showAlert(.error, (title: "Error", message: "Something went wrong"))
                    return
                }
                
                let credential = GoogleAuthProvider.credential(withIDToken: identityToken.tokenString, accessToken: acsToken.tokenString)
                
                FirebaseService.shared.auth?.signIn(with: credential){ authResult, error in
                    guard error == nil, let result = authResult else {
                        self?.stopActivityIndicator()
                        self?.showAlert(.error, (title: "Error", message: "Something went wrong"))
                        return
                    }
                    
                    FirebaseService.shared.getDocuments(.user, query: ["guid": result.user.uid]) { snapShot, error in
                        
                        guard error == nil, let documentSnapShot = snapShot, let email = result.user.email else {
                            self?.stopActivityIndicator()
                            self?.showAlert(.error, (title: "Error", message: "Something went wrong"))
                            return
                        }
                        
                        if documentSnapShot.count > 0 {
                            
                            self?.stopActivityIndicator()
                            self?.dismiss(animated: true){
                                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                                appDelegate?.setRootViewController(TabBarController())
                            }
                           
                        }else {
                            
                            // MARK: Brand New User
                            var userDto = User(id: "", email: email, guid: result.user.uid, timestamp: Date())
                            
                            guard let userSaveDto = userDto.removeKey() else {
                                self?.stopActivityIndicator()
                                self?.showAlert(.error, (title: "Error", message: "Something went wrong, Please try again"))
                                return
                            }
                            
                            FirebaseService.shared.saveDocument(.user, data: userSaveDto) { (usersRef, error) in
                                
                                guard let ref = usersRef else {
                                    self?.stopActivityIndicator()
                                    self?.showAlert(.error, (title: "Error", message: "Something went wrong, Please try again"))
                                    return
                                }
                                
                                userDto.id = ref.documentID
                                
                                TokenManager.shared.initializeFirstUserToken {
                                    self?.stopActivityIndicator()
                                    self?.dismiss(animated: true){
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
    
    
    @objc func goToSignUp(){
        let nextVC = SignUpViewController()
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true)
    }
}
