//
//  FeedShowViewController.swift
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
import SnapKit
import Kingfisher

// MARK: - Input & Output protocols
protocol FeedShowDisplayLogic: class {
    func displayFeed(fromViewModel viewModel: FeedShowModels.Feed.ViewModel)
}

class FeedShowViewController: UIViewController {
    // MARK: - Properties
    var interactor: FeedShowBusinessLogic?
    var router: (NSObjectProtocol & FeedShowRoutingLogic & FeedShowDataPassing)?
        
    
    // MARK: - IBOutlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var likesImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var lastCommentLabel: UILabel!
    
    
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
        let interactor      =   FeedShowInteractor()
        let presenter       =   FeedShowPresenter()
        let router          =   FeedShowRouter()
        
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
        
        navigationItem.title = NSLocalizedString("Feed", comment: "Title of selected feed")
        prepareConstrains()
    }
    
    
    // MARK: - Custom Functions
    func viewSettingsDidLoad() {        
        let requestModel = FeedShowModels.Feed.RequestModel()
        interactor?.loadFeed(withRequestModel: requestModel)
    }
    
    func feedDidShow(_ feedDisplayed: FeedDisplayed) {
        self.feedImageView.image = UIImage.init(named: "image-no-photo")
        self.feedImageView.contentMode = .center
        feedImageView.kf.indicatorType = .activity
        
        feedImageView.kf.setImage(with: ImageResource(downloadURL: URL.init(string: feedDisplayed.feed.url)!, cacheKey: "\(feedDisplayed.feed.url)_feed"),
                                  placeholder: nil,
                                  options: [.transition(ImageTransition.fade(1)),
                                            .processor(ResizingImageProcessor(referenceSize: feedImageView.frame.size,
                                                                              mode: .aspectFill))],
                                  completionHandler: { image, error, cacheType, imageURL in
//                                    if let imageDownload = image, Connectivity.isConnectedToInternet() {
//                                        ImageCache.default.store(imageDownload, forKey: "\(feedDisplayed.feed.url)_feed")
//                                    } else {
//                                        ImageCache.default.retrieveImage(forKey: "\(feedDisplayed.feed.url)_feed", options: nil) { image, cacheType in
//                                            if let imageCashed = image {
//                                                print("Get image \(imageCashed), cacheType: \(cacheType).")
//                                            } else {
//                                                print("Not exist in cache.")
//                                            }
//                                        }
//                                    }
                                    
                                    self.feedImageView.kf.cancelDownloadTask()
        })
        
        if feedDisplayed.feed.likes == 0 {
            likesLabel.isHidden = true
        } else {
            likesLabel.text = "\(feedDisplayed.feed.likes)"
        }
        
        if feedDisplayed.feed.comments == 0 {
            lastCommentLabel.isHidden = true
        } else {
            lastCommentLabel.text = feedDisplayed.text
            lastCommentLabel.numberOfLines = 0
            lastCommentLabel.textAlignment = .center
        }
    }
    
    func prepareConstrains() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(view).offset(0)
            $0.left.equalTo(view).offset(0)
            $0.right.equalTo(view).offset(0)
            $0.aspectRatio(4, by: 3, self: contentView)
        }
        
        feedImageView.snp.makeConstraints {
            $0.size.equalTo(contentView)
            $0.center.equalTo(contentView)
        }
        
        likesImageView.snp.makeConstraints {
            $0.size.equalTo(35)
            $0.bottom.equalTo(contentView).offset(-15)
            $0.right.equalTo(contentView).offset(-40)
        }
        
        likesLabel.snp.makeConstraints {
            $0.size.width.equalTo(35)
            $0.center.equalTo(likesImageView)
        }
        
        // Set Constraints
        lastCommentLabel.snp.makeConstraints {
            $0.bottom.equalTo(contentView).offset(40)
            $0.left.equalTo(view).offset(40)
            $0.right.equalTo(view).offset(-40)
            $0.centerX.equalTo(contentView)
        }
        
        viewSettingsDidLoad()
    }
}


// MARK: - FeedShowDisplayLogic
extension FeedShowViewController: FeedShowDisplayLogic {
    func displayFeed(fromViewModel viewModel: FeedShowModels.Feed.ViewModel) {
        feedDidShow(viewModel.feedDisplayed)
    }
}
