//
//  GoogleReview.swift
//  Songstagram
//
//  Created by Song on 2018. 7. 23..
//  Copyright © 2018년 Song. All rights reserved.
//

import Foundation

class GoogleReview {
    var reviwerName: String?
    var reviwerImageURL: String?
    var contentString: String?

    init(dict: [String: Any]) {
        reviwerName = dict["author_name"] as? String
        reviwerImageURL = dict["profile_photo_url"] as? String
        contentString = dict["text"] as? String
    }
}
