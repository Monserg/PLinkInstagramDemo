//
//  FeedsShowViewController.swift
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

// MARK: - Input & Output protocols
protocol FeedsShowDisplayLogic: class {
    func feedsDisplay(fromViewModel viewModel: FeedsShowModels.Feeds.ViewModel)
}

class FeedsShowViewController: UIViewController {
    // MARK: - Properties
    var interactor: FeedsShowBusinessLogic?
    var router: (NSObjectProtocol & FeedsShowRoutingLogic & FeedsShowDataPassing)?
    
    var feeds = [Feed]()

    
    // MARK: - IBOutlets
    @IBOutlet weak var dataSourceEmptyView: UIView!
    
    @IBOutlet weak var collectionView: CollectionView! {
        didSet {
            collectionView.contentInset = UIEdgeInsetsMake(45, 0, 0, 0)
            collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(10, 0, 0, 0)
            
            if (collectionView.collectionViewControllerManager == nil) {
                collectionView.collectionViewControllerManager = CollectionViewControllerManager.init(withCollectionView: collectionView, andEmptyMessageText: NSLocalizedString("Feeds list is empty", comment: ""))
            }
        }
    }
    
    
    // MARK: - Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    
    // MARK: - Setup
    private func setup() {
        let viewController  =   self
        let interactor      =   FeedsShowInteractor()
        let presenter       =   FeedsShowPresenter()
        let router          =   FeedsShowRouter()
        
        viewController.interactor   =   interactor
        viewController.router       =   router
        interactor.presenter        =   presenter
        presenter.viewController    =   viewController
        router.viewController       =   viewController
        router.dataStore            =   interactor
    }
    
    
    // MARK: - Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        viewSettingsDidLoad()
    }

    
    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        // Load Feeds from FMDB
        guard Connectivity.isConnectedToInternet() else {
            self.feedsDidShow()
            return
        }
        
        // Load Feeds from API
        feeds = [Feed]()

        FMDBManager.shared.databaseClean()
        feedsDidLoad(withScrollingData: false)
    }
    
    func feedsDidLoad(withScrollingData scrollingData: Bool) {
        var parameters: [String: Any] = [ fieldCount: INSTAGRAM_IDS.INSTAGRAM_COUNT, fieldAccessToken: user!.accessToken ]
        
        if let maxID = pagination?.next_max_id {
            parameters[fieldMaxID] = maxID
        }
        
        guard Connectivity.isConnectedToInternet() else {
            feedsDidShow()
            return
        }
        
        let feedsLoadRequestModel = FeedsShowModels.Feeds.RequestModel(parameters: parameters)
        interactor?.feedsLoad(withRequestModel: feedsLoadRequestModel)
    }

    func feedsDidShow() {
        // Setting CollectionViewControllerManager
        feeds = FMDBManager.shared.feedsLoad()
        collectionView.collectionViewControllerManager!.sectionsCount = 1
        collectionView.collectionViewControllerManager!.dataSource = feeds
        collectionView.reloadData()
    
        // Handler select Feed cell
        collectionView.collectionViewControllerManager!.handlerCellSelectCompletion = { feed in
            self.router?.dataStore?.feedSelected = feed as! Feed
            self.router?.transitionToFeedShowScene()
        }
        
        // Handler Pull Refresh
        collectionView.collectionViewControllerManager!.handlerPullRefreshCompletion = { _ in
            // Reload Feeds from API
            self.feeds = [Feed]()
            self.feeds = FMDBManager.shared.feedsLoad()
            self.feedsDidLoad(withScrollingData: true)
        }
        
        // Handler Infinite Scrolling
        collectionView.collectionViewControllerManager.handlerInfiniteScrollCompletion = { _ in
            // Load More Feeds from API
            self.feedsDidLoad(withScrollingData: true)
        }
        
        collectionView.collectionViewControllerManager.pullRefreshDidFinish()
    }
    
    
    // MARK: - Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.setNeedsDisplay()
        collectionView.reloadData()
    }
}


// MARK: - FeedsShowDisplayLogic
extension FeedsShowViewController: FeedsShowDisplayLogic {
    func feedsDisplay(fromViewModel viewModel: FeedsShowModels.Feeds.ViewModel) {
        feedsDidShow()
    }
}
