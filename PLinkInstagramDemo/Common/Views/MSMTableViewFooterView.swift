//
//  MSMTableViewFooterView.swift
//  OmnieCommerce
//
//  Created by msm72 on 26.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class MSMTableViewFooterView: UIView {
    // MARK: - Properties
    @IBOutlet var view: UIView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var emptyMessageLabel: UILabel!
    @IBOutlet weak var infiniteScrollView: UIView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView! {
        didSet {
            spinner.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }
    }
    
    
    // MARK: - Class Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createFromXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        createFromXIB()
    }
    
    
    // MARK: - Class Functions
    func createFromXIB() {
        UINib(nibName: String(describing: MSMTableViewFooterView.self), bundle: Bundle(for: MSMTableViewFooterView.self)).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = frame
    }
    
    
    // MARK: - Custom Functions
    func didUpload(forItemsCount itemsCount: Int, andEmptyText emptyText: String) {
        if (itemsCount == 0) {
            emptyView.isHidden = false
            emptyMessageLabel.text = emptyText
            infiniteScrollView.isHidden = true
        } else {
            emptyView.isHidden = true
            infiniteScrollView.isHidden = false
        }
    }
}
