//
//  CategoryCollectionViewCell.swift
//  OmnieCommerce
//
//  Created by msm72 on 18.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

@IBDesignable class FeedCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.snp.makeConstraints {
                $0.edges.equalTo(self).inset(UIEdgeInsetsMake(0, 0, 0, 0))
                $0.height.equalTo(self.frame.height)
                $0.width.equalTo(self.frame.width)
            }
        }
    }
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


// MARK: - ConfigureCell
extension FeedCollectionViewCell: ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath) {
        let feed = item as! Feed
        let imageLink = feed.url
        
        imageView.kf.indicatorType = .activity
        
        imageView.kf.setImage(with: ImageResource(downloadURL: URL.init(string: imageLink)!, cacheKey: imageLink),
                              placeholder: nil,
                              options: [.transition(ImageTransition.fade(1)),
                                        .processor(ResizingImageProcessor(referenceSize: imageView.frame.size,
                                                                          mode: .aspectFill))],
                              completionHandler: { image, error, cacheType, imageURL in
                                self.imageView.kf.cancelDownloadTask()
        })
    }
}
