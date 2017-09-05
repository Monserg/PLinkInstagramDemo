//
//  Protocols.swift
//  PLinkInstagramDemo
//
//  Created by msm72 on 04.09.17.
//  Copyright © 2017 RemoteJob. All rights reserved.
//

import UIKit

protocol InitCellParameters {
    var cellIdentifier: String { get set }
    var cellHeight: CGFloat { get set }
}

protocol ConfigureCell {
    func setup(withItem item: Any, andIndexPath indexPath: IndexPath)
}
