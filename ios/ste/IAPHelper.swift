/*
* Copyright (c) 2016 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import StoreKit

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> ()
public typealias BuyRequestCompletionHandler = (_ success: Bool, _ date:Date? ,_ productIdentifier: String?, _ quantity:Int) -> ()
//public typealias RestoreCompletionHandler = (_ success: Bool) -> ()

open class IAPHelper : NSObject  {
  
    
    fileprivate var productIdentifiers: Set<ProductIdentifier>
    fileprivate var productsRequest: SKProductsRequest?
    fileprivate var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    fileprivate var buyRequestCompletionHandlers:[String :BuyRequestCompletionHandler]
    
    var lastErrorString:String? = nil
  
  public init(productIds: Set<ProductIdentifier>) {
    productIdentifiers = productIds
    self.buyRequestCompletionHandlers = [:]
    super.init()
    SKPaymentQueue.default().add(self)
  }
    
  func getLastError() -> String?
  {
    return lastErrorString
  }
    
  deinit
  {
    SKPaymentQueue.default().remove(self)
  }
}

// MARK: - StoreKit API

extension IAPHelper: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Loaded list of products...")
        let products = response.products
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()
        lastErrorString = nil
        for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription) \(error)")
        lastErrorString = error.localizedDescription
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
}

// MARK: - SKPaymentTransactionObserver

extension IAPHelper: SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("complete...")
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier, quantity: transaction.payment.quantity, date: transaction.transactionDate)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        guard let productQuantity = transaction.original?.payment.quantity else { return }
        guard let productDate = transaction.original?.transactionDate else { return }
        print("restore... \(productIdentifier)")
        deliverPurchaseNotificationFor(identifier: productIdentifier, quantity: productQuantity, date: productDate)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        if let transactionError = transaction.error as NSError? {
            if transactionError.code != SKError.paymentCancelled.rawValue {
                print("Transaction Error: \(String(describing: transaction.error?.localizedDescription))")
                lastErrorString = transaction.error?.localizedDescription
            }
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
        buyRequestCompletionHandlers[transaction.payment.productIdentifier]?(false, nil, transaction.payment.productIdentifier, 0)
        buyRequestCompletionHandlers.removeValue(forKey: transaction.payment.productIdentifier)
    }
    
    private func deliverPurchaseNotificationFor(identifier: String?, quantity:Int, date:Date?) {
        guard let identifier = identifier else { return }
        lastErrorString = nil
        buyRequestCompletionHandlers[identifier]?(true, date, identifier, quantity)
        buyRequestCompletionHandlers.removeValue(forKey: identifier)
    }
}
	
extension IAPHelper {
  
    public func requestProducts(completionHandler: @escaping ProductsRequestCompletionHandler) {
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
        print("start load list of products.")
    }

    public func buyProduct(_ product: SKProduct, quantity:Int, completionHandler: @escaping BuyRequestCompletionHandler) {
    buyRequestCompletionHandlers[product.productIdentifier] = completionHandler
    print("Buying \(product.productIdentifier)- \(quantity) items...")
    let payment = SKMutablePayment(product: product)
        payment.quantity = quantity
    SKPaymentQueue.default().add(payment)
  }
  
  public class func canMakePayments() -> Bool {
    return SKPaymentQueue.canMakePayments()
  }
  
  public func restorePurchases(completionHandler: @escaping BuyRequestCompletionHandler) {
    buyRequestCompletionHandlers["com.robotea.ste.restorepurchase"] = completionHandler
    print("Restoring items...")
    SKPaymentQueue.default().restoreCompletedTransactions()
  }
}
