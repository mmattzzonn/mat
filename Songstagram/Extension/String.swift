//
//  String.swift
//  Songstagram
//
//  Created by Song on 2018. 7. 22..
//  Copyright © 2018년 Song. All rights reserved.
//

import Foundation

extension String {
    func urlEncoding() -> String {
        guard let encodingString = self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return ""
        }
        return encodingString
    }
}
