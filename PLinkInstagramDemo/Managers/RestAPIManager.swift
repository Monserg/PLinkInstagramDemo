//
//  MSMRestApiManager.swift
//  OmnieCommerce
//
//  Created by msm72 on 13.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import Alamofire
import PercentEncoder

typealias RequestParametersType = (method: HTTPMethod, suffixStringURL: String, responseDataType: ResponseDataType, parameters: [String: Any]?)

enum RequestType {
    // API - Users endpoints
    case loadFeedsByAccessToken([String: Any])
    case loadUserInfoByAccessToken([String: Any])
    
    // API - Comments endpoints
    case loadLastCommentByMediaID([String: Any], String)


    func introduced() -> RequestParametersType {
        // Parametes named such as in Postman
        switch self {
        // API - Users endpoints
        case .loadFeedsByAccessToken(let params):           return (method: .get,
                                                                    suffixStringURL: "/users/self/media/recent",
                                                                    responseDataType: .DataArray,
                                                                    parameters: params)
            
        case .loadUserInfoByAccessToken(let params):        return (method: .get,
                                                                    suffixStringURL: "/users/self",
                                                                    responseDataType: .DataDictionary,
                                                                    parameters: params)
            
        // API - Comments endpoints
        case .loadLastCommentByMediaID(let params, let object_id):      return (method: .get,
                                                                                suffixStringURL: "/media/\(object_id)/comments",
                                                                                responseDataType: .DataDictionary,
                                                                                parameters: params)
        }
    }
}

final class RestAPIManager {
    // MARK: - Properties
    static let shared = RestAPIManager()
    
    var appURL: URL!
    let appHostURL = URL.init(string: "https://api.instagram.com/v1")!
    let headers = ["Content-Type": "application/json"]
    
    var appSuffixStringURL: String! {
        didSet {
            appURL = appHostURL.appendingPathComponent(appSuffixStringURL)
        }
    }
    
    // MARK: - Class Initialization
    private init() { }
    
    
    // MARK: - Class Functions
    func requestDidRun(_ requestType: RequestType, withHandlerResponseAPICompletion handlerResponseAPICompletion: @escaping (ResponseAPI?) -> Void) {
        let requestParameters = requestType.introduced()
        appSuffixStringURL = requestParameters.suffixStringURL
                
        if (requestParameters.parameters != nil) {
            for (index, dictionary) in requestParameters.parameters!.enumerated() {
                let key = dictionary.key
                let value = dictionary.value
                
                if (index) == 0 {
                    appURL = URL.init(string: PercentEncoding.encodeURI.evaluate(string: appURL.absoluteString.appending("?\(key)=\(value)")))
                } else {
                    appURL = URL.init(string: PercentEncoding.encodeURI.evaluate(string: appURL.absoluteString.appending("&\(key)=\(value)")))
                }
            }
        }
        
        Alamofire.request(appURL, method: requestParameters.method, parameters: requestParameters.parameters, encoding: URLEncoding.default, headers: headers).responseJSON { dataResponse -> Void in
            guard dataResponse.error == nil && dataResponse.result.value != nil else {
                handlerResponseAPICompletion(nil)
                return
            }
            
            var responseAPI: ResponseAPI!
            let json = dataResponse.result.value! as! [String: Any]
            
            do {
                responseAPI = try ResponseAPI.init(fromJSON: json, withResponseDataType: requestParameters.responseDataType)
                handlerResponseAPICompletion(responseAPI)
            }
            
            catch let error {
                print(error)
            }
         
            return
        }
    }
}
