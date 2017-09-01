//
//  Connectivity.swift
//  PLinkInstagramDemo
//
//  Created by msm72 on 01.09.17.
//  Copyright © 2017 RemoteJob. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
