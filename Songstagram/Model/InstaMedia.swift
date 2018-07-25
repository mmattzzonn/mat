//
//  InstaMedia.swift
//  Songstagram
//
//  Created by Song on 2018. 7. 22..
//  Copyright © 2018년 Song. All rights reserved.
//

import Foundation

enum InstaMediaType {
    case picture, video
}

class InstaMedia {

    var type: InstaMediaType?
    var likeCount: Int?
    var ownerName: String?
    var date: String?
    var identifier: String?
    var location: InstaLocation?
    var images: [InstaImage]?

    convenience init(_ dict: [String: Any]) {
        self.init()
        if let mediaTypeString = dict["type"] as? String {
            type = mediaType(mediaTypeString)
        }

        if let likes = dict["likes"] as? [String: Int] {
            likeCount = likes["count"]
        }

        if let owner = dict["user"] as? [String: String] {
            ownerName = owner["username"]
        }

        date = dict["created_time"] as? String

        if let carousel = dict["carousel_media"] as? [[String: Any]] {
            images = carousel.map{ InstaImage($0["images"] as! [String : Any]) }
        } else if let imageURLs = dict["images"] as? [String: Any] {
            images = [InstaImage(imageURLs)]
        }

        identifier = dict["id"] as? String

        if let locationDict = dict["location"] as? [String: Any] {
            location = InstaLocation(dict: locationDict)
        }
    }

    func mediaType(_ typeString: String) -> InstaMediaType {

        if typeString == "video" {
            return .video
        }
        return .picture
    }

}
