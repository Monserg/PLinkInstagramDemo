//
//  User.swift
//  PLinkInstagramDemo
//
//  Created by msm72 on 04.09.17.
//  Copyright © 2017 RemoteJob. All rights reserved.
//

import Foundation

public struct User {
    // MARK: - Properties
    public let codeID: String
    public let name: String
    public let fullName: String
    public var accessToken: String
    
    
    // MARK: - Initializers
    public init(codeID: String, name: String, fullName: String, accessToken: String) {
        self.codeID = codeID
        self.fullName = fullName
        self.name = name
        self.accessToken = accessToken
    }
    
    // Optional initializer
    // Takes a dictionary of type [String: Any] for key 'entry'
    public init(json: [String: Any], withAccessToken accessToken: String) throws {
        // Get values
        guard let userID = json[fieldCodeID] as? String else {
            throw SerializationError.missing(fieldCodeID)
        }
        
        guard let userFullName = json[fieldFullName] as? String else {
            throw SerializationError.missing(fieldFullName)
        }
        
        guard let userName = json[fieldUserName] as? String else {
            throw SerializationError.missing(fieldUserName)
        }
        
        // Set parsed values on the User model properties
        self.codeID         =   userID
        self.fullName       =   userFullName
        self.name           =   userName
        self.accessToken    =   accessToken
    }
}
