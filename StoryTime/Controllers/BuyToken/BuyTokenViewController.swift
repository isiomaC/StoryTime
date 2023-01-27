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
        startActivityIndicator()
        TokenManager.shared.getProducts(delegate: self)
    }
    
}

// Product Request Delegates
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
            
            UIView.animate(withDuration: 0.5, delay: 0) {
                self?.buyTokenView.button_199.setTitle("\(TokenManager.shared.priceOf(product: product001)) / \(aiBuddy_001_AMOUNT) tokens", for: .normal)
                self?.buyTokenView.button_299.setTitle("\(TokenManager.shared.priceOf(product: product002)) / \(aiBuddy_002_AMOUNT) tokens", for: .normal)
                self?.buyTokenView.button_399.setTitle("\(TokenManager.shared.priceOf(product: product003)) / \(aiBuddy_003_AMOUNT) tokens", for: .normal)
                self?.stopActivityIndicator()
            }
           
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        DispatchQueue.main.async { [weak self] in

            self?.showAlert(.info, (title: "Error", message: ""))
           
        }
    }
}


extension BuyTokenViewController {
    @objc func buyToken(sender: UIButton){
        
        startActivityIndicator()
        
        // Disables interactive dismissal of ViewController
        isModalInPresentation = true
        
        switch sender.tag {
        case BuyButtonTags.aiBuddy_001.rawValue:
            
            guard let product = getProductFromTokenManager(.aiBuddy_001) else {
                return
            }
            
            
            if SKPaymentQueue.canMakePayments(){
                let payment = SKPayment(product: product)
                SKPaymentQueue.default().add(self)
                SKPaymentQueue.default().add(payment)
            }
            
            break
        case BuyButtonTags.aiBuddy_002.rawValue:
            guard let product = getProductFromTokenManager(.aiBuddy_002) else {
                return
            }
            
            
            if SKPaymentQueue.canMakePayments(){
                let payment = SKPayment(product: product)
                SKPaymentQueue.default().add(self)
                SKPaymentQueue.default().add(payment)
            }
            
            break
        case BuyButtonTags.aiBuddy_003.rawValue:
            guard let product = getProductFromTokenManager(.aiBuddy_003) else {
                return
            }
            
            
            if SKPaymentQueue.canMakePayments(){
                let payment = SKPayment(product: product)
                SKPaymentQueue.default().add(self)
                SKPaymentQueue.default().add(payment)
            }
            
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


// Payment Delegates
extension BuyTokenViewController: SKPaymentTransactionObserver{
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        var mIndex = 0
        for transaction in transactions{
            switch transaction.transactionState{
            case .purchased:
                complete(transaction: transaction)
                break
                
            case .failed:
                complete(transaction: transaction)
                break
                
            case .purchasing: break
                
            case .restored: break
            
            default: break
            }
            mIndex += 1
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        
        SKPaymentQueue.default().finishTransaction(transaction)
        SKPaymentQueue.default().remove(self)
        
        let productIdentifier = transaction.payment.productIdentifier
        
        let tk = TokenManager.shared
        
        let state = transaction.transactionState
        
        if state == .failed {
            showFinishNotification(transaction.transactionState, transaction.error as? NSError)
        }
        
        if state == .purchased {
            switch productIdentifier {
            case tk.buyButtonMap[.aiBuddy_001]:
                TokenManager.shared.updateTokenAmount(aiBuddy_001_AMOUNT) { [weak self] error in
                    
                    guard error == nil else {
                        self?.stopActivityIndicator()
                        self?.isModalInPresentation = false
                        self?.showAlert(.error, (title: "Error", message: "Something went wrong"))
                        return
                    }
                    self?.showFinishNotification(transaction.transactionState)
                }
                break
            case tk.buyButtonMap[.aiBuddy_002]:
                TokenManager.shared.updateTokenAmount(aiBuddy_002_AMOUNT) { [weak self] error in

                    guard error == nil else {
                        self?.stopActivityIndicator()
                        self?.isModalInPresentation = false
                        self?.showAlert(.error, (title: "Error", message: "Something went wrong"))
                        return
                    }
                    self?.showFinishNotification(transaction.transactionState)
                }
                break
            case tk.buyButtonMap[.aiBuddy_003]:
                TokenManager.shared.updateTokenAmount(aiBuddy_003_AMOUNT) { [weak self] error in
                    
                    guard error == nil else {
                        self?.stopActivityIndicator()
                        self?.isModalInPresentation = false
                        self?.showAlert(.error, (title: "Error", message: "Something went wrong"))
                        return
                    }
                    self?.showFinishNotification(transaction.transactionState)
                }
                break
            default: break
            }
        }
    }
    
    private func showFinishNotification(_ state : SKPaymentTransactionState, _ localizedError: NSError? = nil){
        switch state {
        case .purchased, .restored:
            DispatchQueue.main.async { [weak self] in
                self?.stopActivityIndicator()
                
                self?.isModalInPresentation = false
                
                self?.showAlert(.info, (title: "Purchase sucess", message: ""))

            }
            break
        case .failed:
            DispatchQueue.main.async { [weak self] in
                self?.stopActivityIndicator()
                
                self?.isModalInPresentation = false
                
                guard let error = localizedError,
                      error.code != SKError.paymentCancelled.rawValue else { return }
              
                self?.showAlert(.error, (title: "Purchase unsuccessful", message: error.localizedDescription ))
            }
            break
        default:
            break
        }
    }

}

// Table View Delegates
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

