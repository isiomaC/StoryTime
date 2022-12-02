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
    
    private lazy var viewModel = WritingViewModel()
    
    var selectedOptions: [String: Any] = [:]
    
    init(options: [String: Any]){
        selectedOptions = options
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialViewSetup()
        
        setUpActions()
        
        setUpBinders()
    }

    
    private func initialViewSetup(){
        
        view = (coordinator as? MainCoordinator)?.wrapScrollView(writingView)
        
        addBarButtonItems()
        
        viewModel.promptText.value = selectedOptions["prompt"] as? String
        viewModel.options.value = selectedOptions
    }
    
    
    private func setUpBinders() {
        
        viewModel.promptText.bind { [weak self] text in
            DispatchQueue.main.async{ [weak self] in
                self?.writingView.promptField.text = text
            }
        }
        
        
        viewModel.options.bind {  opts in
            print("Handle options change")
        }
        
        
        viewModel.errorText.bind { [weak self] error in
            guard let strongSelf = self, let err = error else { return }
            
            DispatchQueue.main.async{
                strongSelf.showAlert(.error, (title: "Error", message: err))
            }
        }
        
        
        viewModel.outputText.bind{ [weak self] output in
            guard let out = output, let strongSelf = self else {
                return
            }
            DispatchQueue.main.async{
                strongSelf.writingView.outputField.text = out
                strongSelf.writingView.wordCount.text = "\(out.split(separator: " ").count) words"
            }
        }
    }
    
    private func setUpActions(){
        writingView.promptBtn.addTarget(self, action: #selector(triggerPrompt), for: .touchUpInside)
        
        writingView.saveBtn.addTarget(self, action: #selector(saveOutput), for: .touchUpInside)
        
        writingView.iconBtn.addTarget(self, action: #selector(shareOutput), for: .touchUpInside)
    }
}


//MARK: Objc functions
extension WritingViewController {
    
    @objc func triggerPrompt(){
        guard let text = writingView.promptField.text else {
            return
        }
        
        if !text.isReallyEmpty{
            viewModel.triggerPrompt(text)
        }
    }
    
    @objc func saveOutput(){
        viewModel.savePromptOutput()
    }
    
    @objc func shareOutput(){
        
    }
    
    @objc func speak(){
        print("speak")
    }
    
    @objc func options(){
        print("options")
    }
}


//MARK: Helpers
extension WritingViewController {
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
}
