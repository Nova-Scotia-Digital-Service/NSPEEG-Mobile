//
//  KeychainManager.swift
//  EmergencyPreparednessApp
//
//  Created by John Martino on 2019-02-01.
//  Copyright © 2019 IBM. All rights reserved.
//

import Foundation

class KeychainManager
{
    static let shared = KeychainManager()
    private init() {}
    
    func add(service: String, account: String, itemData: Data) -> Bool
    {
        let params: [CFString : Any] = [kSecValueData : itemData]
        let attributes = genericQuery(service: service, account: account, parameters: params)
        let status = SecItemAdd(attributes, nil)
        return status == noErr
    }
    
    func fetch(service: String, account: String) -> Data?
    {
        let params: [CFString : Any] = [kSecReturnData : true]
        let query = genericQuery(service: service, account: account, parameters: params)
        
        var result: AnyObject?
        let status = withUnsafeMutablePointer(to: &result) { SecItemCopyMatching(query, UnsafeMutablePointer($0)) }
        
        guard status == noErr else { return nil }
        return result as? Data
    }
    
    func exists(service: String, account: String) -> Bool
    {
        let params: [CFString : Any] = [kSecReturnData : false]
        let query = genericQuery(service: service, account: account, parameters: params)
        let status = SecItemCopyMatching(query, nil)
        return status == noErr
    }
    
    func update(service: String, account: String, itemData: Data) -> Bool
    {
        let query = genericQuery(service: service, account: account)
        let changes = [kSecValueData : itemData] as CFDictionary
        
        let status = SecItemUpdate(query, changes)
        return status == noErr
    }
    
    func delete(service: String, account: String) -> Bool
    {
        let status = SecItemDelete(genericQuery(service: service, account: account))
        return status == noErr
    }
    
    func save(key: String, service: String, account: String) -> Bool
    {
        guard let keyData = key.data(using: .utf8, allowLossyConversion: false) else { return false }
        
        if exists(service: service, account: account)
        {
            return update(service: service, account: account, itemData: keyData)
        }
        else
        {
            return add(service: service, account: account, itemData: keyData)
        }
    }
    
    private func genericQuery(service: String, account: String, parameters: [CFString : Any]? = nil) -> CFDictionary
    {
        var query: [CFString : Any] = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : service,
            kSecAttrAccount : account,
            kSecAttrAccessible : kSecAttrAccessibleWhenUnlocked,
            kSecAttrSynchronizable : true]
        
        if let params = parameters
        {
            for param in params
            {
                query[param.key] = param.value
            }
        }
        
        return query as CFDictionary
    }
}
