//
//  User.swift
//  PLinkInstagramDemo
//
//  Created by msm72 on 04.09.17.
//  Copyright © 2017 RemoteJob. All rights reserved.
//

import UIKit

public struct Feed: InitCellParameters {
    // MARK: - Properties
    public let codeID: String
    public let url: String
    public let hasLiked: Bool
    public let likes: Int
    public let comments: Int
    
    // Confirm InitCellParameters Protocol
    var cellIdentifier: String = "FeedCollectionViewCell"
    var cellHeight: CGFloat = 126.0

    
    // MARK: - Initializers
    public init(codeID: String, url: String, hasLiked: Bool, likes: Int, comments: Int) {
        self.codeID         =   codeID
        self.hasLiked       =   hasLiked
        self.likes          =   likes
        self.comments       =   comments
        self.url            =   url        
    }
    
    // Optional initializer
    // Takes a dictionary of type [String: Any] for key 'data'
    public init(json: [String: Any], withAccessToken accessToken: String) throws {
        // Get values
        guard let id = json[fieldCodeID] as? String else {
            throw SerializationError.missing(fieldCodeID)
        }
        
        guard   let images = json[fieldImages] as? [String: Any],
                let standardResolution = images[fieldStandardResolution] as? [String: Any],
                let url = standardResolution[fieldURL] as? String else {
            throw SerializationError.missing(fieldImages)
        }
        
        guard let hasLiked = json[fieldHasLiked] as? Bool else {
            throw SerializationError.missing(fieldHasLiked)
        }

        guard let likes = json[fieldLikes] as? [String: Any], let likesCount = likes[fieldCount] as? Int else {
            throw SerializationError.missing(fieldLikes)
        }

        guard let comments = json[fieldComments] as? [String: Any], let commentsCount = comments[fieldCount] as? Int else {
            throw SerializationError.missing(fieldComments)
        }
        
        // Set parsed values on the User model properties
        self.codeID         =   id
        self.url            =   url
        self.hasLiked       =   hasLiked
        self.likes          =   likesCount
        self.comments       =   commentsCount
        
        // Get Comments model
        RestAPIManager.shared.requestDidRun(.loadLastCommentByMediaID([fieldAccessToken: accessToken], id)) { (responseAPI) in
            if let data = responseAPI!.data as? [String: Any], data.count > 0 {
                // Create new Comments object
                do {
                    let lastCommentModel = try Comment(json: data, mediaID: id)
                    _ = FMDBManager.shared.commentLoad(withParameters: (lastCommentModel, nil))
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
