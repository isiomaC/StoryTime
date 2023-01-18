//
//  SettingsViewController.swift
//  StoryTime
//
//  Created by Chuck on 27/11/2022.
//

import Foundation
import UIKit
import FirebaseAuth

class SettingsViewController: CoordinatingDelegate{
    var coordinator: Coordinator?
    
    let settingView = SettingView()
    
    var tableView: UITableView?
    
    let cellIdentifier = "settingsCell"
    
    let (settingsOptions, accountOptions, infoOptions, logOutOptions, deleteOptions) = SettingsOptsDTO.options()
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        title = "Settings"
        
        navigationItem.backBarButtonItem?.title = ""
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        initTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateTableCell(indexPath: IndexPath(item: 0, section: 0))
    }
    
    private func updateTableCell(indexPath: IndexPath) {
        guard let table = tableView else { return }
        if table.isDescendant(of: view) {
            UIView.animate(withDuration: 0.5, delay: 0) { [weak self] in
                self?.tableView?.reloadSections(IndexSet(integer: 0), with: .fade)
            }
        }
    }
}

//MARK: Objc func
extension SettingsViewController {
    
    //MARK: Will remove to another place
    @objc func logOut(){
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


//MARK: table View
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    private func initTableView() {
        let frame = CGRect(x: 0, y: 0,
                           width: Dimensions.SCREENSIZE.width, height: Dimensions.SCREENSIZE.height)
        
        tableView = UITableView(frame: frame, style: .insetGrouped)
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
//        tableView?.backgroundColor = .systemBackground
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        if let table = tableView {
            view.addSubview(table)
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsOptsDTO.sections.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SettingsOptsDTO.sections[section]
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return settingsOptions.count
        } else if section == 1 {
            return accountOptions.count
        } else if section == 2 {
            return infoOptions.count
        } else if section == 3 {
            return logOutOptions.count
        }
        
        return deleteOptions.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //settings
        if indexPath.section == 0 {

//            let option = settingsOptions[indexPath.row]
//
//            switch option.name {
//            case SettingsConstants.tokens:
//                    print("tokens")
//                    break
//            default : break;
//            }
            
        }else if indexPath.section == 1 {
            
            let option = accountOptions[indexPath.row]
            
            switch option.name {
           
            case SettingsConstants.changePwd:
                
                var emailField = UITextField()
                var pwdField = UITextField()
                
                let credentialPopUp = UIAlertController(title: "Enter Credentials", message: "", preferredStyle: .alert)
                
                credentialPopUp.addTextField(configurationHandler: { (field) in
                    field.placeholder = "Enter email"
                    emailField = field
                })
                
                credentialPopUp.addTextField(configurationHandler: { (field) in
                    field.placeholder = "Enter password"
                    pwdField = field
                })
                
                let nextAction = UIAlertAction(title: "Next", style: .default){ action in
                    
                    guard let email = emailField.text, let password = pwdField.text else {
                        return
                    }
                            
                    FirebaseService.shared.reAuthenticate(creds: (email, password)) { [weak self] error in
                        guard error == nil else {
                            self?.showAlert(.error, (title: "Invalid Credentials", message: ""))
                            return
                        }
                        
                        DispatchQueue.main.async { [weak self] in
                            if let strongSelf = self {
                                
                                (strongSelf.coordinator as? MainCoordinator)?.present(strongSelf, PasswordResetViewController(), wrapNav: true)
                            }
                        }
                    }
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
                    credentialPopUp.dismiss(animated: true, completion: nil)
                }
                
                credentialPopUp.addAction(nextAction)
                credentialPopUp.addAction(cancelAction)
                present(credentialPopUp, animated: true, completion: nil)
                
                break
                
            default : break;
            }
            
        }else if indexPath.section == 2 {
            let option = infoOptions[indexPath.row]
            
            switch option.name {
                case SettingsConstants.shareWithFriend:
                    Utils.shareExternal(controller: self, itemToShare: Utils.appStoreUrl as AnyObject)
                    break;
                
                case SettingsConstants.rateUs:
                    Utils.rateApp()
                    break;
                
                case SettingsConstants.privacyPolicy:
                    // TODO: Implement Privacy Policy link here
                    Utils.showSafariLink(self, pageRoute: Utils.privacyPolicyUrl)
                    break;
                
                case SettingsConstants.termsUse:
                    Utils.showSafariLink(self, pageRoute: Utils.termsAppleEula)
                    break;
                
                default : break;
            }
        }else if indexPath.section == 3 {
            let option = logOutOptions[indexPath.row]
            
            if option.name == SettingsConstants.logOut{
                logOut()
            }
        }else if indexPath.section == 4 {
            
            let option = deleteOptions[indexPath.row]
            
            if option.name == SettingsConstants.deleteAccount{
              
                // TODO: Implement Delete Account feature
                print("destructive delete")
            }
        }
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        var item: SettingsOptsDTO?
        
        cell.backgroundColor = MyColors.topGradient
        
        let iconColor: UIColor = .label
        
        cell.selectionStyle = .none
        
        if indexPath.section == 0 {
            
            item = settingsOptions[indexPath.row]
            
            guard let mItem = item else {
                return UITableViewCell()
            }
            
            var content = cell.defaultContentConfiguration()
            cell.tintColor = iconColor
            content.text = mItem.name
//            content.image = mItem.image
          
            cell.contentConfiguration = content

            if indexPath.row == 0 { // Tokens
                
                lazy var mLayoutLabelView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.width * 0.7, height: 100))
                lazy var mLabel = UILabel(frame: CGRect(x: 0, y: 0, width: cell.frame.width * 0.7, height: 100))
                mLabel.textAlignment = .right
                mLayoutLabelView.addSubview(mLabel)
                
                if let amount = TokenManager.shared.userToken?.amount{
                    mLabel.text = String(amount)
                }else{
                    mLabel.text = "0"
                }
               
                
                cell.accessoryView = mLayoutLabelView
            }

        } else if indexPath.section == 1 {
            
            item = accountOptions[indexPath.row]
            
            guard let mItem = item else {
                return UITableViewCell()
            }
            
            var content = cell.defaultContentConfiguration()
            cell.tintColor = iconColor
            content.text = mItem.name
//            content.image = mItem.image
          
            cell.contentConfiguration = content
            
            if indexPath.row == 0 { // Tokens
                
                lazy var mLayoutLabelView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.width * 0.7, height: 100))
                lazy var mLabel = UILabel(frame: CGRect(x: 0, y: 0, width: cell.frame.width * 0.7, height: 100))
                
