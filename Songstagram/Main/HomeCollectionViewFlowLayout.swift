//
//  HomeCollectionViewFlowLayout.swift
//  Songstagram
//
//  Created by Song on 2018. 7. 22..
//  Copyright © 2018년 Song. All rights reserved.
//

import UIKit

class HomeCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare()
        let margin = sectionInset.left + sectionInset.right + minimumLineSpacing
        let size: CGFloat = ((collectionView?.bounds.width)! - margin) / 2.0
        itemSize = CGSize(width: size, height: size + 20.0)
    }
}
