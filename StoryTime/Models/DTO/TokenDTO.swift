//
//  TokenDTO.swift
//  StoryTime
//
//  Created by Chuck on 31/12/2022.
//

import Foundation

struct TokenDTO: Hashable, Codable, Equatable {
    var id: String?
    var userId: String?
    var amount: Int?
    var timeStamp: Date?
    
    init(token: Token){
        self.id = token.id
        self.userId = token.userId
        self.amount = token.amount
        self.timeStamp = token.timeStamp
    }
    
    init(id: String?, userId: String, amount: Int, timeStamp: Date) {
        self.id = id
        self.userId = userId
        self.amount = amount
        self.timeStamp = timeStamp
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(userId)
        hasher.combine(amount)
        hasher.combine(timeStamp)
    }
}
