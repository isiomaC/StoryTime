//
//  HomeViewModel.swift
//  StoryTime
//
//  Created by Chuck on 24/11/2022.
//

import Foundation
import UIKit
import FirebaseFirestore

class HomeViewModel: CollectionViewModel<HomeCell>{
    
    public var error: ObservableObject<String> = ObservableObject(nil)
    
    public var userToken: ObservableObject<TokenDTO> = ObservableObject(nil)
    
    var coordinator : Coordinator?
    
    var previousLastDocument: DocumentSnapshot?
    var lastDocument: DocumentSnapshot?

    var userId: String
    
    init(collectionView: UICollectionView) {
        self.userId = FirebaseService.shared.getUID()
        super.init(collectionView: collectionView, cellReuseIdentifier: "HomeCell")
    }
    
    func triggerPrompt(_ text: String){
        NetworkService.shared.postPromptChatGpt(text)
    }
    
    func fetchToken(completion: @escaping(TokenDTO?, Error?) -> Void){
        TokenManager.shared.fetchUserToken(userId: userId) { token, error in
            completion(token, error)
        }
    }
    
    func fetchPrompts(completion: @escaping([PromptV2]?, Error?) -> Void) {

        FirebaseService.shared.getPaginatedDocuments(.promptOuput, query: [ "userId": userId ], last: lastDocument) { [weak self] documentSnapShot, error in
            guard let snapShot = documentSnapShot, error == nil else {
                completion(nil, error)
                return
            }
            
            var prompts:[PromptV2] = []
            
            for shot in snapShot{
                if let existingPrompt = PromptV2(snapShot: shot) {
                    prompts.append(existingPrompt)
                }
            }
            
            self?.previousLastDocument = nil
            self?.lastDocument = snapShot.last
            completion(prompts, nil)
        }
    }
    
    func fetchPaginatedPrompts(completion: @escaping([PromptV2]?, Error?) -> Void){
       
        FirebaseService.shared.getPaginatedDocuments(.promptOuput, query: [ "userId": userId ], last: lastDocument) { [weak self] documentsSnapShot, error in
            guard let snapShot = documentsSnapShot, error == nil else {
                completion(nil, error)
                return
            }
            
            var prompts : [PromptV2] = []
            
            for shot in snapShot{
                if let existingPrompt = PromptV2(snapShot: shot) {
                    prompts.append(existingPrompt)
                }
            }
            
            self?.previousLastDocument = self?.lastDocument
            self?.lastDocument = snapShot.last
            completion(prompts, nil)
        }
    }
    
    func deletePrompt(_ prompt: PromptChatDTO){
        guard let id = prompt.id else { return }
        
        remove([prompt])
        
        FirebaseService.shared.deleteDocument(.promptOuput, docId: id)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        
        if indexPath.row == itemsCount - 1 {
            if previousLastDocument != lastDocument {
                
                NotificationCenter.default.post(name: .fetchMore, object: nil)
            }
        }
    }

}


extension HomeViewModel: UICollectionViewDelegate {
    
