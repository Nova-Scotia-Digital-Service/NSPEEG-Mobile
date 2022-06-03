//
//  EmailValidationService.swift
//  EmergencyPreparednessApp
//
//  Created by Jubin Jose on 2017-10-26.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit

protocol EmailValidationServiceDelegate :class{
    func didSendEmail(sender: EmailValidationService)
}

class EmailValidationService: NSObject {
    var emailServiceEndPoint: String = Constants.emailValidationURL
    weak var delegate:EmailValidationServiceDelegate?
    let headers = [
        "Authorization": "Bearer \(Constants.sendgridAPIKey)",
        "content-type": "application/json",
    ]
    
    public func validateEmail(emailId:String?, token:String, completion:@escaping (_ success:Bool)->Void){
        if let emailId = emailId{
            AppController.shared.saveValidationToken(token: token)
            let personalisations = ["to":[["email":emailId]]]
            let contentBody = [["type":"text/plain", "value":"Your verifircation token is \(token)"]]
            let body = ["personalizations" : [personalisations],
                        "from":["email":"do-not-reply@novascotia.ca"],
                        "subject": "Your ServICE Verification Token",
                        "content": contentBody] as [String : Any]
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                let str = String(data: jsonData,
                                 encoding: .utf8)
                
                print(str!)
            } catch {
                print(error.localizedDescription)
            }
            
            guard let url = URL(string: emailServiceEndPoint) else {
                print("Error: cannot create URL")
                return
            }
            do{
                var urlRequest = URLRequest(url: url,
                                            cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
                let postData = try JSONSerialization.data(withJSONObject: body)
                urlRequest.httpMethod = "POST"
                urlRequest.allHTTPHeaderFields = headers
                urlRequest.httpBody = postData
                
                // set up the session
                let session = URLSession.shared
                let dataTask = session.dataTask(with: urlRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
                    if (error != nil) {
                        print(error!)
                        completion(false)
                    } else {
                        let httpResponse = response as? HTTPURLResponse
                        print(httpResponse!)
                        completion(true)
                    }
                })
                dataTask.resume()
                
            }catch let error as NSError{
                print(error)
            }
        }
    }
}
