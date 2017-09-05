//
//  Dictionary+Ext.swift
//  OmnieCommerce
//
//  Created by msm72 on 01.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation

extension Dictionary {
    mutating func merge(withDicitionary dictionary: Dictionary) {
        for (key, value) in dictionary {
            self.updateValue(value, forKey: key)
        }
    }
}
