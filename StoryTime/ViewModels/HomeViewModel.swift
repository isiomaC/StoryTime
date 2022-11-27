//
//  HomeViewModel.swift
//  StoryTime
//
//  Created by Chuck on 24/11/2022.
//

import Foundation
import UIKit

class HomeViewModel: CollectionViewModel<HomeCell>{
    
    
    public var error: ObservableObject<String?> = ObservableObject(nil)
    
    let verticalSpacing: CGFloat = 15
    
    let more = [
        HeaderItem(imageName: "undraw", title: "Use Case", subTitle: "Select use case for Story Time", symbols: [
            ChildItem(id: 1, title: "Story", systemImage: "oval.portrait.fill"),
            ChildItem(id: 2, title: "Profile Bio", systemImage: "oval.portrait.fill"),
            ChildItem(id: 3, title: "Blog Post", systemImage: "oval.portrait.fill"),
        ]),
        HeaderItem(imageName: "undraw", title: "Length", subTitle: "Decide on a length", symbols: [
            ChildItem(id: 4, title: "Story One", systemImage: "oval.portrait.fill"),
        ]),
        HeaderItem(imageName: "undraw", title: "Style", subTitle: "Decide on a writing style", symbols: [
            ChildItem(id: 5, title: "Story Two", systemImage: "oval.portrait.fill"),
        ])
    ]
    
    public var data: ObservableObject<[HeaderItem]> = ObservableObject([
        HeaderItem(imageName: "undraw", title: "Use Case", subTitle: "Select use case for Story Time", symbols: [
            ChildItem(id: 1, title: "Story", systemImage: "oval.portrait.fill"),
            ChildItem(id: 2, title: "Profile Bio", systemImage: "oval.portrait.fill"),
            ChildItem(id: 3, title: "Blog Post", systemImage: "oval.portrait.fill"),
        ])
    ])
    
    
    init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView, cellReuseIdentifier: "HomeCell")
    }
    
    override func update(){
        // MARK: Setup snapshots
        var dataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, ListItem>()

        // Create a section in the data source snapshot
        dataSourceSnapshot.appendSections([.main])
        dataSource?.apply(dataSourceSnapshot)
        
        // Create a section snapshot for main section
        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<ListItem>()
        
        if let mData = data.value{
            for headerItem in mData {
               
                
                // Create a header ListItem & append as parent
                let headerListItem = ListItem.header(headerItem)
                sectionSnapshot.append([headerListItem])
                
                
                // Create an array of symbol ListItem & append as children of headerListItem
                let symbolListItemArray = headerItem.symbols.map { ListItem.symbol($0) }
                sectionSnapshot.append(symbolListItemArray, to: headerListItem)
                
                
                // Expand this section by default
                sectionSnapshot.expand([headerListItem])

            }
        }
       
        // Apply section snapshot to main section
        dataSource?.apply(sectionSnapshot, to: .main, animatingDifferences: false)
    }
    
    
    func triggerPrompt(){
        
    }
    
    

}



extension HomeViewModel: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        remove([items.value![indexPath.item]])
        
        print(indexPath.row)
    }
    
}
