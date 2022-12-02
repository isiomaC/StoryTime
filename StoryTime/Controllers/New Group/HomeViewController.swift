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
        
//        viewModel.add([Story(id: "tes2", text: "test String2 test String test String test String test String  test String test String", prompts: "testing Prompt2 test String test String test String test String test String test String test String test String", userId: "testinfI2", type: "Story2", dateCreated: Date())])
        
        fetchStories()
    }
    
    private func fetchStories(){
//        viewModel.add([Story(id: "tes", text: "test String", prompts: "testing Prompt", userId: "testinfI", type: "Story", dateCreated: Date())])
    }
    
    private func setUpActions(){
        
        homeView.nextBtn.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
    }

}

//MARK: Objc functions
extension HomeViewController{
    
    @objc func nextAction(){

        guard let prompt = homeView.inputField.text else {
            return
        }

        // Required for Prompts
        if prompt.isReallyEmpty {
            showAlert(.error, (title: "Error", message: "Please fill in prompt field"))
            return
        }

        var selectedOptions: [String: Any] = [:]

        selectedOptions["prompt"] = prompt.trim()

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
//         Set layout to collection view
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: listLayout)

        homeView.container.addSubview(collectionView)

        collectionView.delegate = viewModel

        collectionView.backgroundColor = .red

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

