//
//  InstaImage.swift
//  Songstagram
//
//  Created by Song on 2018. 7. 24..
//  Copyright © 2018년 Song. All rights reserved.
//

import Foundation

class InstaImage {
    var thumbnailImageURL: String?
    var largeImageURL: String?

    convenience init(_ dict: [String: Any]) {
        self.init()

        if let resolution = dict["low_resolution"] as? [String: Any] {
            if let url = resolution["url"] as? String {
                thumbnailImageURL = url
            }
        }

        if let resolution = dict["standard_resolution"] as? [String: Any] {
            if let url = resolution["url"] as? String {
                largeImageURL = url
            }
        }
    }
}
