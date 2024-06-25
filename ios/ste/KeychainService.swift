//
//  KeychainService.swift
//  ste
//
//  Created by Zdeněk Skulínek on 01.02.17.
//  Copyright © 2017 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import Security

// Constant Identifiers
let userAccount = "AuthenticatedUserWlaatchek"



/**
 *  User defined keys for new entry
 *  Note: add new keys for new secure item and use them in load and save methods
 */

let invulnerabilityKey = "ychTyL94-invulnerability"
let xLivesKey = "85ycHtyL4-xLives"
let extraTimeKey = "85iChtiL-extraTime"

// Arguments for the keychain queries
let kSecClassValue = NSString(format: kSecClass)
let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

public class KeychainService: NSObject {
    
    /**
     * Exposed methods to perform save and load queries.
     */
    
    public class func saveInvulnerability( value: Int) {
        self.save(service: invulnerabilityKey as NSString, value: value)
    }
    
    public class func loadInvulnerability() -> Int? {
        return self.load(service: invulnerabilityKey as NSString)
    }
    public class func saveXLives( value: Int) {
        self.save(service: xLivesKey as NSString, value: value)
    }
    
    public class func loadXLives() -> Int? {
        return self.load(service: xLivesKey as NSString)
    }
    public class func saveExtraTime( value: Int) {
        self.save(service: extraTimeKey as NSString, value: value)
    }
    
    public class func loadExtraTime() -> Int? {
        return self.load(service: extraTimeKey as NSString)
    }
    
    /**
     * Internal methods for querying the keychain.
     */
    
    private class func save(service: NSString, value: Int) {
        
        var vValue = value
        let dataFromString: NSData = NSData(bytes: &vValue, length: MemoryLayout<Int>.size )
        
        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, dataFromString], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
        
        // Delete any existing items
        SecItemDelete(keychainQuery as CFDictionary)
        
        // Add the new keychain item
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }
    
    private class func load(service: NSString) -> Int? {
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
        
        var dataTypeRef :AnyObject?
        
        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: Int? = nil
        
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? NSData {
                if ( retrievedData.length == MemoryLayout<Int>.size ) {
                    var vValue : Int = 0
                    
                    retrievedData.getBytes(&vValue, length: MemoryLayout<Int>.size)
                    contentsOfKeychain = vValue
                }
            }
        } 
        
        return contentsOfKeychain
    }
}
