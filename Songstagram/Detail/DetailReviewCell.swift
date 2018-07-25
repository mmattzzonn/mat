//
//  DetailReviewCell.swift
//  Songstagram
//
//  Created by Song on 2018. 7. 23..
//  Copyright © 2018년 Song. All rights reserved.
//

import UIKit

class DetailReviewCell: UITableViewCell {

    @IBOutlet var reviewerImageView: UIImageView!
    @IBOutlet var reviewerNameLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!

    func willDisplayContent(cellContent: GoogleReview) {
        if let imageString = cellContent.reviwerImageURL, let imageURL = URL(string: imageString) {
            CacheImageManager.shared.loadImage(url: imageURL, imageType: .googleReview) {
                self.reviewerImageView.image = $0
            }
        }

        if let name = cellContent.reviwerName {
            reviewerNameLabel.text = name
        }

        if let comment = cellContent.contentString {
            commentLabel.text = comment
        }
    }
}
