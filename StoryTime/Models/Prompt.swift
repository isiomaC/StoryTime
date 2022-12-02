//
//  Prompt.swift
//  StoryTime
//
//  Created by Chuck on 27/11/2022.
//

import Foundation
import FirebaseFirestore

// MARK: For saving prompt to firebase firestore
struct Prompt: Encodable {
    var id: String
    var prompt: String
    var output: PromptOutputDTO
    
    enum CodingKeys: String, CodingKey{
        case id
        case prompt
        case output
    }
    
    static func raw(_ forEnum: CodingKeys) -> String{
        return forEnum.rawValue
    }
}

extension Prompt{
    init?(snapShot: QueryDocumentSnapshot) {
        guard
            let prompt = snapShot.data()[Prompt.raw(.prompt)] as? String,
            let output = snapShot.data()[Prompt.raw(.output)] as? PromptOutputDTO
        else{
            return nil
        }

        self.id = snapShot.documentID
        self.prompt = prompt
        self.output = output
    }
}
