//
//  NetworkService.swift
//  StoryTime
//
//  Created by Chuck on 27/11/2022.
//

import Foundation
import SwiftyJSON

protocol NetworkServiceDelegate{
    func success(_ network: NetworkService, output: PromptOutputDTO)
    func failure(error : Error?)
}

struct NetworkService {
    
    var delegate : NetworkServiceDelegate?
    
    
    private static var instance : NetworkService!
    static var shared : NetworkService = {
        if instance == nil {
            instance = NetworkService()
        }
        return instance
    }()
    
    
    private let APIURL = Utils.readFromPList("Config", key: "BASE_API_URL")
    
    private let VERSION = Utils.readFromPList("Config", key: "VERSION")

    private var SHARED_SECRET = Utils.readFromPList("Config", key: "SHARED_SECRET")
    
    
    func postPrompt(_ prompt: String){
        
        let endpoint = "\(APIURL)/\(VERSION)/prompt"
        
        if Reachability.isConnectedToNetwork(){

            guard let url = URL(string: endpoint) else { return }
            
            let body = [
                "prompt": prompt
            ]
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            
            guard let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
                return
            }
            request.httpBody = httpBody
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request) { (data, response, error) in
                if let err = error{
                    self.delegate?.failure(error: err)
                }
                
                if let responseData = data{
                    if let prediction = self.parseJSON(data: responseData){
                        self.delegate?.success(self, output: prediction)
                    }
                }
            }
            task.resume()
          
        }else{
            delegate?.failure(error: NSError(domain: "No Internet Connection", code: 12000, userInfo: [:]))
        }
   
    }
    
    
    //MARK:  Parse Prediction gotten from cloud function
    private func parseJSON(data: Data) -> PromptOutputDTO? {
        let decoder = JSONDecoder()
        do{
            let decoded = try decoder.decode(PromptOutputDTO.self, from: data)
            
            return decoded
        }catch{
            delegate?.failure(error: error)
            return nil
        }
    }
    
    
    func checkUserSubscription(){
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
            FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {

            do {
                let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                
                let receiptString = receiptData.base64EncodedString(options: [])
                
                let postBody : [String : Any] = [
                    "receiptData" :  receiptString,
                    "password" : SHARED_SECRET,
                    "excludeOldTransactions" : true,
                    "env":"dev"  //MARK: TESTING FLAG ‼️‼️‼️‼️‼️‼️
                ]

                verifyReceipt(body: postBody) { jsonData, error in
                    guard error == nil else { return }
                    
                    if let json = jsonData {
                        
                        let latestReceipt = json["latest_receipt_info"][0]
                        
                        let pendingRenewal = json["pending_renewal_info"][0]
                        
                        let expiryDate = Date(timeIntervalSince1970: latestReceipt["expires_date_ms"].doubleValue / 1000.0)
                        
                        if Date() > expiryDate && pendingRenewal["auto_renew_status"].intValue != 0 {
                            UserDefaults.standard.setValue(false, forKey: UserDefaultkeys.isSubscribed)
                        }
                    }
                }
            }
            catch {
                print("Couldn't read receipt data with error")
            }
        }
    }
    
    
    private func verifyReceipt(body: [String: Any], completion: @escaping(JSON?, Error?) -> Void){
        let url = "\(APIURL)/\(VERSION)/verifyReceipt"
        
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
          return
        }
        request.httpBody = httpBody
        
        let session = URLSession(configuration: .default)  //URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let err = error{
                completion(nil, err)
            }
            
            if let responseData = data{
                do {
                    let json = try JSON(data: responseData)
                    completion(json, nil)
                } catch {
                     completion(nil, error)
                }
            }
        }
        task.resume()
    }
}



