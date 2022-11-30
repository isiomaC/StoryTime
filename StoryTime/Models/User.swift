//
//  User.swift
//  StoryTime
//
//  Created by Chuck on 24/11/2022.
//

import Foundation
import FirebaseFirestore

struct User : Codable{
    var id: String
    let email : String
    let guid : String
    let timestamp : Date
    
    enum CodingKeys: String, CodingKey{
        case id
        case email
        case guid
        case timestamp
    }
    
    static func raw(_ forEnum: CodingKeys) -> String{
        return forEnum.rawValue
    }
    
    func remove(_ key: String = "id") -> [String: Any]?{
        var object = self.dictionary
        guard let index = object.index(forKey: key) else {
            return nil
        }
        let removedId = object.remove(at: index)
        return object
    }
}

extension User{
    init?(snapShot: QueryDocumentSnapshot) {
        guard
            let email = snapShot.data()[User.raw(.email)] as? String,
            let guid = snapShot.data()[User.raw(.guid)] as? String,
            let timeStamp = snapShot.data()[User.raw(.timestamp)] as? Timestamp
        else{
            return nil
        }
        
        self.id = snapShot.documentID
        self.email = email
        self.guid = guid
        self.timestamp = timeStamp.dateValue()
    }
}

