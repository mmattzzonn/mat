//
//  RefreshView.swift
//  Songstagram
//
//  Created by Song on 2018. 7. 25..
//  Copyright © 2018년 Song. All rights reserved.
//

import UIKit

class RefreshView: ExtendView {


    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 0.3
        self.layer.borderColor = UIColor.white.cgColor
    }

    override func update(rate: CGFloat) {

        var factor: CGFloat = rate

        self.alpha = rate

        if rate > 1.5 {
            factor = 1.5
            canRefresh = true
        } else {
            canRefresh = false
        }

        if !beginLoading {
            self.transform = CGAffineTransform(scaleX: 1.2 + factor, y: 1.2 + factor)
            self.transform = transform.rotated(by: .pi * factor)
        }
    }

    override func begin() {
        super.begin()
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}



