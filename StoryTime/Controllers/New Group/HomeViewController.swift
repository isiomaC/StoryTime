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
    
    private lazy var viewModel: HomeViewModel = HomeViewModel(collectionView: collectionView)
    
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
    
    
    @objc func toggleShowMore(){
        
        let currentText = homeView.showMore.text!
        
        if currentText.contains("more"){
            
            viewModel.data.value = viewModel.more
            
            homeView.showMore.text = "Show less"
        }else{
            
            viewModel.data.value = [viewModel.more[0]]
            
            homeView.showMore.text = "Show more"
        }
    }
    
    @objc func nextAction(){
        (coordinator as? MainCoordinator)?.push(WritingViewController())
    }

}


extension HomeViewController: UICollectionViewDelegate{
    
    
    private func setUpCollectionView(){
        // Set layout to collection view
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: listLayout)
        
        homeView.container.addSubview(collectionView)
        
        collectionView.delegate = self

        // Make collection view take up the entire view
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: homeView.container.topAnchor, constant: 0.0),
            collectionView.leadingAnchor.constraint(equalTo: homeView.container.leadingAnchor, constant: 0.0),
            collectionView.trailingAnchor.constraint(equalTo: homeView.container.trailingAnchor, constant: 0.0),
            collectionView.bottomAnchor.constraint(equalTo: homeView.container.bottomAnchor, constant: 0.0),
        ])
        
        viewModel.setUpDataSource()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //MAP indexPath.row to Functionality
        print(indexPath)
        
    }
}