    private func openStory(_ item: PromptChatDTO?){
        
        guard let myItem = item else {
            return
        }
        
        let mainCoordinator = coordinator as? MainCoordinator
        
        let nextVC = WritingViewController(promptDto: myItem)
        
        mainCoordinator?.push(nextVC)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let myItems = items.value{
            openStory(myItems[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let menuConfig = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] elements in
            
            guard let strongSelf = self else {
                return nil
            }
            
            return strongSelf.buildContextMenuForCell(indexPath)
        }
        
        return menuConfig
    }
    
    func buildContextMenuForCell(_ indexPath: IndexPath) -> UIMenu{
        
        let deleteAction =  UIAction(title: "Delete", image: UIImage(systemName: "trash.fill"), attributes: .destructive) { [weak self] action in

            guard let myItems = self?.items.value else { return }
            
            let promtToDeplete = myItems[indexPath.row]
            
            self?.deletePrompt(promtToDeplete)
            
            let hapticFeedback = UINotificationFeedbackGenerator()
            hapticFeedback.notificationOccurred(.success)
        }
        
        return UIMenu(title: "", children: [deleteAction])
    }
    
}










//MARK: Unused
extension HomeViewModel{
    
    
//    override func update(){
//        super.update()
//        if var snapShot = dataSource?.snapshot(){
//            let itemsExist = snapShot.numberOfItems > 0
//
//            if itemsExist {
//                let itemIdentifiers = snapShot.itemIdentifiers(inSection: .main)
//
//                snapShot.deleteItems(itemIdentifiers)
//
//                snapShot.appendItems(items.value!)
//
//                dataSource?.applySnapshotUsingReloadData(snapShot)
//
////                let sectionSnapshot = getSectionSnapShot()
//
////                dataSource?.apply(sectionSnapshot, to: .main, animatingDifferences: true)
//
//            }else{
//
//                var dataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Story>()
//
//                // Create a section in the data source snapshot
//                dataSourceSnapshot.appendSections([.main])
//
//                dataSourceSnapshot.appendItems(items.value!)
//
//                dataSource?.applySnapshotUsingReloadData(dataSourceSnapshot)
//
////                let sectionSnapshot = getSectionSnapShot()
//
//                // Apply section snapshot to main section
////                dataSource?.apply(sectionSnapshot, to: .main, animatingDifferences: true)
//            }
//        }
//    }
    
    
    
    
    // MARK: Start Will remove
//    let more = [
//        HeaderItem(imageName: "book.circle.fill", title: "Use Case", subTitle: "Select use case for Story Time", symbols: [
//            ChildItem(id: 1, title: "Story", systemImage: "oval.portrait.fill"),
//            ChildItem(id: 2, title: "Profile Bio", systemImage: "oval.portrait.fill"),
//            ChildItem(id: 3, title: "Blog Post", systemImage: "oval.portrait.fill"),
//        ]),
//        HeaderItem(imageName: "book.circle.fill", title: "Length", subTitle: "Decide on a length", symbols: [
////            ChildItem(id: 4, title: "Story One", systemImage: "oval.portrait.fill"),
//            ChildItem(id: 5, title: "Short(100 words)", systemImage: "oval.portrait.fill"),
//            ChildItem(id: 6, title: "Medium(150 words)", systemImage: "oval.portrait.fill"),
//            ChildItem(id: 7, title: "Long(200+ words)", systemImage: "oval.portrait.fill"),
//        ]),
//        HeaderItem(imageName: "book.circle.fill", title: "Style", subTitle: "Decide on a writing style", symbols: [
////            ChildItem(id: 5, title: "Story Two", systemImage: "oval.portrait.fill"),
//
//            ChildItem(id: 9, title: "Funny", systemImage: "oval.portrait.fill"),
//            ChildItem(id: 10, title: "Scary", systemImage: "oval.portrait.fill"),
//            ChildItem(id: 11, title: "Fantasy", systemImage: "oval.portrait.fill"),
//            ChildItem(id: 12, title: "Adventure", systemImage: "oval.portrait.fill"),
//        ])
//    ]
//
//    public var data: ObservableObject<[HeaderItem]> = ObservableObject([
//        HeaderItem(imageName: "book.circle.fill", title: "Use Case", subTitle: "Select use case for Story Time", symbols: [
//            ChildItem(id: 1, title: "Story", systemImage: "oval.portrait.fill"),
//            ChildItem(id: 2, title: "Profile Bio", systemImage: "oval.portrait.fill"),
//            ChildItem(id: 3, title: "Blog Post", systemImage: "oval.portrait.fill"),
//        ])
//    ])
//
//    var childCellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, ChildItem>!
//
//    var headerCellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, HeaderItem>!
//
//    var selectedOption: [HeaderItem] = []
    // MARK: End Will Remove
    
    
//    private func getSectionSnapShot() -> NSDiffableDataSourceSectionSnapshot<Story>{
//
//        // Create a section snapshot for main section
//        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Story>()
//
//        if let mData = items.value{
//            for headerItem in mData {
//
//                // Create a header ListItem & append as parent
//                let headerListItem = ListItem.header(headerItem)
//                sectionSnapshot.append([headerListItem])
//
//                // Create an array of symbol ListItem & append as children of headerListItem
//                let symbolListItemArray = headerItem.symbols.map { ListItem.symbol($0) }
//                sectionSnapshot.append(symbolListItemArray, to: headerListItem)
//
//                // Expand this section by default
//                sectionSnapshot.expand([headerListItem])
//            }
//        }
//        return sectionSnapshot
//    }
    
//    func setUpDataSource(){
//
//        setUpParentCell()
//        setUpChildCell()
        
//        guard let colView = collectionView, let headerReg = headerCellRegistration, let childReg = childCellRegistration else {
//            return
//        }
        
//        dataSource = UICollectionViewDiffableDataSource<Section, Story>(collectionView: colView) {
//            (collectionView, indexPath, listItem) -> UICollectionViewCell? in
//
//            switch listItem {
//            case .header(let headerItem):
//
//                // Dequeue header cell
//                let cell = collectionView.dequeueConfiguredReusableCell(using: headerReg, for: indexPath, item: headerItem)
//                return cell
//
//            case .symbol(let symbolItem):
//
//                // Dequeue symbol cell
//                let cell = collectionView.dequeueConfiguredReusableCell(using: childReg, for: indexPath, item: symbolItem)
//                return cell
//            }
//        }
//    }
//
//    private func setUpParentCell(){
//        headerCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, HeaderItem> {
//        (cell, indexPath, headerItem) in
//
//            // Set headerItem's data to cell
//            var content = cell.defaultContentConfiguration()
//            content.text = headerItem.title
//
//            content.textProperties.font = AppFonts.Bold(.subtitle)
//
//            content.imageToTextPadding = CGFloat(10)
//            content.imageProperties.maximumSize = CGSize(width: 60, height: 60)
//            content.imageProperties.reservedLayoutSize = CGSize(width: 70, height: 70)
//            content.secondaryText = headerItem.subTitle
//            content.image = headerItem
//                                .image
//                                .resizeImage(CGSize(width: 50, height: 50)).withTintColor(MyColors.primary)
//
//            let addDropShadow: () -> Void = {
//
//                // Drop Shadows
//                cell.layer.masksToBounds = false
//
//                // How blurred the shadow is
//                cell.layer.shadowRadius = 8.0
//
//                // The color of the drop shadow
//                let isDark = UIScreen.main.traitCollection.userInterfaceStyle == .dark ? true : false
//
//                cell.layer.shadowColor = isDark ? UIColor.white.cgColor : UIColor.black.cgColor
//
//                // How transparent the drop shadow is
//                cell.layer.shadowOpacity = 0.10
//
//                // How far the shadow is offset from the UICollectionViewCell’s frame
//                cell.layer.shadowOffset = CGSize(width: 0, height: 10)
//
//            }
//
//            addDropShadow()
//
//            let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .header)
//            cell.accessories = [.outlineDisclosure(options:headerDisclosureOption)]
//
//            cell.contentConfiguration = content
//
//        }
//    }
//
//    private func setUpChildCell(){
//        childCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ChildItem> {
//            (cell, indexPath, symbolItem) in
//
//            // Set symbolItem's data to cell
//            var content = cell.defaultContentConfiguration()
//
//            content.imageToTextPadding = CGFloat(10)
//            content.imageProperties.maximumSize = CGSize(width: 10, height: 10)
//            content.imageProperties.reservedLayoutSize = CGSize(width: 15, height: 15)
//            content.imageProperties.tintColor = .label
//
//            content.textProperties.font = AppFonts.caption
//
//            content.image = symbolItem.image
//            content.text = symbolItem.title
//            content.secondaryText =  symbolItem.id > 4 ? nil : symbolItem.subTitle
//            cell.contentConfiguration = content
//        }
//    }
}
