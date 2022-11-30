//
//  ProfileViewController.swift
//  StoryTime
//
//  Created by Chuck on 23/11/2022.
//

import UIKit

class ProfileViewController: CoordinatingDelegate {
    var coordinator: Coordinator?
    
    var profileView = ProfileView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view = profileView
    }


}

