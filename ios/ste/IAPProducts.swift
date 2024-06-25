//
//  IAPProducts.swift
//  ste
//
//  Created by Zdeněk Skulínek on 05.03.18.
//  Copyright © 2018 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import StoreKit

public typealias IAPProductsRequestCompletionHandler = (_ success: Bool) -> ()

class IAPProducts: NSObject {
    
    
    var xLivesLine: String = "Ten Extra Lives"
    var invulnerabilityLine: String = "Invulnerability"
    var timeLine: String = "20% Extra Time"
    var xLivesPriceValue: Double = 0.99
    var invulnerabilityPriceValue: Double = 7.99
    var timePriceValue: Double = 4.99
    var localeIdentifier: String = "en_US"
    var xLivesSteeperValue: Int = 0
    var invulnerabilitySteeperValue: Int = 0
    var timeSteeperValue: Int = 0
    var XExtraLivesInIAP = 10

    var bcanMakePayments: Bool = false

    public static let InvulnerabilityKey = "com.robotea.ste.invulnerabilityc"
    public static let ExtraTimeKey = "com.robotea.ste.extratimec"
    public static let XExtraLivesKey = "com.robotea.ste.xlives."
    
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [InvulnerabilityKey, ExtraTimeKey,
        "com.robotea.ste.xlives.aa.2", "com.robotea.ste.xlives.aa.3","com.robotea.ste.xlives.aa.5", "com.robotea.ste.xlives.aa.8", "com.robotea.ste.xlives.aa.10", "com.robotea.ste.xlives.aa.12", "com.robotea.ste.xlives.aa.15", "com.robotea.ste.xlives.aa.20", "com.robotea.ste.xlives.aa.25", "com.robotea.ste.xlives.aa.30",
        "com.robotea.ste.xlives.bb.2", "com.robotea.ste.xlives.bb.3","com.robotea.ste.xlives.bb.5", "com.robotea.ste.xlives.bb.8", "com.robotea.ste.xlives.bb.10", "com.robotea.ste.xlives.bb.12", "com.robotea.ste.xlives.bb.15", "com.robotea.ste.xlives.bb.20", "com.robotea.ste.xlives.bb.25", "com.robotea.ste.xlives.bb.30",
        "com.robotea.ste.xlives.cc.2", "com.robotea.ste.xlives.cc.3","com.robotea.ste.xlives.cc.5", "com.robotea.ste.xlives.cc.8", "com.robotea.ste.xlives.cc.10", "com.robotea.ste.xlives.cc.12", "com.robotea.ste.xlives.cc.15", "com.robotea.ste.xlives.cc.20", "com.robotea.ste.xlives.cc.25", "com.robotea.ste.xlives.cc.30",
        "com.robotea.ste.xlives.dd.2", "com.robotea.ste.xlives.dd.3","com.robotea.ste.xlives.dd.5", "com.robotea.ste.xlives.dd.8", "com.robotea.ste.xlives.dd.10", "com.robotea.ste.xlives.dd.12", "com.robotea.ste.xlives.dd.15", "com.robotea.ste.xlives.dd.20", "com.robotea.ste.xlives.dd.25", "com.robotea.ste.xlives.dd.30",
        "com.robotea.ste.xlives.ee.2", "com.robotea.ste.xlives.ee.3","com.robotea.ste.xlives.ee.5", "com.robotea.ste.xlives.ee.8", "com.robotea.ste.xlives.ee.10", "com.robotea.ste.xlives.ee.12", "com.robotea.ste.xlives.ee.15", "com.robotea.ste.xlives.ee.20", "com.robotea.ste.xlives.ee.25", "com.robotea.ste.xlives.ee.30"]
    public static let store = IAPHelper(productIds: IAPProducts.productIdentifiers)
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    
    var products :[SKProduct]? = nil
    
    override init(){
        
        super.init()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        load()
        bcanMakePayments = IAPHelper.canMakePayments()
    }
    
    func canMakePayments()->Bool
    {
        return self.bcanMakePayments
    }
    
    
    func updateData(xLivesSteeperValue:Int, invulnerabilitySteeperValue:Int, timeSteeperValue:Int)
    {
        self.xLivesSteeperValue = xLivesSteeperValue
        self.invulnerabilitySteeperValue = invulnerabilitySteeperValue
        self.timeSteeperValue = timeSteeperValue
        
        self.bcanMakePayments = IAPHelper.canMakePayments()
    }
    
