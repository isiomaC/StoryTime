//
//  ViewController.swift
//  StoryTime
//
//  Created by Chuck on 23/11/2022.
//

import UIKit

class HomeViewController: BaseViewController {
    
    var collectionView: UICollectionView!
    
    private lazy var viewModel = HomeViewModel(collectionView: collectionView)
    
    var homeView = HomeView()
    
    var newPrompt: PromptDTO?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = "Home"
        
        self.navigationItem.backBarButtonItem?.title = ""
        
        view = (coordinator as? MainCoordinator)?.wrapScrollView(homeView)
        
        setUpCollectionView()
        
        setUpActions()
        
        setUpBinders()
        
        viewModel.coordinator = coordinator
        
//        viewModel.add([PromptDTO(id: "tes2", prompt: "test String2 test String test String test String test String  test String test String", promptOutput: nil)])
        
//        fetchPrompts()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkService.shared.delegate = self
        
        if let userTokenDto = TokenManager.shared.userToken{
            viewModel.userToken.value = userTokenDto
        }else{
            viewModel.fetchToken { [weak self] token, error in
                guard error == nil, let tk = token else {
                    return
                }
                TokenManager.shared.userToken = tk
                self?.viewModel.userToken.value = tk
            }
        }
        
        fetchPrompts()
    }
    
    private func setUpBinders(){
        viewModel.error.bind { [weak self] errorString in
            if let err = errorString {
                self?.showAlert(.error, (title: "Error", message: err ))
            }
        }
        
        viewModel.userToken.bind { tokenDto in
            if let tk = tokenDto {
                
                //MARK: Update Token View Icon amount
                print(tk)
            }
        }
    }
    
    private func fetchPrompts(){
        
        viewModel.fetchPrompts { [weak self] prompts, error in
            guard error == nil, let allPrompts = prompts else {
                self?.viewModel.error.value = error?.localizedDescription
                return
            }
            
            let allPromptDto = allPrompts.map { prompt in
                return prompt.toPrompDto()
            }
            
            self?.viewModel.remove(allPromptDto)
            self?.viewModel.add(allPromptDto)
            
        }
    }
    
    private func setUpActions(){
        
        homeView.nextBtn.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        
        // Fallback on earlier versions
        let customView = UIImageView(image: UIImage(systemName: "rosette"))
        customView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        let btn = UIBarButtonItem(customView: customView)
        btn.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openBuyToken)))
        
        navigationItem.rightBarButtonItems = [btn]

    }
}


//MARK: Objc functions
extension HomeViewController{
    
    @objc func openBuyToken(){
        present(BuyTokenViewController(), animated: true)
    }
    
    @objc func nextAction(){

        guard var newPromptText = homeView.inputField.text,
              var userToken = viewModel.userToken.value else {
            return
        }
        
        newPromptText = newPromptText.trim()
        
        //Text   Required for Prompts
        if newPromptText.isReallyEmpty {
            showAlert(.error, (title: "Error", message: "Please fill in prompt field"))
            return
        }

        let wordCount = newPromptText.split(separator: " ").count

        if var userTokenAmount = userToken.amount {

            if userTokenAmount > wordCount {

                userTokenAmount = userTokenAmount - wordCount

                userToken.amount = userTokenAmount

                viewModel.userToken.value = userToken

                // proceed to prompt after update
                newPrompt = PromptDTO(id: nil, prompt: newPromptText, promptOutput: nil)

                //MARK: TODO - Prefetch from API here to get prompt before showing the page
                if let new = newPrompt, let promptText = new.prompt{
                    let mCoordinator = (coordinator as? MainCoordinator)
                    mCoordinator?.navigationController?.startActivityIndicator()
                    viewModel.triggerPrompt(promptText)
                }

            }else{

                //MARK: - Not enough tokens - show modal with button to show BuyTokenViewController
                showAlert(.info, (title: "Not Enough Tokens", message: "Please buy some more tokens to continue"))
            }
        }
    }

    private func getOptionValue(_ selection: ChildItem?) -> Any?{
        guard let select = selection else {
            return nil
        }
        return select.title
    }
}


//MARK: NetworkServiceDelegate
extension HomeViewController: NetworkServiceDelegate {
    func success(_ network: NetworkService, output: PromptOutputDTO) {
        
//        let outputText = (newPrompt?.prompt)! + " \n " +
        guard let firstOutput = output.choices.first,
              let token = viewModel.userToken.value,
              let uTkAmount = token.amount else {
            return
        }
        
        newPrompt?.outputText = firstOutput.text
        newPrompt?.promptOutput = output
        
        TokenManager.shared.updateTokenUsage(outputText: firstOutput.text, tokenAmount: uTkAmount, token: token) { [weak self] result in
            switch result{
            case .success(let tk):
                
                self?.viewModel.userToken.value = tk
                
                DispatchQueue.main.async { [weak self] in
                    let mCoordinator = (self?.coordinator as? MainCoordinator)
                    mCoordinator?.navigationController?.stopActivityIndicator()
                    mCoordinator?.push(WritingViewController(promptDto: (self?.newPrompt)!))
                }
                break
            case .failure(_):
                print("Error updating token")
                break
            }
        }
        
//        let outputTextCount = firstOutput.text.split(separator: " ").count
//
//        uTkAmount = uTkAmount - outputTextCount
//
//        token.amount = uTkAmount
//
//        TokenManager.shared.userToken = token
//        viewModel.userToken.value = token
//
//        FirebaseService.shared.updateDocument(.token, query: ["userId" : userId], data: ["amount" : uTkAmount]) { [weak self] error in
//
//            guard error == nil else {
//                print("error updating token")
//                return
//            }
//
//
//        }
    }
    
    func failure(error: Error?) {
        print(error)
        DispatchQueue.main.async { [weak self] in
            (self?.coordinator as? MainCoordinator)?.navigationController?.stopActivityIndicator()
            
        }
    }

}


//MARK: Collection View SetUp
extension HomeViewController {
    
    private func setUpCollectionView(){
//         Set layout to collection view
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: listLayout)

        homeView.container.addSubview(collectionView)

        collectionView.delegate = viewModel

//        collectionView.backgroundColor = .red

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: homeView.container.topAnchor, constant: 0.0),
            collectionView.leadingAnchor.constraint(equalTo: homeView.container.leadingAnchor, constant: 0.0),
            collectionView.trailingAnchor.constraint(equalTo: homeView.container.trailingAnchor, constant: 0.0),
            collectionView.bottomAnchor.constraint(equalTo: homeView.container.bottomAnchor, constant: 0.0),
        ])
        
        viewModel.dataSource = viewModel.makeDataSource()
    }
}

