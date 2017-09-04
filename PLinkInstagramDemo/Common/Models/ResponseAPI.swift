//
//  ResponseAPI.swift
//  OmnieCommerce
//
//  Created by msm72 on 13.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import CoreData

enum ResponseDataType {
    case DataArray
    case DataNumber     // Integer, Float, Double, etc.
    case DataString
    case DataBoolean
    case DataDictionary
}

public enum StatusCodeNote: Int {
    case SUCCESS                    =   200     //  GET or DELETE result is successful
    case CONTINUE                   =   2201    //  POST result is successful & need continue
    case CREATED                    =   201     //  POST or PUT is successful
    case NOT_MODIFIED               =   304     //  If caching is enabled and etag matches with the server
    case SOMETHING_WRONG_3894       =   3894
    case BAD_REQUEST_400            =   400     //  Possibly the parameters are invalid
    case INVALID_CREDENTIAL         =   401     //  INVALID CREDENTIAL, possible invalid token
    case NOT_FOUND                  =   404     //  The item you looked for is not found
    case CONFLICT                   =   409     //  Conflict - means already exist
    case AUTHENTICATION_EXPIRED     =   419     //  Expired
    case WRONG_SHOW_INFO            =   4200    //  Failed on showing info
    case BAD_AUTHORIZATION          =   4401    //  BAD AUTHORIZATION
    case INCORRECT_PASSWORD         =   4402    //  PASSWORD IS INCORRECT
    case SOMETHING_WRONG_4222       =   4222    //  User does not exist
    case BAD_REQUEST_4444           =   4444    //  BAD REQUEST
    case WRONG_INPUT_DATA           =   4500    //  WRONG INPUT DATA
    case USER_EXIST                 =   4670
    case REQUEST_HANDLING_FAIL      =   5005    //  SQL processing failed
    case ORG_NAME_EXIST             =   6992    //  NAME OF ORG HAS UNIQUE CONSTRAIN
    case TIMESHEET_BROKEN           =   8100    //  Timesheet is not available
    
    var name: String {
        get { return String(describing: self) }
    }
}

class ResponseAPI {
    // MARK: - Properties
    var data: Any?
    var pagination: Pagination?
    var statusCodeNote: StatusCodeNote!

    
    // MARK: - Class Initialization
    public init(fromJSON json: [String: Any], withResponseDataType dataType: ResponseDataType) throws {
        // Meta
        if let meta = json[fieldMeta] as? [String: Any] {
            self.statusCodeNote = StatusCodeNote.init(rawValue: meta[fieldCode] as! Int)
        }
        
        // Pagination
        if let pagination = json[fieldPagination] as? [String: Any], pagination.count > 0 {
            self.pagination = Pagination(next_max_id: pagination[fieldNextMaxID] as! String, next_url: pagination[fieldNextURL] as! String)
        }
        
        // Data types
        switch dataType {
        case .DataArray:
            if let data = json[fieldData] as? [[String: Any]] {
                self.data = data
            }

        case .DataNumber:
            if let data = json[fieldData] as? NSNumber {
                self.data = data
            }

        case .DataString:
            if let data = json[fieldData] as? String {
                self.data = data
            }
        
        case .DataBoolean:
            if let data = json[fieldData] as? Bool {
                self.data = data
            }
            
        case .DataDictionary:
            if let data = json[fieldData] as? [String: Any] {
                self.data = data
            }
        }
    }
}
