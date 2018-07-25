//
//  CacheImageManager.swift
//  Songstagram
//
//  Created by Song on 2018. 7. 22..
//  Copyright © 2018년 Song. All rights reserved.
//

import UIKit

enum CacheImageType: String {
    case instaThumb = "__insta__thumb"
    case instaLarge = "__insta__large"
    case googleReview

}

typealias Completion = (UIImage?) -> ()

class CacheImageManager {

    static let shared = CacheImageManager()
    var memoryCache = NSMutableDictionary(capacity: 100)
    var cacheImageType: CacheImageType!

    private init() {
        let urlCache = URLCache(memoryCapacity: 10 * 1024 * 1024, diskCapacity: 50 * 1024 * 1024, diskPath: nil)
        URLCache.shared = urlCache
    }

    private func loadFromDisk(key: String) -> UIImage? {
        if let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let imagePath = "\(path)/\(key.split(separator: "/").last!)"
            return UIImage(contentsOfFile: imagePath)
        }
        return nil
    }

    private func saveToDisk(image: UIImage, key: String) {
        DispatchQueue.global(qos: .background).async {
            if let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
                let imagePath = "\(path)/\(key.split(separator: "/").last!)"
                try! UIImagePNGRepresentation(image)?.write(to: URL(fileURLWithPath: imagePath))
            }
        }
    }

    func loadImage(url: URL, imageType: CacheImageType, completion: @escaping Completion) {
        cacheImageType = imageType
        var image: UIImage?
        var key = ""
        let imageURLcomponents = url.absoluteString.split(separator: "/")

        if imageType == .googleReview {
            key = self.makeGoogleReviewrImageKeyString(keySequence: imageURLcomponents)
        } else {
            key = String(imageURLcomponents.last!) + imageType.rawValue
        }

        //find cache
        if let cacheImageManager = memoryCache.object(forKey: key) as? UIImage {
            image = cacheImageManager
        } else {
            image = self.loadFromDisk(key: key)
        }

        //failed get cache from local, load from URL
        if image == nil {
            guard let imageData = try? Data(contentsOf: url) else { return }

            DispatchQueue.global(qos: .userInteractive).async {
                let urlImage = UIImage.init(data: imageData)
                DispatchQueue.main.async {
                    completion(urlImage)

                    //save cache
                    if let saveImage = urlImage {
                        self.saveToDisk(image: saveImage, key: key)
                        self.memoryCache.setObject(saveImage, forKey: key as NSCopying)
                    }
                }
            }
        } else {
            completion(image)
        }
    }

    private func makeGoogleReviewrImageKeyString(keySequence: [String.SubSequence]) -> String {
        var key = ""

        if keySequence.count > 2 {
            key = String(keySequence[keySequence.count - 3] + keySequence[keySequence.count - 2])
        }
        return key
    }
}
