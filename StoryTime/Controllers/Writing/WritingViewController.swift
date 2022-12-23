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
    

    init(promptDto: PromptDTO){
        
        super.init(nibName: nil, bundle: nil)
        
        viewModel.currentPrompt = promptDto

        if let promp = viewModel.currentPrompt, let outputExist = promp.outputText {
            
            //MARK: TODO - trigger flag to Show the detail view of already existing prompts
            viewModel.outputText.value = outputExist
        }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkService.shared.delegate = self
    }

    
    private func initialViewSetup(){
        
        view = (coordinator as? MainCoordinator)?.wrapScrollView(writingView)
        
        addBarButtonItems()
        
        if let promp = viewModel.currentPrompt {
            viewModel.promptText.value = promp.prompt
        }
       
        writingView.outputField.delegate = self
        writingView.promptField.delegate = self
        
//        viewModel.options.value = selectedOptions
    }
    
    
    private func setUpBinders() {
        
        viewModel.promptText.bind { [weak self] text in
            DispatchQueue.main.async{ [weak self] in
                self?.writingView.promptField.text = text
            }
        }
        
        
//        viewModel.options.bind {  opts in
//            print("Handle options change")
//        }
        
        
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
                strongSelf.writingView.outputField.setTyping(text: out)
                strongSelf.writingView.setWordCount(out.count)
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
            let mCoordinator = (coordinator as? MainCoordinator)
            mCoordinator?.navigationController?.startActivityIndicator()
            viewModel.triggerPrompt(text)
        }
    }
    
    @objc func saveOutput(){
        let uid = FirebaseService.shared.getUID()
        
        if let promptId = viewModel.currentPrompt?.id {
            
            FirebaseService.shared.getById(.promptOuput, id: promptId, completion: { [weak self] (documentSnapShot, error) in
                
                guard error == nil, let docSnapShot = documentSnapShot, let strongSelf = self else {
                    return
                }
                
                if let prompt = Prompt(snapShot: docSnapShot){
                    
                    if prompt.prompt == strongSelf.viewModel.currentPrompt?.prompt
                        && prompt.userId == uid
                        && prompt.output == strongSelf.viewModel.currentPrompt?.promptOutput {
                        
                        //show Error, No Change to FIle
                        strongSelf.showAlert(.error, (title: "", message: "File already saved"))
                        
                    }else{
                        strongSelf.viewModel.updatePromptOuput(uid, prompt: strongSelf.viewModel.currentPrompt)
                    }
                }
            })
            
        } else {
            
            viewModel.savePromptOutput(uid, prompt: viewModel.currentPrompt)
        }
    }
    
    @objc func shareOutput(){
        guard let shareText = viewModel.outputText.value else { return }
        showShareSheet(text: shareText)
    }
    
    @objc func speak(){
        print("speak")
    }
    
    @objc func options(){
        print("options")
    }
}


extension WritingViewController: NetworkServiceDelegate  {
    func success(_ network: NetworkService, output: PromptOutputDTO) {
        DispatchQueue.main.async { [weak self] in
            let mCoordinator = (self?.coordinator as? MainCoordinator)
            mCoordinator?.navigationController?.stopActivityIndicator()
            
            // Update TextView to display output
            self?.viewModel.outputText.value = output.choices.first?.text
            
            //Capture output incase it changes
            self?.viewModel.currentPrompt?.promptOutput = output
            self?.viewModel.currentPrompt?.outputText = output.choices.first?.text
        }
    }
    
    func failure(error: Error?) {
        viewModel.errorText.value = error?.localizedDescription
    }
}


extension WritingViewController: UITextViewDelegate, UITextFieldDelegate  {

    func textViewDidChange(_ textView: UITextView) {
        let wordCount = textView.text.count
        writingView.setWordCount(wordCount)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let wordCount = textView.text.count
        writingView.setWordCount(wordCount)
        
        viewModel.currentPrompt?.outputText = textView.text
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel.currentPrompt?.prompt = textField.text
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