                mLayoutLabelView.addSubview(mLabel)
                mLabel.textAlignment = .right
                
                let email = FirebaseService.shared.getUserEmail()
                
                if !email.isReallyEmpty {
                    mLabel.text = String(email)
                }else{
                    mLabel.text = ""
                }
                
                cell.accessoryView = mLayoutLabelView
            }else{
                cell.accessoryType = .detailDisclosureButton //.detailButton
            }
            
            
        } else if indexPath.section == 2 {
            
            item = infoOptions[indexPath.row]
            
            guard let mItem = item else {
                return UITableViewCell()
            }

            cell.textLabel?.text = mItem.name
            
            cell.imageView?.tintColor = iconColor
            
//            cell.imageView?.image = mItem.image

            cell.accessoryType = mItem.accessoryType

        } else {
            item = indexPath.section == 4 ? deleteOptions[indexPath.row] : logOutOptions[indexPath.row]
            
            guard let mItem = item else {
                return UITableViewCell()
            }
            var content = cell.defaultContentConfiguration()
            cell.tintColor = indexPath.section == 4 ? .systemRed : iconColor
            content.text = mItem.name
//            content.image = mItem.image
            
            if indexPath.section == 4{
                content.textProperties.color = .systemRed
            }
          
            cell.contentConfiguration = content
            
        }
        return cell
            
    }
    
}
