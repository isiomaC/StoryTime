//
//  AccountViewController.swift
//  StoryTime
//
//  Created by Chuck on 23/11/2022.
//

import UIKit

class AccountViewController: CoordinatingDelegate {
    var coordinator: Coordinator?
    
    var accountView = AccountView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Account"
        
        view = accountView
        
        view.backgroundColor = .systemBackground
    }
}

