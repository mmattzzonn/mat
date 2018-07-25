//
//  NavigationBar.swift
//  Songstagram
//
//  Created by Song on 2018. 7. 23..
//  Copyright © 2018년 Song. All rights reserved.
//

import UIKit

class NavigationBar: UINavigationBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.barTintColor = UIColor.white
        self.isTranslucent = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        self.isUserInteractionEnabled = self.point(inside: point, with: event)
        return super.hitTest(point, with: event)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        for view in self.subviews {
            if NSStringFromClass(type(of: view)).contains("ContentView") {
                view.layoutMargins = UIEdgeInsetsMake(0, 5.0, 0, 5.0)
            }

        }
    }
}

