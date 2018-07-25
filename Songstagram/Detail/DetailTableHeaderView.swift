//
//  DetailTableHeaderView.swift
//  Songstagram
//
//  Created by Song on 2018. 7. 22..
//  Copyright © 2018년 Song. All rights reserved.
//

import UIKit

class DetailTableHeaderView: UIView {
    
    @IBOutlet var imageScrollView: UIScrollView!

    func updateHeaderView(images: [InstaImage]) {

        self.layoutIfNeeded()

        let imageRect = self.imageScrollView.bounds

        self.imageScrollView.contentSize = CGSize(width: imageRect.width * CGFloat(images.count),
                                                  height: imageRect.height)

        if images.count == 1 {
            self.imageScrollView.isScrollEnabled = false
        }

        for (index, image) in images.enumerated() {
            if let imageString =  image.largeImageURL, let imageURL = URL(string: imageString) {
                CacheImageManager.shared.loadImage(url: imageURL, imageType: .instaLarge, completion: {
                    let imageView = UIImageView(image: $0)
                    imageView.clipsToBounds = true
                    imageView.contentMode = .scaleAspectFill
                    self.imageScrollView.addSubview(imageView)
                    imageView.frame = CGRect(x: CGFloat(index) * imageRect.width,
                                             y: 0.0,
                                             width: imageRect.width,
                                             height: imageRect.height)
                })
            }
        }
    }
}
