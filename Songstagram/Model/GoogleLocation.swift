//
//  GoogleLocation.swift
//  Songstagram
//
//  Created by Song on 2018. 7. 22..
//  Copyright © 2018년 Song. All rights reserved.
//

import Foundation

class GoogleLocation {
    var identifier: String?
    var lat: String?
    var lng: String?
    var name: String?
    var address: String?

    init(dict: [String: Any]) {
        identifier = dict["place_id"] as? String
        lat = dict["latitude"] as? String
        lng = dict["longitude"] as? String
        name = dict["name"] as? String
        address = dict["formatted_address"] as? String
    }
}
