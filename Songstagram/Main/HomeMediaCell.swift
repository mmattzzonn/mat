//
//  HomeMediaCell.swift
//  Songstagram
//
//  Created by Song on 2018. 7. 22..
//  Copyright © 2018년 Song. All rights reserved.
//

import UIKit

class HomeMediaCell: UICollectionViewCell {

    @IBOutlet var mediaImageView: UIImageView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var likeCountLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    
    func willDisplayContent(cellContent: InstaMedia) {

        containerView.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        containerView.layer.borderWidth = 0.5

        locationLabel.text = cellContent.location?.name

        if let likeCount = cellContent.likeCount  {
            likeCountLabel.text = String(likeCount)
        }

        if let image = cellContent.images?.first, let imageURL = image.thumbnailImageURL, let url = URL(string: imageURL) {
            CacheImageManager.shared.loadImage(url: url, imageType: .instaThumb) {
                self.mediaImageView.image = $0
            }
        }
    }
}
