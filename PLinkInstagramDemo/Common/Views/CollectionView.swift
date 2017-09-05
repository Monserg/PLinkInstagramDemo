//
//  MSMCollectionView.swift
//  OmnieCommerce
//
//  Created by msm72 on 18.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class CollectionView: UICollectionView {
    // MARK: - Properties
    var hasHeaders = false

    var collectionViewControllerManager: CollectionViewControllerManager! {
        didSet {
            self.delegate = collectionViewControllerManager
            self.dataSource = collectionViewControllerManager
        }
    }
    
    var heightRatio: CGFloat {
        let screenHeight = (UIApplication.shared.statusBarOrientation.isPortrait) ? UIScreen.main.bounds.height : UIScreen.main.bounds.width
        return screenHeight / 667.0
    }
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.backgroundColor = UIColor.clear
        self.showsVerticalScrollIndicator = true
        self.showsHorizontalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
        
    deinit {
        print("\(type(of: self)): \(#function) run in [line \(#line)]")
    }
}