    func xLivesDescription()->String
    {
        if (self.bcanMakePayments){
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: self.localeIdentifier)
            let price = formatter.string(from: self.xLivesPriceValue as NSNumber)
            return String.init(format: "%@\n%@", arguments: [ self.xLivesLine, price! ])
        }
        else {
            return String.init(format: "%@\nNot Available", arguments: [ self.xLivesLine ])
        }
    }
    func xLivesPrice()->String
    {
        if (!self.bcanMakePayments) {
            return "NA"
        }
        else if ( self.xLivesSteeperValue > 0 ){
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: self.localeIdentifier)
            let dateString = formatter.string(from: Double(self.xLivesSteeperValue) * self.xLivesPriceValue as NSNumber)!
            return dateString
        }
        else {
            return ""
        }
    }
    func invulnerabilityDescription()->String
    {
        if (self.bcanMakePayments){
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: self.localeIdentifier)
            let price = formatter.string(from: self.invulnerabilityPriceValue as NSNumber)
            return String.init(format: "%@\n%@", arguments: [ self.invulnerabilityLine, price! ])
        }
        else {
            return String.init(format: "%@\nNot Available", arguments: [ self.invulnerabilityLine ])
        }
    }
    func invulnerabilityPrice()->String
    {
        if (!self.bcanMakePayments) {
            return "NA"
        }
        else if ( self.invulnerabilitySteeperValue > 0 ){
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: self.localeIdentifier)
            let dateString =  formatter.string(from: Double(self.invulnerabilitySteeperValue) * self.invulnerabilityPriceValue as NSNumber)!
            return dateString
        }
        else {
            return ""
        }
    }

    func timeDescription()->String
    {
        if (self.bcanMakePayments){
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: self.localeIdentifier)
            let price = formatter.string(from: self.timePriceValue as NSNumber)
            return String.init(format: "%@\n%@", arguments: [ self.timeLine, price! ])
        }
        else {
            return String.init(format: "%@\nNot Available", arguments: [ self.timeLine ])
        }
    }
    func timePrice()->String
    {
        if (!self.bcanMakePayments) {
            return "NA"
        }
        else if ( self.timeSteeperValue > 0 ){
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: self.localeIdentifier)
            let dateString = formatter.string(from: Double(self.timeSteeperValue) * self.timePriceValue as NSNumber)!
            return dateString
        }
        else {
            return ""
        }
    }
    func total()->String
    {
        if (!self.bcanMakePayments) {
            return "NA"
        }
        else {
            let price = Double(invulnerabilitySteeperValue) * self.invulnerabilityPriceValue + Double(xLivesSteeperValue) * self.xLivesPriceValue + Double(timeSteeperValue) * self.timePriceValue as NSNumber
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: self.localeIdentifier)
            return formatter.string(from: price)!
        }
    }
    
    func xlives()->Int
    {
        return self.XExtraLivesInIAP
    }

    func load() {
        
        var s:String
        var filePath:URL?
        
        filePath = URL(fileURLWithPath:NSHomeDirectory()).appendingPathComponent("Documents")
        filePath = filePath?.appendingPathComponent( "IAPProducts" )
        
        do {
            try s = String.init(contentsOf: filePath!)
        } catch let error as NSError {
            
            NSLog("\(error.localizedDescription)")
            return
        }
        let sa:[String] = s.components(separatedBy: "\n" )
        if ( sa.count != 8 ) {
            
            NSLog("Error while opening file data iapproducts inconsistency")
            return
        }
        self.xLivesLine = sa[0]
        self.invulnerabilityLine = sa[2]
        self.timeLine = sa[4]
        self.xLivesPriceValue = Double(sa[1])!
        self.invulnerabilityPriceValue = Double(sa[3])!
        self.timePriceValue = Double(sa[5])!
        self.localeIdentifier = sa[6]
        self.XExtraLivesInIAP = Int(sa[7])!
    }
    
    
    func save(){
        
        let s:String = String.init(format: "%@\n%f\n%@\n%f\n%@\n%f\n%@\n%i",
                                   self.xLivesLine,
                                   self.xLivesPriceValue,
                                   self.invulnerabilityLine,
                                   self.invulnerabilityPriceValue,
                                   self.timeLine,
                                   self.timePriceValue,
                                   self.localeIdentifier,
                                   self.XExtraLivesInIAP
                                   )
        
        var filePath:URL?
        do {
            filePath = URL(fileURLWithPath:NSHomeDirectory()).appendingPathComponent("Documents")
            let fileManager = FileManager.default
            var isDir : ObjCBool = true
            if !fileManager.fileExists(atPath: (filePath?.path)!, isDirectory:&isDir) {
                // file does not exist
                try fileManager.createDirectory(at : filePath!,
                                                withIntermediateDirectories: false,
                                                attributes:  nil)
            }
            
        } catch let error as NSError {
            
            NSLog("\(error.localizedDescription)")
        }
        do {
            filePath = filePath?.appendingPathComponent( "IAPProducts" )
            try s.write(to: filePath!, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            NSLog("\(error.localizedDescription)")
        }
        
    }
    
    public func requestProducts(completionHandler: @escaping IAPProductsRequestCompletionHandler) {
        IAPProducts.store.requestProducts{success, products in
            if success {
                self.products = products!
                self.updatePriceList()
            }
            completionHandler(success)
        }
    }

    public func buyProducts( xLives:Int, invulnerability:Int, extraTime:Int, completionHandler: @escaping IAPProductsRequestCompletionHandler) {

        var xLivesVal = xLives
        var invulnerabilityVal = invulnerability
        var extraTimeVal = extraTime
        var gsuccess = true
        if (xLivesVal==0 && invulnerabilityVal==0 && extraTimeVal==0) {
            completionHandler(false)
            return
        }
        let foundXLivesProduct =  products?.first(where:{$0.productIdentifier.hasPrefix(IAPProducts.XExtraLivesKey)})
        if (xLivesVal > 0 && foundXLivesProduct != nil) {
            IAPProducts.store.buyProduct(foundXLivesProduct!, quantity: xLivesVal){success, date, productIdentifier, quantity   in
                if success {
                    self.updateProduct(productId: IAPProducts.XExtraLivesKey, quantity: quantity, tranDate:date)
                    //Analytics.logEvent("buy_xlives", parameters: ["quantity":quantity])
                }
                else {
                    gsuccess = false
                }
                xLivesVal = 0;
                if (xLivesVal==0 && invulnerabilityVal==0 && extraTimeVal==0) {
                    completionHandler(gsuccess)
                }
            }
        }
        let foundInvulnerabilityProduct =  products?.first(where:{$0.productIdentifier == IAPProducts.InvulnerabilityKey})
        if (invulnerabilityVal > 0 && foundInvulnerabilityProduct != nil) {
            IAPProducts.store.buyProduct(foundInvulnerabilityProduct!, quantity: invulnerabilityVal){success, date, productIdentifier, quantity   in
                if success {
                    self.updateProduct(productId: IAPProducts.InvulnerabilityKey, quantity: quantity, tranDate:date)
                    //Analytics.logEvent("buy_invulnerability", parameters: ["quantity":quantity])
                }
                else {
                    gsuccess = false
                }
                invulnerabilityVal = 0;
                if (xLivesVal==0 && invulnerabilityVal==0 && extraTimeVal==0) {
                    completionHandler(gsuccess)
                }
            }
        }
        let foundExtraTimeProduct =  products?.first(where:{$0.productIdentifier == IAPProducts.ExtraTimeKey})
        if (extraTimeVal > 0 && foundExtraTimeProduct != nil) {
            IAPProducts.store.buyProduct(foundExtraTimeProduct!, quantity: extraTimeVal){success, date, productIdentifier, quantity   in
                if success {
                    self.updateProduct(productId: IAPProducts.ExtraTimeKey, quantity: quantity, tranDate:date)
                    //Analytics.logEvent("buy_time", parameters: ["quantity":quantity])
                }
                else {
                    gsuccess = false
                }
                extraTimeVal = 0;
                if (xLivesVal==0 && invulnerabilityVal==0 && extraTimeVal==0) {
                    completionHandler(gsuccess)
                }
            }
        }

        
    }
    
    func updatePriceList(){
        for p in self.products! {
            self.localeIdentifier = p.priceLocale.identifier
            if (p.productIdentifier.hasPrefix(IAPProducts.XExtraLivesKey)) {
                self.xLivesPriceValue = Double(p.price.floatValue)
                self.xLivesLine = p.localizedTitle
                let sa:[String] = p.productIdentifier.components(separatedBy: "." )
                self.XExtraLivesInIAP = Int(sa[5])!
            }
            else if (p.productIdentifier == IAPProducts.InvulnerabilityKey) {
                self.invulnerabilityPriceValue = Double(p.price.floatValue)
                self.invulnerabilityLine = p.localizedTitle
            }
            else if (p.productIdentifier == IAPProducts.ExtraTimeKey) {
                self.timePriceValue = Double(p.price.floatValue)
                self.timeLine = p.localizedTitle
            }
        }
        self.save()
    }
    
    func updateProduct( productId:String, quantity:Int, tranDate:Date?){
     
        if (productId.hasPrefix(IAPProducts.XExtraLivesKey)) {
            var oldValue = KeychainService.loadXLives()
            if (oldValue == nil) {
                oldValue = 0
            }
            KeychainService.saveXLives(value: oldValue! + quantity * self.XExtraLivesInIAP)
        }
        if (productId == IAPProducts.ExtraTimeKey) {
            var oldValue = KeychainService.loadExtraTime()
            if (oldValue == nil) {
                oldValue = 0
            }
            KeychainService.saveExtraTime(value: oldValue! + quantity)
            
        }
        if (productId == IAPProducts.InvulnerabilityKey) {
            var oldValue = KeychainService.loadInvulnerability()
            if (oldValue == nil) {
                oldValue = 0
            }
            KeychainService.saveInvulnerability(value: oldValue! + quantity)
        }
    }
    
    func getLastError() -> String?
    {
        return IAPProducts.store.getLastError()
    }
}



