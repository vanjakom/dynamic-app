//
//  DynamicAppClient.swift
//  dynamic-app
//
//  Created by Vanja Komadinovic on 9/28/16.
//  Copyright © 2016 mungolab.com. All rights reserved.
//

import Foundation

class DynamicAppResponse {
    let config: Dictionary<String, AnyObject>
    let state: Dictionary<String, AnyObject>
    let action: String?
    let render: Element
    
    init(dictionary: Dictionary<String,AnyObject>) {
        if let config = dictionary["config"] as? Dictionary<String,AnyObject> {
            self.config = config
        } else {
            self.config = Dictionary()
        }
        if let state = dictionary["state"] as? Dictionary<String, AnyObject> {
            self.state = state
        } else {
            self.state = Dictionary()
        }
        if let action = dictionary["action"] as? String {
            self.action = action
        } else {
            self.action = nil
        }
        if let renderDictionary = dictionary["render"] as? Dictionary<String, AnyObject> {
            self.render = ElementUIFactory.createElement(elementDictionary: renderDictionary)
        } else {
            let renderArray = dictionary["render"] as! Array<Dictionary<String, AnyObject>>
            self.render = ElementUIFactory.createListElements(elementsDictionary: renderArray)
        }
    }
}

class DynamicAppClient {
    class func request(appUri: String, action: String, state: Dictionary<String, AnyObject>, handler: @escaping (_ response: DynamicAppResponse?) -> Void) -> Void {
        let uri = appUri + "/" + action
        
        var request: Dictionary<String, AnyObject> = Dictionary()
        request["state"] = state as AnyObject?
        
        asyncApiRequest(uri, request: request) { (response) in
            if let response = response {
                DispatchQueue.main.async {
                    handler(DynamicAppResponse(dictionary: response))
                }
            } else {
                DispatchQueue.main.async {
                    handler(nil)
                }
            }
        }
    }
    
    private class func asyncApiRequest(_ url: String, request: Dictionary<String, AnyObject>, callback: @escaping (Dictionary<String, AnyObject>?) -> Void) -> Void {
        
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: URL(string: url)! as URL)
        
        urlRequest.httpMethod = "POST"
        urlRequest.timeoutInterval = 10.0
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data: Data
        do {
            try data = JSONSerialization.data(withJSONObject: request, options: JSONSerialization.WritingOptions())
        } catch _ {
            callback(nil)
            return
        }
        urlRequest.httpBody = data as Data
        
        URLSession.shared.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            guard let _: NSData = data as NSData?, let _: URLResponse = response , error == nil else {
                callback(nil)
                return
            }
            
            do {
                let responseDict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as? Dictionary<String, AnyObject>
                callback(responseDict)
            } catch {
                callback(nil)
            }}.resume()
    }
}
