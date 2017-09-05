//
//  FeedShowInteractor.swift
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

// MARK: - Business Logic protocols
protocol FeedShowBusinessLogic {
    func loadFeed(withRequestModel requestModel: FeedShowModels.Feed.RequestModel)
}

protocol FeedShowDataStore {
    var feed: Feed! { get set }
}

class FeedShowInteractor: FeedShowBusinessLogic, FeedShowDataStore {
    // MARK: - Properties
    var presenter: FeedShowPresentationLogic?
    var worker: FeedShowWorker?
    
    var feed: Feed!
    
    
    // MARK: - Business logic implementation
    func loadFeed(withRequestModel requestModel: FeedShowModels.Feed.RequestModel) {
        worker = FeedShowWorker()
        worker?.doSomeWork()
        
        var text: String?
        
        if feed.comments > 0 {
            text = FMDBManager.shared.commentLoad(withParameters: (nil, feed.codeID))?.text
        }
        
        let responseModel = FeedShowModels.Feed.ResponseModel(feedDisplayed: (feed, text ?? ""))
        presenter?.prepareToDisplayFeedComment(fromResponseModel: responseModel)
    }
}