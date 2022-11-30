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
        HeaderItem(imageName: "book.circle.fill", title: "Use Case", subTitle: "Select use case for Story Time", symbols: [
            ChildItem(id: 1, title: "Story", systemImage: "oval.portrait.fill"),
            ChildItem(id: 2, title: "Profile Bio", systemImage: "oval.portrait.fill"),
            ChildItem(id: 3, title: "Blog Post", systemImage: "oval.portrait.fill"),
        ]),
        HeaderItem(imageName: "book.circle.fill", title: "Length", subTitle: "Decide on a length", symbols: [
//            ChildItem(id: 4, title: "Story One", systemImage: "oval.portrait.fill"),
            ChildItem(id: 5, title: "Short(100 words)", systemImage: "oval.portrait.fill"),
            ChildItem(id: 6, title: "Medium(150 words)", systemImage: "oval.portrait.fill"),
            ChildItem(id: 7, title: "Long(200+ words)", systemImage: "oval.portrait.fill"),
        ]),
        HeaderItem(imageName: "book.circle.fill", title: "Style", subTitle: "Decide on a writing style", symbols: [
//            ChildItem(id: 5, title: "Story Two", systemImage: "oval.portrait.fill"),
            
            ChildItem(id: 9, title: "Funny", systemImage: "oval.portrait.fill"),
            ChildItem(id: 10, title: "Scary", systemImage: "oval.portrait.fill"),
            ChildItem(id: 11, title: "Fantasy", systemImage: "oval.portrait.fill"),
            ChildItem(id: 12, title: "Adventure", systemImage: "oval.portrait.fill"),
        ])
    ]
    
    public var data: ObservableObject<[HeaderItem]> = ObservableObject([
        HeaderItem(imageName: "book.circle.fill", title: "Use Case", subTitle: "Select use case for Story Time", symbols: [
            ChildItem(id: 1, title: "Story", systemImage: "oval.portrait.fill"),
            ChildItem(id: 2, title: "Profile Bio", systemImage: "oval.portrait.fill"),
            ChildItem(id: 3, title: "Blog Post", systemImage: "oval.portrait.fill"),
        ])
    ])
    
    var childCellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, ChildItem>!
    
    var headerCellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, HeaderItem>!
    
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
    
    func setUpDataSource(){
        
        setUpParentCell()
        setUpChildCell()
        
        guard let colView = collectionView, let headerReg = headerCellRegistration, let childReg = childCellRegistration else {
            return
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, ListItem>(collectionView: colView) {
            (collectionView, indexPath, listItem) -> UICollectionViewCell? in
            
            switch listItem {
            case .header(let headerItem):
            
                // Dequeue header cell
                let cell = collectionView.dequeueConfiguredReusableCell(using: headerReg, for: indexPath, item: headerItem)
                return cell
            
            case .symbol(let symbolItem):
                
                // Dequeue symbol cell
                let cell = collectionView.dequeueConfiguredReusableCell(using: childReg, for: indexPath, item: symbolItem)
                return cell
            }
        }
        
        update()
    }
    
    private func setUpParentCell(){
        headerCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, HeaderItem> {
        (cell, indexPath, headerItem) in
        
            // Set headerItem's data to cell
            var content = cell.defaultContentConfiguration()
            content.text = headerItem.title
            
            content.textProperties.font = AppFonts.Bold(.subtitle)
            
            content.imageToTextPadding = CGFloat(10)
            content.imageProperties.maximumSize = CGSize(width: 60, height: 60)
            content.imageProperties.reservedLayoutSize = CGSize(width: 70, height: 70)
            content.secondaryText = headerItem.subTitle
            content.image = headerItem
                                .image
                                .resizeImage(CGSize(width: 50, height: 50)).withTintColor(MyColors.primary)
            
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
    }
    
    private func setUpChildCell(){
        childCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ChildItem> {
            (cell, indexPath, symbolItem) in
            
            // Set symbolItem's data to cell
            var content = cell.defaultContentConfiguration()
            
            content.imageToTextPadding = CGFloat(10)
            content.imageProperties.maximumSize = CGSize(width: 10, height: 10)
            content.imageProperties.reservedLayoutSize = CGSize(width: 15, height: 15)
            content.imageProperties.tintColor = .label
            
            content.textProperties.font = AppFonts.caption
            
            content.image = symbolItem.image
            content.text = symbolItem.title
            content.secondaryText =  symbolItem.id > 4 ? nil : symbolItem.subTitle
            cell.contentConfiguration = content
        }
    }

}



extension HomeViewModel: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(indexPath.row)
    }
    
}
