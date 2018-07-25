//
//  EndPoint.swift
//  Songstagram
//
//  Created by Song on 2018. 7. 21..
//  Copyright © 2018년 Song. All rights reserved.
//

import Foundation

enum EndPoint {
    case locationMedia(locationID: String)
    case userMedia
    case userInfo
    case searchArea(lat: Double, lng: Double, distance: Int)
    case tagMedia(tag: String, lastMediaID: String?, count: Int)
    case location(name: String, lat: String, lng: String)
    case review(location: String)
}

extension EndPoint {
    var urlString: String {
        switch self {
        case let .locationMedia(locationID: locationID):
            return INSTAGRAM_URL.BASEURL+"locations/\(locationID)/media/recent?access_token=\(INSTAGRAM_URL.ACCESS_TOKEN)"
        case .userMedia:
            return INSTAGRAM_URL.BASEURL+"users/self/media/recent/self?access_token=\(INSTAGRAM_URL.ACCESS_TOKEN)"
        case .userInfo:
            return INSTAGRAM_URL.BASEURL+"users/self?access_token=\(INSTAGRAM_URL.ACCESS_TOKEN)"
        case let .searchArea(lat: lat, lng: lng, distance: distance):
            return INSTAGRAM_URL.BASEURL+"media/search?access_token=\(INSTAGRAM_URL.ACCESS_TOKEN)&lat=\(lat)&lng=\(lng)&distance=\(distance)"
        case let .tagMedia(tag: tag, lastMediaID: lastMediaID, count: count):
            var urlString = INSTAGRAM_URL.BASEURL+"tags/\(tag)/media/recent?access_token=\(INSTAGRAM_URL.ACCESS_TOKEN)&count=\(count)"
            if let lastMediaID = lastMediaID {
                urlString.append("&max_tag_id=\(lastMediaID)")
            }
            return urlString
        case let .location(name: name, lat: lat, lng: lng):
            let urlString = GOOGLE_URL.BASEURL+"place/findplacefromtext/json?input=\(name)&locationbias=circle:100@\(lat),\(lng)_&inputtype=textquery&fields=\(GOOGLE_URL.LOCATION_SCOPE)&key=\(GOOGLE_URL.API_KEY)"
            return urlString
        case let .review(location: location):
            return GOOGLE_URL.BASEURL+"place/details/json?placeid=\(location)&language=kr&fields=\(GOOGLE_URL.REVIEW_SCOPE)&key=\(GOOGLE_URL.API_KEY)"
        }
    }
}
