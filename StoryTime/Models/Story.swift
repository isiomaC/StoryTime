//
//  Story.swift
//  StoryTime
//
//  Created by Chuck on 24/11/2022.
//

import Foundation
import FirebaseFirestore

struct Story : Codable{
    var id: String
    let text : String
    let prompts : [String]
    let userId: String
    let type: String
    let dateCreated : Date
    
    enum CodingKeys: String, CodingKey{
        case id
        case text
        case prompts
        case userId
        case type
        case dateCreated
    }
    
    static func raw(_ forEnum: CodingKeys) -> String{
        return forEnum.rawValue
    }
}

extension Story{
    init?(snapShot: QueryDocumentSnapshot) {
        guard
            let text = snapShot.data()[Story.raw(.text)] as? String,
            let prompts = snapShot.data()[Story.raw(.prompts)] as? [String],
            let userId = snapShot.data()[Story.raw(.userId)] as? String,
            let type = snapShot.data()[Story.raw(.type)] as? String,
            let dateCreated = snapShot.data()[Story.raw(.dateCreated)] as? Timestamp
        else{
            return nil
        }

        self.id = snapShot.documentID
        self.text = text
        self.prompts = prompts
        self.userId = userId
        self.type = type
        self.dateCreated = dateCreated.dateValue()
    }
}
