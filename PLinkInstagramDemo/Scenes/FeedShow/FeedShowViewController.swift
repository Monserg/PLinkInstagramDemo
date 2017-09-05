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
    @IBOutlet weak var contentView: UIView! {
        didSet {
            feedImageView.snp.makeConstraints {
                $0.edges.equalTo(view).inset(UIEdgeInsetsMake(0, 0, 15, 0))
                $0.aspectRatio(3, by: 4, self: feedImageView)
            }
        }
    }
    
    @IBOutlet weak var feedImageView: UIImageView! {
        didSet {
            feedImageView.snp.makeConstraints {
                $0.size.equalTo(contentView)
            }
        }
    }
    
    @IBOutlet weak var likesImageView: UIImageView! {
        didSet {
            likesImageView.snp.makeConstraints {
                $0.size.equalTo(35)
                $0.edges.equalTo(contentView).inset(UIEdgeInsetsMake(0, 0, 15, 40))
            }
        }
    }
    
    @IBOutlet weak var likesLabel: UILabel! {
        didSet {
            likesLabel.snp.makeConstraints {
                $0.left.equalTo(likesImageView).offset(8)
                $0.center.equalTo(likesImageView)
            }
        }
    }

    @IBOutlet weak var lastCommentLabel: UILabel! {
        didSet {
            lastCommentLabel.numberOfLines = 0
            lastCommentLabel.textAlignment = .center
            
            // Set Constraints
            lastCommentLabel.snp.makeConstraints {
                $0.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 40, 0, 40))
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
        viewSettingsDidLoad()
    }
    
    
    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        let requestModel = FeedShowModels.Feed.RequestModel()
        interactor?.loadFeed(withRequestModel: requestModel)
    }
    
    func feedDidShow(_ feedDisplayed: FeedDisplayed) {
        feedImageView.kf.setImage(with: ImageResource(downloadURL: URL.init(string: feedDisplayed.feed.url)!, cacheKey: feedDisplayed.feed.url),
                                  placeholder: UIImage.init(named: "image-no-photo"),
                                  options: [.transition(ImageTransition.fade(1)),
                                            .processor(ResizingImageProcessor(referenceSize: feedImageView.frame.size,
                                                                              mode: .aspectFill))],
                                  completionHandler: { image, error, cacheType, imageURL in
                                    self.feedImageView.kf.cancelDownloadTask()
        })
        
        likesImageView.image = UIImage.init(named: feedDisplayed.feed.likes > 0 ? "icon-likes-enabled" : "icon-likes-disable")
        
        if feedDisplayed.feed.likes == 0 {
            likesLabel.isHidden = true
        } else {
            likesLabel.text = "\(feedDisplayed.feed.likes)"
        }
        
        if feedDisplayed.feed.comments == 0 {
            lastCommentLabel.isHidden = true
        } else {
            lastCommentLabel.text = feedDisplayed.text
        }
    }
}


// MARK: - FeedShowDisplayLogic
extension FeedShowViewController: FeedShowDisplayLogic {
    func displayFeed(fromViewModel viewModel: FeedShowModels.Feed.ViewModel) {
        feedDidShow(viewModel.feedDisplayed)
    }
}
