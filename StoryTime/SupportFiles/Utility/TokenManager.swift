//
//  TokenManager.swift
//  StoryTime
//
//  Created by Chuck on 24/12/2022.
//

import Foundation
import UIKit
import StoreKit

let INITIAL_TOKEN_AMOUNT = 1000

let aiBuddy_001_AMOUNT = 2000
let aiBuddy_002_AMOUNT = 5000
let aiBuddy_003_AMOUNT = 10000

struct BuyTokenInfo{
    var key: String?
    var description: String
    var image: UIImage
}

class TokenManager: NSObject {
    
    var products : [SKProduct]?
    
    private var productIds: [String] = ["AiBuddy_001", "AiBuddy_002", "AiBuddy_003"]
    
    let buyButtonMap: [BuyButtonTags: String] = [
        .aiBuddy_001 : "AiBuddy_001",
        .aiBuddy_002 : "AiBuddy_002",
        .aiBuddy_003 : "AiBuddy_003",
    ]
    
    var userToken: TokenDTO?
    

    static let infoListData: [BuyTokenInfo] = [
        BuyTokenInfo( description:"Choose a token plan", image: UIImage(systemName: "checkmark.circle")!),
        BuyTokenInfo( description: "Save countless prompt output", image:UIImage(systemName: "checkmark.circle")!),
        BuyTokenInfo( description: "Limitless prompts", image: UIImage(systemName: "checkmark.circle")!),
        BuyTokenInfo( description: "Mobile AI assitant", image: UIImage(systemName: "checkmark.circle")!)
    ]
    
    private static var instance : TokenManager!
    static var shared: TokenManager = {
        if instance == nil {
            instance = TokenManager()
        }
        return instance
    }()
    
    
    func updateTokenAmount(_ amount: Int, completion: @escaping(Error?) -> Void){
        
        let userId = FirebaseService.shared.getUID()
        
        FirebaseService.shared.getDocuments(.token, query: [ "userId": userId ]) { [weak self] documentSnapShot, error in
            guard let snapShot = documentSnapShot?.first,
                  var token = Token(snapShot: snapShot)?.toTokenDto(),
                  let tkAmount = token.amount,
                    error == nil else {
                completion(error)
                return
            }
            
            let newAmount = tkAmount + amount
            
            snapShot.reference.updateData(["amount": newAmount]){ [weak self] error in
                if let err = error {
                    completion(err)
                }else {
                    
                    token.amount = newAmount
                    self?.userToken = token
                    
                    completion(nil)
                }
            }
        }
    }
    
    
    func initializeFirstUserToken(completion: @escaping() -> Void){
        
        let userId = FirebaseService.shared.getUID()
        
        var userFirstToken = Token(id: "", userId: userId,
                                   amount: INITIAL_TOKEN_AMOUNT,
                                   timeStamp: Date())
        
        guard let tokenSave = userFirstToken.removeKey() else {
            print("Token conversion failed")
            return
        }
        
        FirebaseService.shared.saveDocument(.token, data: tokenSave) { [weak self]tokenRef, error in
            guard let ref = tokenRef else { return }
            
            if let _ = error{
                print( "Something went wrong, Please try again")
            }else{
                userFirstToken.id = ref.documentID
                
                self?.userToken = userFirstToken.toTokenDto()
                
                completion()
            }
        }
    }
    
    
    func fetchUserToken(userId: String, completion: @escaping(TokenDTO?, Error?) -> Void){
        FirebaseService.shared.getDocuments(.token, query: [ "userId": userId ]) { documentSnapShot, error in
            guard let snapShot = documentSnapShot?.first, error == nil else {
                completion(nil, error)
                return
            }
            
            var token: TokenDTO?
            
            if let existingToken = Token(snapShot: snapShot) {
                token = existingToken.toTokenDto()
            }
           
            completion(token, nil)
        }
    }
    
    
    func updateTokenUsage(usageTotal: Int, token: TokenDTO, completion: @escaping(Result<TokenDTO, Error>) -> Void){
        
        guard let userId = userToken?.userId, let currentUserTokenAmt = token.amount else {
            return
        }
        
        var mToken = token
        
        let newUserTokenAmount = currentUserTokenAmt - usageTotal
        
        mToken.amount = newUserTokenAmount
        
        userToken = mToken
    
        FirebaseService.shared.updateDocument(.token, query: ["userId" : userId], data: ["amount" : newUserTokenAmount]) { [weak self] error in
            
            guard error == nil, let tk = self?.userToken else {
                completion(.failure(error!))
                return
            }
            
            completion(.success(tk))
        }
    }
    
    func priceOf(product: SKProduct) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.formatterBehavior = .behavior10_4
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = product.priceLocale
        return numberFormatter.string(from: product.price)!
    }
    
    func getProducts(delegate: BuyTokenViewController){
        let request = SKProductsRequest(productIdentifiers: Set(productIds))
        request.delegate = delegate
        request.start()
    }
}
