//
//  UIViewController+Ext.swift
//  OmnieCommerce
//
//  Created by msm72 on 06.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

extension UIViewController {
    func alertViewDidShow(withTitle title: String, andMessage message: String, completion: @escaping (() -> ())) {
        let alertViewController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let alertViewControllerAction = UIAlertAction.init(title: NSLocalizedString("Ok", comment: "Action button title"), style: .default, handler: { action in
            return completion()
        })
        
        alertViewController.addAction(alertViewControllerAction)
        present(alertViewController, animated: true, completion: nil)
    }
}
