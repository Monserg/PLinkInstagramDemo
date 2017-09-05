//
//  FeedShowModels.swift
//  PLinkInstagramDemo
//
//  Created by msm72 on 05.09.17.
//  Copyright (c) 2017 RemoteJob. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

// MARK: - Data models
enum FeedShowModels {
    // MARK: - Use cases
    enum Feed {
        struct RequestModel {
        }
        
        struct ResponseModel {
            let feedDisplayed: FeedDisplayed
        }
        
        struct ViewModel {
            let feedDisplayed: FeedDisplayed
        }
    }
}