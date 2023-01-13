//
//  BuyTokenViewController.swift
//  StoryTime
//
//  Created by Chuck on 07/01/2023.
//

import Foundation
import UIKit
import StoreKit

class BuyTokenViewController: BaseViewController {
    
    var buyTokenView = BuyTokenView()
    
    let cellIdentifier = "buyTokenCell"
    
    let infoListData = TokenManager.infoListData
    
    //MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        
        getProducts()
    }
    
    func setUpViews(){
        view = buyTokenView
        
        buyTokenView.infoList.delegate = self
        buyTokenView.infoList.dataSource = self
        
        buyTokenView.infoList.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        buyTokenView.button_199.addTarget(self, action: #selector(buyToken), for: .touchUpInside)
        
        buyTokenView.button_299.addTarget(self, action: #selector(buyToken), for: .touchUpInside)
        
        buyTokenView.button_399.addTarget(self, action: #selector(buyToken), for: .touchUpInside)
        
    }
    
    private func getProducts(){
        TokenManager.shared.getProducts(delegate: self)
    }
    
}

extension BuyTokenViewController {
    @objc func buyToken(sender: UIButton){
        
//        startActivityIndicator()
        
        switch sender.tag {
        case BuyButtonTags.aiBuddy_001.rawValue:
            
            guard let product = getProductFromTokenManager(.aiBuddy_001) else {
                return
            }
            
            print("Price of product",TokenManager.shared.priceOf(product: product))
            
//            if SKPaymentQueue.canMakePayments(){
//                let payment = SKPayment(product: product)
//                SKPaymentQueue.default().add(self)
//                SKPaymentQueue.default().add(self)
//                SKPaymentQueue.default().add(payment)
//            }
            
            //MARK: Add 2000 tokens for user on success
            
            break
        case BuyButtonTags.aiBuddy_002.rawValue:
            guard let product = getProductFromTokenManager(.aiBuddy_002) else {
                return
            }
            
            print("Price of product",TokenManager.shared.priceOf(product: product))
            
            //MARK: Add 5000 tokens for user on success
            
            break
        case BuyButtonTags.aiBuddy_003.rawValue:
            guard let product = getProductFromTokenManager(.aiBuddy_003) else {
                return
            }
            
            print("Price of product",TokenManager.shared.priceOf(product: product))
            
            //MARK: Add 10000 tokens for user on success
            
            break
        default:
            print("defaut")
            break
        }

    }
    
    func getProductFromTokenManager(_ tokenTag: BuyButtonTags) -> SKProduct? {
        let products = TokenManager.shared.products
        
        let buttonProductIdentifier = TokenManager.shared.buyButtonMap[tokenTag]
        
        if let productArray = products?.filter({ element in
            element.productIdentifier == buttonProductIdentifier
        }){
            let product = productArray.first
            return product
        }
        
        return nil
    }
    
}

extension BuyTokenViewController: SKPaymentTransactionObserver{
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        var mIndex = 0
        for transaction in transactions{
            switch transaction.transactionState{
            case .purchasing:
                break
                
            case .purchased:
                complete(transaction: transaction, currentIndex: mIndex, totalCount: transactions.count)
                break
                
            case .restored:
                // MARK: TODO - handle restore
                print("restore in queue")
                break
                
            case .failed:
                // MARK: TODO - handle failure
                print("failed in queue")
                break
            default:
                break
            }
            mIndex += 1
        }
    }
    
    private func complete(transaction: SKPaymentTransaction, currentIndex: Int, totalCount: Int) {
        //MARK: add tokens for User in Firebase
        
        if currentIndex == totalCount-1 {
            showFinishNotification(transaction.transactionState)
        }
        SKPaymentQueue.default().finishTransaction(transaction)
        SKPaymentQueue.default().remove(self)
    }
    
    private func showFinishNotification(_ state : SKPaymentTransactionState, _ localizedError: NSError? = nil){
        switch state {
        case .purchased, .restored:
            DispatchQueue.main.async { [weak self] in
//                self?.stopActivityIndicator()
                
                print("Purchase successful bitch")
                
                self?.dismiss(animated: true)
                
            }
            break
        case .failed:
            DispatchQueue.main.async { [weak self] in
//                self?.stopActivityIndicator()
                guard let strongSelf = self,
                      let localizedDescription = localizedError?.localizedDescription,
                      localizedError?.code != SKError.paymentCancelled.rawValue else { return }
                
                //MARK: LOCALIZED ERROR SHOWN HERE
                print(localizedDescription)
            }
            break
        default:
            break
        }
    }

}

extension BuyTokenViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoListData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let model = infoListData[indexPath.row]
        
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            cell.tintColor = MyColors.primary
            
            content.text = model.description
            content.image = model.image

            cell.contentConfiguration = content
        }else{
            cell.textLabel?.text = model.description
            
            cell.imageView?.tintColor = MyColors.primary
            
            cell.imageView?.image = model.image

            cell.accessoryType = .checkmark
            
            cell.selectionStyle = .none
        }

        return cell
    }
    
}


extension BuyTokenViewController : SKProductsRequestDelegate{
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        TokenManager.shared.products = response.products
        
        let getProduct : (BuyButtonTags) -> SKProduct = { key in
            let product = response.products.first { prod in
                return prod.productIdentifier == TokenManager.shared.buyButtonMap[key]
            }
            
            return product ?? SKProduct()
        }
        
        let product001 = getProduct(.aiBuddy_001)
        let product002 = getProduct(.aiBuddy_002)
        let product003 = getProduct(.aiBuddy_003)
            
        DispatchQueue.main.async { [weak self] in
            
           //MARK: Update button UI to show price/amount of tokens
            self?.buyTokenView.button_199.setTitle("\(TokenManager.shared.priceOf(product: product001)) / \(aiBuddy_001_AMOUNT) tokens", for: .normal)
            self?.buyTokenView.button_299.setTitle("\(TokenManager.shared.priceOf(product: product002)) / \(aiBuddy_002_AMOUNT) tokens", for: .normal)
            self?.buyTokenView.button_399.setTitle("\(TokenManager.shared.priceOf(product: product003)) / \(aiBuddy_003_AMOUNT) tokens", for: .normal)
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            
            //MARK: LOCALIZED ERROR SHOWN HERE
            print(error)
        }
    }
}
