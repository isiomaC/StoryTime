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
        
        setUpCellsAndDataSource()
    }
    
    
    private func setUpCellsAndDataSource(){
        
        let headerCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, HeaderItem> {
        (cell, indexPath, headerItem) in
        
            // Set headerItem's data to cell
            var content = cell.defaultContentConfiguration()
            content.text = headerItem.title
            
            content.imageToTextPadding = CGFloat(10)
            content.imageProperties.maximumSize = CGSize(width: 60, height: 60)
            content.imageProperties.reservedLayoutSize = CGSize(width: 70, height: 70)
            content.secondaryText = headerItem.subTitle
            content.image = UIImage(named: headerItem.imageName)
            
            let addDropShadow: () -> Void = {
                
                // Drop Shadows
                cell.layer.masksToBounds = false
                
                // How blurred the shadow is
                cell.layer.shadowRadius = 8.0

                // The color of the drop shadow
                let isDark = UIScreen.main.traitCollection.userInterfaceStyle == .dark ? true : false
                
                cell.layer.shadowColor = isDark ? UIColor.white.cgColor : UIColor.black.cgColor

                // How transparent the drop shadow is
                cell.layer.shadowOpacity = 0.10

                // How far the shadow is offset from the UICollectionViewCell’s frame
                cell.layer.shadowOffset = CGSize(width: 0, height: 10)
                
            }
            
            addDropShadow()
            
            let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options:headerDisclosureOption)]
            
            cell.contentConfiguration = content
            
        }
        
        let childCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ChildItem> {
            (cell, indexPath, symbolItem) in
            
            // Set symbolItem's data to cell
            var content = cell.defaultContentConfiguration()
            
            content.imageToTextPadding = CGFloat(10)
            content.imageProperties.maximumSize = CGSize(width: 10, height: 10)
            content.imageProperties.reservedLayoutSize = CGSize(width: 15, height: 15)
            content.imageProperties.tintColor = .label
            
            content.image = symbolItem.image
            content.text = symbolItem.title
            content.secondaryText = symbolItem.subTitle
            cell.contentConfiguration = content
        }
        
        // MARK: Initialize data source
        viewModel.dataSource = UICollectionViewDiffableDataSource<Section, ListItem>(collectionView: collectionView) {
            (collectionView, indexPath, listItem) -> UICollectionViewCell? in
            
            switch listItem {
            case .header(let headerItem):
            
                // Dequeue header cell
                let cell = collectionView.dequeueConfiguredReusableCell(using: headerCellRegistration,
                                                                        for: indexPath,
                                                                        item: headerItem)
                return cell
            
            case .symbol(let symbolItem):
                
                // Dequeue symbol cell
                let cell = collectionView.dequeueConfiguredReusableCell(using: childCellRegistration,
                                                                        for: indexPath,
                                                                        item: symbolItem)
                return cell
            }
        }
        
        viewModel.update()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //MAP indexPath.row to Functionality
        print(indexPath)
        
    }
}

