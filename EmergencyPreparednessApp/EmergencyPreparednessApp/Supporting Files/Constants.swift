//
//  Constants.swift
//  EmergencyPreparednessApp
//
//  Created by Jubin Jose on 2017-10-18.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit

class Constants {
    static let AcceptedTermsAndConditions = "True"
    static let vehicleCollisionTitle = "Vehicle Collision"
    static let buildingIssuesTitle = "Building Issues"
    static let personalSafetyTitle = "Personal Safety"
    static let reportCrimeTitle = "Security"
    static let socialMediaTitle = "Social Media"
    static let roadsWeatherTitle = "Weather and Roads"
    static let whenToCallTitle = "When to Call 911"
    static let usingAppTitle = "Using the App"
    static let notificationTitle = "Notification History"
    static let powerTitle = "Power Loss"
    static let workplaceTitle = "Workplace Violence"
    static let medicalTitle = "Medical"
    static let odoursTitle = "Odours"
    static let bombTitle = "Bomb threats or Suspicious packages"
    static let civilTitle = "Civil Unrest"
    static let fireTitle = "Fire"
    static let emergencyTitle = "Emergency Numbers"
    static let mentalhealth = "Mental Health"
    static let emergencyGuideTitle = "EMERGENCY GUIDE"
    static let termsAndConditions = "Terms and Conditions"
    static let alertsListId = "AlertList"
    
    static let alertItemId = "AlertItem"
    
    static let alertsCount:Int = 10
    
    static let pushNotificationReceived = "ReceivedPushNotification"
    
    static let renewalNotification = "RenewEmailSubscription"
    
    static let subscriptionRenewalInterval = 300000.0 //In seconds. TODO: Set this to one year
    
    static let emailValidationURL = "https://api.sendgrid.com/v3/mail/send"
    
    static let sendgridAPIKey = "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"
    
    static let emailValidationTokenKey = "EmailValidationToken"
    
    // test environment
    //static let loginURL = "https://te-mynsid.novascotia.ca/auth/eng/l/authenticate"
    
    // production environment
    static let loginURL = "https://mynsid.novascotia.ca/auth/eng/l/authenticate"
    
    static let BMSAppGUID = "4a1c6648-9cc2-4703-af50-6fa503f84dec"
    
    static let BMSClientSecret = "811d26d3-3678-46db-8ece-ca009208d7e4"
    
    static let popupMessages = ["When the threat is to the structure and or could cause harm to those inside.","When the threat is external and the structure is the safest place to be.","When the threat is to people, avoid the threat by any means. Run, Hide, Fight."]
}
