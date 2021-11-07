//
//  HTTPClient.swift
//  simplyutil
//
//  Created by Omri Shapira on 07/11/2021.
//

import Foundation

class HTTPClient {
    @discardableResult func getRequest(_ url: String) -> AnyObject {
        return Data() as AnyObject
    }
    
    @discardableResult func postRequest(_ url: String, body: String) -> AnyObject {
        return Data() as AnyObject
    }
    
    func downloadRates(_ url: String) -> Data? {
        let url = NSURL(string: url)
        
        if let absoluteUrl = url?.absoluteURL {
            if let data = try? Data(contentsOf: absoluteUrl) {
                return data
            }
        }
        
        
        return Data()
    }
}
