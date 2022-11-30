//
//  Home.swift
//  StoryTime
//
//  Created by Chuck on 24/11/2022.
//

import Foundation
import UIKit

class Home{
    
}


// MARK: Home View DTOs
enum Section {
    case main
}


enum ListItem: Hashable {
    case header(HeaderItem)
    case symbol(ChildItem)
}


// Header cell data type
struct HeaderItem: Hashable {
    let imageName: String
    let title: String
    let subTitle: String
    let symbols: [ChildItem]
    let image: UIImage
    
    init(imageName: String, title: String, subTitle: String, symbols: [ChildItem]){
        self.imageName = imageName
        self.title = title
        self.subTitle = subTitle
        self.symbols = symbols
        self.image = UIImage(systemName: imageName)!
    }
}


// Child cell data type
struct ChildItem: Hashable {
    let title: String
    let image: UIImage
    let id: Int
    let subTitle: String
    
    init(id: Int, title: String, systemImage: String) {
        self.id = id
        self.subTitle = "Create a \(title.lowercased()) using AI"
        self.title = title
        self.image = UIImage(systemName: systemImage)!
    }
}
