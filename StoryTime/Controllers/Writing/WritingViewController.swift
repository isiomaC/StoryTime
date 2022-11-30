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
    
    private lazy var viewModel: WritingViewModel = WritingViewModel(view: writingView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = writingView
        
        addBarButtonItems()
        
    }
    
    private func addBarButtonItems(){
        
        let item1 = UIBarButtonItem(image: UIImage(systemName: "speaker.wave.3.fill"), style: .plain, target: self, action: #selector(speak))
        
//        let item2 = UIBarButtonItem(image: UIImage(systemName: "square.stack.3d.up.fill"), style: .plain, target: self, action: #selector(options))
        
        let sampleAction = UIAction(title: "Sample", attributes: .disabled){ _ in }
        let uiMenu = UIMenu(title:"", children: [sampleAction, getMenu()])
        
        let item2 = UIBarButtonItem(title: nil, image: UIImage(systemName: "square.stack.3d.up.fill"), primaryAction: nil, menu: uiMenu)
        
        navigationItem.rightBarButtonItems = [item2, item1]
        
        let isDark = UIScreen.main.traitCollection.userInterfaceStyle == .dark ? true : false
        
        navigationController?.navigationBar.tintColor = isDark ? .white : .black
        
    }
    
    private func getMenu() -> UIMenu{
        
        let font = UIAction(title: "Font", image: UIImage(systemName: "pencil"), identifier: .none, discoverabilityTitle: nil, attributes: .init(), state: .off) {(action) in
            
            print("font")
        }
        
        let fontSize = UIAction(title: "Font size", image: UIImage(systemName: "trash"), identifier: .none, discoverabilityTitle: nil, attributes: .init(), state: .off) {  (action) in
            
            print("font size")
        }
        
        let children = [font, fontSize]
        
        let menu = UIMenu(title: "Text", image: UIImage(systemName: "square.stack.3d.up.fill"), identifier: .edit, options: .init(rawValue: 2), children: children)
        
        return menu
    }
    
    @objc func speak(){
        print("speak")
    }
    
    @objc func options(){
        print("options")
    }
}
