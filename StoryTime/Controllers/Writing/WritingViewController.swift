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
    
    var userToken = TokenManager.shared.userToken
    
    init(promptDto: PromptDTO){
        
        super.init(nibName: nil, bundle: nil)
        
        viewModel.currentPrompt = promptDto

        if let promp = viewModel.currentPrompt, let outputExist = promp.outputText {
            
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
        
//        addBarButtonItems()
        
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
                strongSelf.writingView.setWordCount(out.split(separator: " ").count)
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
        
        guard let text = writingView.promptField.text,
            let token = userToken, let tkAmount = token.amount else {
            return
        }
        
        if tkAmount > text.split(separator: " ").count{
            
            if !text.isReallyEmpty{
                let mCoordinator = (coordinator as? MainCoordinator)
                mCoordinator?.navigationController?.startActivityIndicator()
                viewModel.triggerPrompt(text)
            }
        } else {
            
            let animationDuration = 0.3
            let showDuration: Double = 5
            
            writingView.showNotification(text: "out of tokens" ,showDuration, animationDuration)
        }
    }
    
    
    @objc func saveOutput(){
        
        guard let prompt = viewModel.currentPrompt else { return }
        
        let uid = FirebaseService.shared.getUID()
        writingView.activityIndicator.startAnimating()
        
        if prompt.id != nil {

            FirebaseService.shared.getById(.promptOuput, id: prompt.id!) { [ weak self] docSnapShot, error in
                guard let snapShot = docSnapShot,
                      let existingPrompt = Prompt(snapShot: snapShot),
                      error == nil else {
                    self?.writingView.activityIndicator.stopAnimating()
                    self?.showAlert(.error, (title: "", message: "Something went wrong"))
                    return
                }
                
                if prompt.prompt == existingPrompt.prompt
                    && prompt.outputText == existingPrompt.output.choices.first?.text {
                    
                    self?.writingView.activityIndicator.stopAnimating()
                    self?.showAlert(.error, (title: "", message: "Prompt already saved"))
                }else{
                    
                    let userId = FirebaseService.shared.getUID()
                    
                    guard let newPromptText = prompt.prompt, let ouput = prompt.promptOutput else {
                        self?.writingView.activityIndicator.stopAnimating()
                        self?.showAlert(.error, (title: "", message: "Something went wrong"))
                        return
                    }
                    
                    let updPrompt = Prompt(id: prompt.id!, prompt: newPromptText, userId: userId, output: ouput)
                    
                    if let promptToUpdate = updPrompt.removeKey() {
                        snapShot.reference.updateData(promptToUpdate)
                    }
                   
                    DispatchQueue.main.async { [weak self] in
                        self?.writingView.activityIndicator.stopAnimating()
                        let animationDuration = 0.3
                        let showDuration: Double = 3
                        self?.writingView.showNotification(text: "prompt updated" ,showDuration, animationDuration)
                    }
                }
            }
            
        } else {
            
            viewModel.savePromptOutput(uid, prompt: viewModel.currentPrompt){ [weak self] error in
                
                guard error == nil else {
                    self?.writingView.activityIndicator.stopAnimating()
                    self?.showAlert(.error, (title: "", message: "Something went wrong"))
                    return
                }
                
                DispatchQueue.main.async {
                    self?.writingView.activityIndicator.stopAnimating()
                    let animationDuration = 0.3
                    let showDuration: Double = 3
                    self?.writingView.showNotification(text: "prompt saved" ,showDuration, animationDuration)
                }
            }
            
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
        
        guard let token = userToken else {
            return
        }
        
        TokenManager.shared.updateTokenUsage(usageTotal: output.usage.total_tokens, token: token) { result in
            switch result{
            case .success(_):

                DispatchQueue.main.async { [weak self] in
                    let mCoordinator = (self?.coordinator as? MainCoordinator)
                    mCoordinator?.navigationController?.stopActivityIndicator()
                    
                    guard var firstChoice = output.choices.first else {
                        return
                    }
                    
                    var myOutput = output
                    
                    firstChoice.text = firstChoice.text.trim()
                    
                    myOutput.choices = [firstChoice]
                    
                    // Update TextView to display output
                    self?.viewModel.outputText.value = firstChoice.text
                    
                    //Capture output incase it changes
                    self?.viewModel.currentPrompt?.promptOutput = myOutput
                    self?.viewModel.currentPrompt?.outputText = firstChoice.text

                }
                break
            case .failure(_):
                print("Error updating token")
                break
            }
        }
    }
    
    func failure(error: Error?) {
        viewModel.errorText.value = error?.localizedDescription
    }
}


extension WritingViewController: UITextViewDelegate, UITextFieldDelegate  {

    func textViewDidChange(_ textView: UITextView) {
        let wordCount = textView.text.split(separator: " ").count
        writingView.setWordCount(wordCount)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let wordCount = textView.text.split(separator: " ").count
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
