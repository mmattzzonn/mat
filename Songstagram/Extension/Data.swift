//
//  Data.swift
//  Songstagram
//
//  Created by Song on 2018. 7. 23..
//  Copyright © 2018년 Song. All rights reserved.
//

import Foundation

extension Data {
    func convertJSON() -> [String: Any]? {
        if let jsonString = String(data: self, encoding: .utf8) {
            if let jsonData = try! JSONSerialization.jsonObject(with: jsonString.data(using: String.Encoding.utf8)!,
                                                                options: .allowFragments) as? [String: Any] {
                return jsonData
            }
        }
        return nil
    }
}
