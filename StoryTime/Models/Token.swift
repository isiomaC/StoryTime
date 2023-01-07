//
//  Token.swift
//  StoryTime
//
//  Created by Chuck on 31/12/2022.
//

import Foundation
import FirebaseFirestore

// MARK: For saving/retrieving prompt firebase firestore
struct Token: Encodable {
    var id: String
    var userId: String
    var amount: Int
    var timeStamp: Date
    
    enum CodingKeys: String, CodingKey{
        case id
        case userId
        case amount
        case timeStamp
    }
    
    static func raw(_ forEnum: CodingKeys) -> String{
        return forEnum.rawValue
    }
    
    func toTokenDto() -> TokenDTO{
        return TokenDTO(token: self)
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

extension Token {
    
    init?(snapShot: QueryDocumentSnapshot) {
        guard
            let userId = snapShot.data()[Token.raw(.userId)] as? String,
            let amount = snapShot.data()[Token.raw(.amount)] as? Int,
            let timeStampString = snapShot.data()[Token.raw(.timeStamp)] as? String,
            let timeStamp = ISO8601DateFormatter().date(from: timeStampString)
        else{
            return nil
        }

        self.id = snapShot.documentID
        self.userId = userId
        self.amount = amount
        self.timeStamp = timeStamp
     
    }
    
    init?(snapShot: DocumentSnapshot) {
        guard
            let userId = snapShot.data()?[Token.raw(.userId)] as? String,
            let amount = snapShot.data()?[Token.raw(.amount)] as? Int,
            let timeStampString = snapShot.data()?[Token.raw(.timeStamp)] as? String,
            let timeStamp = ISO8601DateFormatter().date(from: timeStampString)
        else{
            return nil
        }

        self.id = snapShot.documentID
        self.userId = userId
        self.amount = amount
        self.timeStamp = timeStamp
        
//        Int(Date().timeIntervalSince1970)
    }
}
