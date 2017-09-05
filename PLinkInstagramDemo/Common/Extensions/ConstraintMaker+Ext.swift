//
//  ConstraintMaker+Ext.swift
//  PLinkInstagramDemo
//
//  Created by msm72 on 05.09.17.
//  Copyright © 2017 RemoteJob. All rights reserved.
//

// https://www.bountysource.com/issues/44237237-feature-request-add-aspect-ratio-helper-method


import Foundation
import SnapKit

extension ConstraintMaker {
    public func aspectRatio(_ x: Int, by y: Int, self instance: ConstraintView) {
        self.width.equalTo(instance.snp.height).multipliedBy(x / y)
    }
}
