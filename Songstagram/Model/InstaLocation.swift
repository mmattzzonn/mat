//
//  InstaLocation.swift
//  Songstagram
//
//  Created by Song on 2018. 7. 22..
//  Copyright © 2018년 Song. All rights reserved.
//

import Foundation

class InstaLocation {
    var identifier: Double?
    var lat: Double?
    var lng: Double?
    var name: String?

    init(dict: [String: Any]) {
        identifier = dict["id"] as? Double
        lat = dict["latitude"] as? Double
        lng = dict["longitude"] as? Double
        name = dict["name"] as? String
    }
}
