//
//  APIManager.swift
//  Songstagram
//
//  Created by Song on 2018. 7. 19..
//  Copyright © 2018년 Song. All rights reserved.
//

import Foundation

class APIManager {

    static let shared = APIManager()

    private init() {}

    class func requestURL(url: URL, onSuccess: @escaping(Data) -> Void, onFailure: @escaping(Error) -> Void){
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        session.configuration.timeoutIntervalForRequest = 20.0
        session.configuration.timeoutIntervalForResource = 30.0
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                let result = data
                onSuccess(result!)
            }
        })
        task.resume()
    }
}

