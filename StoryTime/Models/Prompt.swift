//
//  Prompt.swift
//  StoryTime
//
//  Created by Chuck on 27/11/2022.
//

import Foundation
import FirebaseFirestore

// MARK: For saving/retrieving prompt firebase firestore
struct Prompt: Encodable {
    var id: String
    var prompt: String
    var userId: String
    var output: PromptOutputDTO
    
    enum CodingKeys: String, CodingKey{
        case id
        case prompt
        case output
        case userId
    }
    
    static func raw(_ forEnum: CodingKeys) -> String{
        return forEnum.rawValue
    }
    
    func toPrompDto() -> PromptDTO{
        return PromptDTO(prompt: self)
    }
    
    func removeKey(_ key: String = "id") -> [String: Any]?{
        var object = self.dictionary
        guard let index = object.index(forKey: key) else {
            return nil
        }
        let _ = object.remove(at: index)
        return object
    }
}

extension Prompt {
    
    init?(snapShot: QueryDocumentSnapshot) {
        guard
            let prompt = snapShot.data()[Prompt.raw(.prompt)] as? String,
            let userId = snapShot.data()[Prompt.raw(.userId)] as? String,
            let outputData = try? JSONSerialization.data(withJSONObject: snapShot.data()[Prompt.raw(.output)] as Any)
        else{
            return nil
        }

        self.id = snapShot.documentID
        self.prompt = prompt
        self.userId = userId
        
        var output: PromptOutputDTO?
        
        do{
            output = try JSONDecoder().decode(PromptOutputDTO.self, from: outputData)
        }catch{
            return nil
        }
        
        self.output = output!
    }
    
    init?(snapShot: DocumentSnapshot) {
        guard
            let prompt = snapShot.data()?[Prompt.raw(.prompt)] as? String,
            let userId = snapShot.data()?[Prompt.raw(.userId)] as? String,
            let outputData = try? JSONSerialization.data(withJSONObject: snapShot.data()?[Prompt.raw(.output)] as Any)
        else{
            return nil
        }

        self.id = snapShot.documentID
        self.prompt = prompt
        self.userId = userId
        
        var output: PromptOutputDTO?
        
        do{
            output = try JSONDecoder().decode(PromptOutputDTO.self, from: outputData)
        }catch{
            return nil
        }
        
        self.output = output!
    }
    
}

//var dictionary: [String: Any] {
//    return (try? JSONSerialization.jsonObject(with: jsonData())) as? [String: Any] ?? [:]
//}
