//
//  Constant.swift
//  PLinkInstagramDemo
//
//  Created by msm72 on 01.09.17.
//  Copyright © 2017 RemoteJob. All rights reserved.
//

import Foundation

enum SerializationError: Error {
    case missing(String)
}

let fieldPagination                     =   "pagination"
let fieldData                           =   "data"
let fieldMeta                           =   "meta"
let fieldUser                           =   "user"
let fieldAccessToken                    =   "access_token"

let fieldNextMaxID                      =   "next_max_id"
let fieldNextURL                        =   "next_url"
let fieldCode                           =   "code"
let fieldCodeID                         =   "id"
let fieldFullName                       =   "full_name"
let fieldUserName                       =   "username"

var user: User? {
    set {}
    
    get {
        return FMDBManager.shared.loadUser()
    }
}


// Handlers
//typealias HandlerPassUserCompletion     =   ((_ user: Any?) -> ())


struct INSTAGRAM_IDS {
    // MARK: - Properties
    static let INSTAGRAM_AUTHURL        =   "https://api.instagram.com/oauth/authorize/"
    static let INSTAGRAM_APIURl         =   "https://api.instagram.com/v1/users/"
    static let INSTAGRAM_CLIENT_ID      =   "e0ef0965580247e698a00c7a9fcecf07"
    static let INSTAGRAM_CLIENTSERCRET  =   "8d744dc23f8543c1985663e54f3cd3e9"
    static let INSTAGRAM_REDIRECT_URI   =   "http://plink.com.ua"
    static let INSTAGRAM_ACCESS_TOKEN   =   "access_token"
    static let INSTAGRAM_SCOPE          =   "likes+comments+relationships+public_content+follower_list"
}
