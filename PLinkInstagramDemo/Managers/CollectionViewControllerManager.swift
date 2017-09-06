//
//  MSMCollectionViewControllerManager.swift
//  OmnieCommerce
//
//  Created by msm72 on 18.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class CollectionViewControllerManager: UIViewController {
    // MARK: - Properties
    var dataSource: [Any]! {
        didSet {
            _ = dataSource.map {
                let cellIdentifier = ($0 as! InitCellParameters).cellIdentifier
                self.collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
            }
        }
    }
    
    var collectionView: CollectionView!
    var refreshControl: UIRefreshControl?
    var footerViewHeight: CGFloat = 60.0
    var isLoadMore = false
    var sectionsCount = 0
    var emptyText: String!
    var scrollPushPosition: CGFloat = 0.0
    var showFooterView = false

    // Handlers
    var handlerCellSelectCompletion: HandlerPassDataCompletion?
    var handlerPullRefreshCompletion: HandlerSendButtonCompletion?
    var handlerInfiniteScrollCompletion: HandlerSendButtonCompletion?

    
    // MARK: - Class Initialization
    init(withCollectionView collectionView: CollectionView, andEmptyMessageText text: String) {
        super.init(nibName: nil, bundle: Bundle.main)
        
        self.collectionView = collectionView
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.emptyText = text
        self.scrollPushPosition = self.collectionView.contentOffset.y
        
        self.pullRefreshDidCreate()
    }

    init(withCollectionView collectionView: CollectionView) {
        super.init(nibName: nil, bundle: Bundle.main)
        
        self.collectionView = collectionView
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("\(type(of: self)): \(#function) run in [line \(#line)]. UIScrollView.contentOffset.y = \(scrollView.contentOffset.y)")
        
        // Set Infinite Scroll
        guard Connectivity.isConnectedToInternet() else {
            return
        }

        guard dataSource != nil else {
            return
        }
        
        if (!self.collectionView!.hasHeaders && self.dataSource.count > 0) {
            if (scrollView.contentOffset.y >= footerViewHeight && !isLoadMore) {
                isLoadMore = !isLoadMore
                
                // Refresh Infinite Scrolling view
                showFooterView(true)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
                    self.handlerInfiniteScrollCompletion!()                    
                    self.showFooterView(false)
                }
            }
        }
    }

    
    // MARK: - Custom Functions
    private func showFooterView(_ show: Bool) {
        self.showFooterView = show
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func pullRefreshDidCreate() {
        if (!collectionView!.hasHeaders) {
            refreshControl = UIRefreshControl()
            refreshControl!.attributedTitle = NSAttributedString(string: NSLocalizedString("Loading Data", comment: ""),
                                                                 attributes: [NSFontAttributeName:  UIFont(name: "Helvetica", size: 12.0)!,
                                                                              NSForegroundColorAttributeName: UIColor.black])
            
            if #available(iOS 10.0, *) {
                collectionView!.refreshControl = refreshControl!
            } else {
                collectionView!.addSubview(refreshControl!)
            }
            
            refreshControl!.addTarget(self, action: #selector(handlerPullRefresh), for: .valueChanged)
        }
    }
    
    func pullRefreshDidFinish() {
        collectionView.setContentOffset(CGPoint.init(x: 0, y: scrollPushPosition), animated: true)
        refreshControl!.endRefreshing()
        isLoadMore = false
    }
    
    func handlerPullRefresh(refreshControl: UIRefreshControl) {
        guard Connectivity.isConnectedToInternet() else {
            refreshControl.endRefreshing()
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.handlerPullRefreshCompletion!()
        }
    }
}


// MARK: - UICollectionViewDataSource
extension CollectionViewControllerManager: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Return the number of sections
        return sectionsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of items
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = (dataSource[indexPath.row] as! InitCellParameters).cellIdentifier
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        let item = dataSource[indexPath.row]
        
        // Config cell
        (cell as! ConfigureCell).setup(withItem: item, andIndexPath: indexPath)
                
        return cell
    }
}


// MARK: - UICollectionViewDelegate
extension CollectionViewControllerManager {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: true)
        handlerCellSelectCompletion!(dataSource[indexPath.row])
        self.collectionView.deselectItem(at: indexPath, animated: true)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionViewControllerManager: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return (section == 0) ? .zero : CGSize.init(width: collectionView.frame.width, height: footerViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellIdentifier = (dataSource[indexPath.row] as! InitCellParameters).cellIdentifier
        let cellHeight = (dataSource[indexPath.row] as! InitCellParameters).cellHeight
        
        switch cellIdentifier {
        case "FeedCollectionViewCell":
            let height: CGFloat = cellHeight * self.collectionView.heightRatio
            
            return (UIApplication.shared.statusBarOrientation.isPortrait) ? CGSize.init(width: (collectionView.frame.width - 16.0) / 2, height: height) :
                                                                            CGSize.init(width: (collectionView.frame.width - 16 * 2) / 3, height: height)
            
        default:
            break
        }
        
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return (showFooterView) ? CGSize.init(width: collectionView.frame.width, height: footerViewHeight) : .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "Header",
                                                                             for: indexPath)
            headerView.backgroundColor = UIColor.blue
            
            return headerView
            
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "InfiniteScrollingFooterView",
                                                                             for: indexPath)
            
            return footerView
            
        default:
            assert(false, "Unexpected element kind")
        }
    }
}
