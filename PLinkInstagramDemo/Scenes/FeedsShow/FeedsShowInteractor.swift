//
//  FeedsShowInteractor.swift
//  PLinkInstagramDemo
//
//  Created by msm72 on 01.09.17.
//  Copyright (c) 2017 RemoteJob. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

// MARK: - Business Logic protocols
protocol FeedsShowBusinessLogic {
    func doSomething(request: FeedsShowModels.Something.RequestModel)
}

protocol FeedsShowDataStore {
    //var name: String { get set }
}

class FeedsShowInteractor: FeedsShowBusinessLogic, FeedsShowDataStore {
    // MARK: - Properties
    var presenter: FeedsShowPresentationLogic?
    var worker: FeedsShowWorker?
    //var name: String = ""
    
    
    // MARK: - Business logic implementation
    func doSomething(request: FeedsShowModels.Something.RequestModel) {
        worker = FeedsShowWorker()
        worker?.doSomeWork()
        
        let responseModel = FeedsShowModels.Something.ResponseModel()
        presenter?.presentSomething(response: responseModel)
    }
}
