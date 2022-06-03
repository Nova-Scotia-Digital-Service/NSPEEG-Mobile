//
//  KeychainManager+SignOn.swift
//  EmergencyPreparednessApp
//
//  Created by John Martino on 2019-02-01.
//  Copyright © 2019 IBM. All rights reserved.
//

import Foundation

let tokenService = "com.ibm.ServICENovaScotia.tokenService"
let tokenAccount = "com.ibm.ServICENovaScotia.tokenAccount"

let resetService = "com.nspeeg.reset.service"
let resetAccount = "com.nspeeg.reset.account"

// Change this value and the next version of the app will require a force login
let resetCompleteValue = "complete_1"

extension KeychainManager
{
    var isUserLoggedIn: Bool
    {
        return exists(service: tokenService, account: tokenAccount)
    }
    
    var token: String?
    {
        guard let tokenData = fetch(service: tokenService, account: tokenAccount) else { return nil }
        return String(data: tokenData, encoding: .utf8)
    }
    
    private func add(token: Data) -> Bool
    {
        return add(service: tokenService, account: tokenAccount, itemData: token)
    }
    
    func add(token: String) -> Bool
    {
        guard let tokenData = token.data(using: .utf8) else { return false }
        return add(token: tokenData)
    }
    
    func removeToken()
    {
        _ = delete(service: tokenService, account: tokenAccount)
    }
}

extension KeychainManager
{
    func resetRequired() -> Bool
    {
        guard exists(service: resetService, account: resetAccount) else { return true }
        guard let requiredData = fetch(service: resetService, account: resetAccount) else { return true }
        let value = String(data: requiredData, encoding: .utf8)
        return value != resetCompleteValue
    }
    
    func resetComplete()
    {
        guard let completeData = resetCompleteValue.data(using: .utf8) else { return }
        if exists(service: resetService, account: resetAccount)
        {
            _ = update(service: resetService, account: resetAccount, itemData: completeData)
        }
        else
        {
            _ = add(service: resetService, account: resetAccount, itemData: completeData)
        }
    }
}

func resetIfRequired()
{
    guard KeychainManager.shared.resetRequired() else { return }
    KeychainManager.shared.removeToken()
    KeychainManager.shared.resetComplete()
}
