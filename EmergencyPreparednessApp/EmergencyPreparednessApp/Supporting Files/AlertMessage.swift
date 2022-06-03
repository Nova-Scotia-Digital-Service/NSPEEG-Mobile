//
//  AlertMessage.swift
//  EmergencyPreparednessApp
//
//  Created by Jubin Jose on 2017-10-23.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

class AlertMessage: NSObject, NSCoding {
    var alertId:String?
    var content:String?
    var receivedDate:String?
    
    init(content:String?, alertId:String?, receivedDate:String?){
        super.init()
        self.content = content
        self.alertId = alertId
        self.receivedDate = receivedDate
    }
    required convenience init?(coder decoder: NSCoder) {
            guard let content = decoder.decodeObject(forKey: "content") as? String,
            let alertId = decoder.decodeObject(forKey: "alertId") as? String,
            let receivedDate = decoder.decodeObject(forKey: "receivedDate") as? String
            else { return nil }
        
        self.init(
            content: content,
            alertId: alertId,
            receivedDate: receivedDate
        )
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.content, forKey: "content")
        aCoder.encode(self.alertId, forKey: "alertId")
         aCoder.encode(self.receivedDate, forKey: "receivedDate")
    }
}
