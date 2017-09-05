//
//  Pagination.swift
//  PLinkInstagramDemo
//
//  Created by msm72 on 04.09.17.
//  Copyright © 2017 RemoteJob. All rights reserved.
//

import Foundation

public struct Pagination {
    // MARK: - Properties
    public let next_max_id: String
    public let next_url: String
    
    
    // MARK: - Initializers
    public init(next_max_id: String, next_url: String) {
        self.next_max_id = next_max_id
        self.next_url = next_url
    }
    
    // Optional initializer
    // Takes a dictionary of type [String: Any] for key 'pagination'
    public init(json: [String: Any]) throws {
        // 1. Get values
        guard let id = json[fieldNextMaxID] as? String else {
            throw SerializationError.missing(fieldNextMaxID)
        }
        
        guard let url = json[fieldNextURL] as? String else {
            throw SerializationError.missing(fieldNextURL)
        }
        
        // 2. Set parsed values on the model App properties
        self.next_max_id    =   id
        self.next_url       =   url
    }
}
