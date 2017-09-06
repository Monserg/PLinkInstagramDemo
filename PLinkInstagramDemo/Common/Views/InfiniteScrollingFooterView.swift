//
//  InfiniteScrollingFooterView.swift
//  PLinkInstagramDemo
//
//  Created by msm72 on 06.09.17.
//  Copyright © 2017 RemoteJob. All rights reserved.
//

import UIKit
import SnapKit

class InfiniteScrollingFooterView: UICollectionReusableView {
    // MARK: IBOutlets
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()

        prepareConstrains()
    }
   
    
    // MARK: - Custom Functions
    func prepareConstrains() {
        activityIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        messageLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(0)
        }
    }
}
