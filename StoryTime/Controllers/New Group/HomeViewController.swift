//
//  ViewController.swift
//  StoryTime
//
//  Created by Chuck on 23/11/2022.
//

import UIKit

class HomeViewController: CoordinatingDelegate {
    
    var coordinator: Coordinator?
    
    var collectionView: UICollectionView!
    
    private lazy var viewModel = HomeViewModel(collectionView: collectionView)
    
    var homeView = HomeView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem?.title = ""
        
        view = (coordinator as? MainCoordinator)?.wrapScrollView(homeView)
        
        setUpCollectionView()
        
        setUpActions()
        
        setUpBinders()
    }
    
    private func setUpBinders(){
        viewModel.data.bind(listener: { [weak self] headerItems in
            self?.viewModel.update()
        })
    }
    
    private func setUpActions(){
        homeView.showMore.isUserInteractionEnabled = true
        
        homeView.showMore.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleShowMore)))
        
        homeView.nextBtn.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
    }

}

//MARK: Objc functions
extension HomeViewController{
    
    @objc func toggleShowMore(){
        
        let currentText = homeView.showMore.text!
        
        if currentText.contains("more"){
            
            let newViews = viewModel.more.filter({ headerItem in
                headerItem.title != viewModel.more[0].title
            })
            
            viewModel.data.value?.append(contentsOf: newViews)
            
            homeView.showMore.text = "Show less"
        }else{
            
            viewModel.data.value?.removeAll(where: { headerItem in
                headerItem.title != viewModel.more[0].title
            })
            
            homeView.showMore.text = "Show more"
        }
    }
    
    @objc func nextAction(){
        
        let defaultLength = "Short(100 words)"
        let defaultStyle = "Funny"
        
        let isExisting: (String) -> Bool = { [weak self] opt in
            let isExist = self?.viewModel.selectedOption.contains(where: { header in
                return header.title.contains(opt)
            })
            
            if let exist = isExist  {
                return exist
            }
            
            return false
        }
        
        guard let prompt = homeView.inputField.text else {
            return
        }
        
        // Required for Prompts
        if prompt.isReallyEmpty {
            showAlert(.error, (title: "Error", message: "Please fill in prompt field"))
            return
        }
        
        // Required to determine style
        if !isExisting("Use") {
            showAlert(.error, (title: "Error", message: "Please select a valid use case"))
            return
        }
        
        var selectedOptions: [String: Any] = [:]
        
        selectedOptions["prompt"] = prompt.trim()
        
        for option in viewModel.selectedOption {
            let key = option.title.replacingOccurrences(of: " ", with: "_").lowercased()
            selectedOptions[key] = getOptionValue(option.symbols.first)
        }
        
        //Setting defaults if those options dont exist in selected options
        if !isExisting("Length") {
            selectedOptions["length"] = defaultLength
        }
            
        if !isExisting("Style") {
            selectedOptions["style"] = defaultStyle
        }
        
        (coordinator as? MainCoordinator)?.push(WritingViewController(options: selectedOptions))
    }
    
    private func getOptionValue(_ selection: ChildItem?) -> Any?{
        guard let select = selection else {
            return nil
        }
        return select.title
    }
}


//MARK: Collection View SetUp
extension HomeViewController {
    private func setUpCollectionView(){
        // Set layout to collection view
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: listLayout)
        
        homeView.container.addSubview(collectionView)
        
        collectionView.delegate = viewModel

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: homeView.container.topAnchor, constant: 0.0),
            collectionView.leadingAnchor.constraint(equalTo: homeView.container.leadingAnchor, constant: 0.0),
            collectionView.trailingAnchor.constraint(equalTo: homeView.container.trailingAnchor, constant: 0.0),
            collectionView.bottomAnchor.constraint(equalTo: homeView.container.bottomAnchor, constant: 0.0),
        ])
        
        viewModel.setUpDataSource()
    }
}

