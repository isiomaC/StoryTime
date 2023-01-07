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

class TokenManager: NSObject {
    
    private var product : SKProduct?
    
    private var productId: String = "AiBuddy_001"
    
    var userToken: TokenDTO?
    
    private static var instance : TokenManager!
    static var shared: TokenManager = {
        if instance == nil {
            instance = TokenManager()
        }
        return instance
    }()
    
    
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
    
    
    func updateToken(){
        
    }
    
    private func priceOf(product: SKProduct) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.formatterBehavior = .behavior10_4
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = product.priceLocale
        return numberFormatter.string(from: product.price)!
    }
    
    func getProducts(){
        let request = SKProductsRequest(productIdentifiers: [productId])
        request.delegate = self
        request.start()
    }
    
}


extension TokenManager : SKProductsRequestDelegate{
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let mProduct = response.products.first{
            product = mProduct
                
            let price = priceOf(product: mProduct)
            let subText = "Subscribe for \(price) / month"
                
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            
            //MARK:- LOCALIZED ERROR SHOWN HERE
            
        }
    }
}
