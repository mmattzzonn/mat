//
//  ExtendView.swift
//  Songstagram
//
//  Created by Song on 2018. 7. 24..
//  Copyright © 2018년 Song. All rights reserved.
//

import UIKit

class ExtendView: UIView {

    var canRefresh: Bool = false
    var beginLoading: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 0.8
        self.layer.borderColor = UIColor.black.cgColor
    }

    func begin() {
        beginLoading = true
        self.beginRotationAnimation()
        self.alpha = 1.0
    }

    func finish() {
        beginLoading = false
        self.alpha = 0.0
    }

    func update(rate: CGFloat) {
        self.alpha = rate
    }
    
    private func beginRotationAnimation() {
        UIView.animate(withDuration: 0.4, delay: 0.05, options: .curveEaseOut, animations: {
            self.transform = self.transform.rotated(by: .pi)
        }) { (completion) in
            if self.beginLoading {
                self.beginRotationAnimation()
            }
        }
    }
}
