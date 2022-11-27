//
//  WritingViewController.swift
//  StoryTime
//
//  Created by Chuck on 27/11/2022.
//

import Foundation
import UIKit

class WritingViewController: BaseViewController{

    var writingView = WritingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        addBarButtonItems()
        view = writingView
    }
    
    private func addBarButtonItems(){
        
        let item1 = UIBarButtonItem(image: UIImage(systemName: "speaker.wave.3.fill"), style: .plain, target: self, action: #selector(speak))
        let item2 = UIBarButtonItem(image: UIImage(systemName: "square.stack.3d.up.fill"), style: .plain, target: self, action: #selector(options))
        navigationItem.rightBarButtonItems = [item2, item1]
        
        let isDark = UIScreen.main.traitCollection.userInterfaceStyle == .dark ? true : false
        
        navigationController?.navigationBar.tintColor = isDark ? .white : .black
        
    }
    
    @objc func speak(){
        print("speak")
    }
    
    @objc func options(){
        print("options")
    }
}
