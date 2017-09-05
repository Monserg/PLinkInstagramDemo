//
//  User.swift
//  PLinkInstagramDemo
//
//  Created by msm72 on 04.09.17.
//  Copyright © 2017 RemoteJob. All rights reserved.
//

import Foundation

public struct Comment {
    // MARK: - Properties
    public let codeID: String
    public let mediaID: String
    public let text: String
    
    
    // MARK: - Initializers
    public init(codeID: String, mediaID: String, text: String) {
        self.codeID     =   codeID
        self.mediaID    =   mediaID
        self.text       =   text
    }
    
    // Optional initializer
    // Takes a dictionary of type [String: Any] for key 'data'
    public init(json: [String: Any], mediaID: String) throws {
        // Get values
        guard let id = json[fieldCodeID] as? String else {
            throw SerializationError.missing(fieldCodeID)
        }
        
        guard let text = json[fieldText] as? String else {
            throw SerializationError.missing(fieldText)
        }
        
        // Set parsed values on the Feed model properties
        self.codeID     =   id
        self.text       =   text
        self.mediaID    =   mediaID
    }
}
