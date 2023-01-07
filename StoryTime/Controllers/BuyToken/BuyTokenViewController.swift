//
//  BuyTokenViewController.swift
//  StoryTime
//
//  Created by Chuck on 07/01/2023.
//

import Foundation
import Foundation
import UIKit

class BuyTokenViewController: BaseViewController {
    
    var buyTokenView = BuyTokenView()
    
    //MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = buyTokenView
        
    }
    
}
