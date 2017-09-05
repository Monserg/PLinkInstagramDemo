//
//  FMDBManager.swift
//  PLinkInstagramDemo
//
//  Created by msm72 on 04.09.17.
//  Copyright © 2017 RemoteJob. All rights reserved.
//

import Foundation
import FMDB

class FMDBManager: NSObject {
    // MARK: - Properties
    static let shared = FMDBManager()
    
    let databaseFileName = "database.sqlite"
    var databasePath: String!
    private var database: FMDatabase!
    
    
    // MARK: - Class Initialization
    override init() {
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        databasePath = documentsDirectory.appending("/\(databaseFileName)")
        
        // Assign the instanced database.
        //        database = FMDatabase(path: databasePath!)
    }
    
    
    // MARK: - Class Functions
    private func databaseOpen() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: databasePath) {
                database = FMDatabase(path: databasePath)
            }
        }
        
        if database != nil {
            if database.open() {
                return true
            }
        }
        
        return false
    }
    
    func databaseCreate() -> Bool {
        var created = false
        
        if !FileManager.default.fileExists(atPath: databasePath) {
            database = FMDatabase(path: databasePath!)
            
            if database != nil {
                // Open the database.
                if database.open() {
                    let userQueryCreate = "CREATE TABLE USER (\(fieldCodeID) text primary key not null, \(fieldUserName) text not null, \(fieldFullName) text not null, \(fieldAccessToken) text not null)"
                    let paginationQueryCreate = "CREATE TABLE PAGINATION (\(fieldNextMaxID) text primary key not null, \(fieldNextURL) text not null)"
                    let feedsQueryCreate = "CREATE TABLE FEEDS (\(fieldCodeID) text primary key not null, \(fieldURL) text not null, \(fieldHasLiked) bool not null default false, \(fieldLikes) integer not null default 0, \(fieldComments) integer not null default 0)"
                    let commentQueryCreate = "CREATE TABLE COMMENT (\(fieldCodeID) text primary key not null, \(fieldMediaID) text not null, \(fieldText) text not null)"
                    
                    do {
                        try database.executeUpdate(userQueryCreate, values: nil)
                        try database.executeUpdate(paginationQueryCreate, values: nil)
                        try database.executeUpdate(feedsQueryCreate, values: nil)
                        try database.executeUpdate(commentQueryCreate, values: nil)
                        created = true
                    } catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
                    
                    database.close()
                } else {
                    print("Could not open the database.")
                }
            }
        }
        
        return created
    }
    
    public func databaseClean() {
        feedsDelete()
        paginationDelete()
    }

    
    // User model
    func userCreate(_ user: User) {
        if databaseOpen() {
            let userQueryInsert = "INSERT INTO USER (\(fieldCodeID), \(fieldUserName), \(fieldFullName), \(fieldAccessToken)) VALUES ('\(user.codeID)', '\(user.name)', '\(user.fullName)', '\(user.accessToken)')"
            
            database.executeUpdate(userQueryInsert, withArgumentsIn: [])
            database.close()
        }
    }
    
    func userLoad() -> User? {
        var userModel: User?
        
        if databaseOpen() {
            let userQueryLoad = "SELECT * FROM USER"
            
            // Execute query and save the results
            let userQueryResults = database.executeQuery(userQueryLoad, withArgumentsIn: [])
            
            // Check if there are results
            while userQueryResults!.next() {
                userModel = User(codeID: userQueryResults!.string(forColumn: fieldCodeID)!,
                                 name: userQueryResults!.string(forColumn: fieldUserName)!,
                                 fullName: userQueryResults!.string(forColumn: fieldFullName)!,
                                 accessToken: userQueryResults!.string(forColumn: fieldAccessToken)!)
            }
            
            database.close()
        }
        
        // Database don't open
        return userModel
    }
    
    func userUpdate(_ user: User) {
        if databaseOpen() {
            let userQueryUpdate = "UPDATE USER SET ID = \(user.codeID), NAME = \(user.name), FULLNAME = \(user.fullName), ACCESSTOKEN = \(user.accessToken)"
            
            database.executeUpdate(userQueryUpdate, withArgumentsIn: [])
            database.close()
        }
    }
    
    
    // Comment model
    private func commentCreate(_ comment: Comment) {
        if databaseOpen() {
            let commentQueryCreate = "INSERT INTO COMMENT (\(fieldCodeID), \(fieldText), \(fieldMediaID)) VALUES ('\(comment.codeID)', '\(comment.text)', '\(comment.mediaID)')"
            
            database.executeUpdate(commentQueryCreate, withArgumentsIn: [])
            database.close()
        }
    }
    
    func commentLoad(withParameters parameters: CommentLoadParameters) -> Comment? {
        var commentModel: Comment?
        var mediaIDValue: String!
        
        if databaseOpen() {
            if let id = parameters.comment?.codeID {
                mediaIDValue = id
            } else if let mediaID = parameters.mediaID {
                mediaIDValue = mediaID
            }
            
            let commentQueryLoad = "SELECT * FROM COMMENT WHERE \(fieldMediaID) = \(mediaIDValue)"
            
            // Execute query and save the results
            let commentQueryResults = database.executeQuery(commentQueryLoad, withArgumentsIn: [])
            
            // Check if there are results
            if let commentResults = commentQueryResults, commentResults.next() {
                commentModel = Comment(codeID: commentResults.string(forColumn: fieldCodeID)!,
                                       mediaID: mediaIDValue,
                                       text: commentResults.string(forColumn: fieldText)!)
            } else {
                if let comment = parameters.comment {
                    commentCreate(comment)
                }
            }
            
            database.close()
        }
        
        // Database don't open
        return commentModel
    }
    
    
    // Pagination model
    private func paginationCreate(_ pagination: Pagination) {
        if databaseOpen() {
            let paginationQueryInsert = "INSERT INTO PAGINATION (\(fieldNextMaxID), \(fieldNextURL)) VALUES ('\(pagination.next_max_id)', '\(pagination.next_url)')"
            
            database.executeUpdate(paginationQueryInsert, withArgumentsIn: [])
            database.close()
        }
    }
    
    func paginationLoad(_ pagination: Pagination?) -> Pagination? {
        var paginationModel: Pagination?
        
        if pagination != nil {
            if databaseOpen() {
                let paginationQueryLoad = "SELECT * FROM PAGINATION"
                
                // Execute query and save the results
                let paginationQueryResults = database.executeQuery(paginationQueryLoad, withArgumentsIn: [])
                
                // Check if there are results
                if let paginationResults = paginationQueryResults, paginationResults.next() {
                    paginationModel = Pagination(next_max_id: paginationResults.string(forColumn: fieldNextMaxID)!,
                                                 next_url: paginationResults.string(forColumn: fieldNextURL)!)
                } else {
                    paginationCreate(pagination!)
                }
                
                database.close()
            }
        }
        
        // Database don't open
        return paginationModel
    }
    
    private func paginationDelete() {
        if databaseOpen() {
            let paginationQueryDelete = "DELETE FROM PAGINATION"
            
            database.executeUpdate(paginationQueryDelete, withArgumentsIn: [])
            database.close()
        }
    }

    
    // Feed model
    private func feedCreate(_ feed: Feed) {
        if databaseOpen() {
            let feedQueryInsert = "INSERT INTO FEEDS (\(fieldCodeID), \(fieldURL), \(fieldHasLiked), \(fieldLikes), \(fieldComments)) VALUES ('\(feed.codeID)', '\(feed.url)', '\(feed.hasLiked)', '\(feed.likes)', '\(feed.comments)')"
            
            database.executeUpdate(feedQueryInsert, withArgumentsIn: [])
            database.close()
        }
    }
    
    func feedLoad(_ feed: Feed) -> Feed? {
        var feedModel: Feed?
        
        if databaseOpen() {
            let feedQueryLoad = "SELECT FROM FEEDS WHERE \(fieldCodeID) = \(feed.codeID)"
            
            // Execute query and save the results
            let feedQueryResults = database.executeQuery(feedQueryLoad, withArgumentsIn: [])
            
            // Check if there are results
            if let feedResults = feedQueryResults, feedResults.next() {
                feedModel = Feed(codeID: feedResults.string(forColumn: fieldCodeID)!,
                                 url: feedResults.string(forColumn: fieldURL)!,
                                 hasLiked: feedResults.bool(forColumn: fieldHasLiked),
                                 likes: Int(feedResults.int(forColumn: fieldLikes)),
                                 comments: Int(feedResults.int(forColumn: fieldComments)))
            } else {
                feedCreate(feed)
            }
            
            database.close()
        }
        
        // Database don't open
        return feedModel
    }

    func feedsLoad() -> [Feed]! {
        var feeds: [Feed]!
        
        if databaseOpen() {
            let feedsQueryLoad = "SELECT * FROM FEEDS ORDER BY \(fieldCodeID) ASC"
            
            // Execute query and save the results
            let feedsQueryResults = database.executeQuery(feedsQueryLoad, withArgumentsIn: [])
            
            // Check if there are results
            while feedsQueryResults!.next() {
                let feedModel = Feed(codeID: feedsQueryResults!.string(forColumn: fieldCodeID)!,
                                     url: feedsQueryResults!.string(forColumn: fieldURL)!,
                                     hasLiked: feedsQueryResults!.bool(forColumn: fieldHasLiked),
                                     likes: Int(feedsQueryResults!.int(forColumn: fieldLikes)),
                                     comments: Int(feedsQueryResults!.int(forColumn: fieldComments)))
                
                if feeds == nil {
                    feeds = [Feed]()
                }
                
                feeds.append(feedModel)
            }
            
            database.close()
        }
        
        // Database don't open
        return feeds
    }
    
    func feedDelete(byCodeID codeID: String) {
        if databaseOpen() {
            let feedQueryDelete = "DELETE FROM FEEDS WHERE \(fieldCodeID) = \(codeID)"
            
            database.executeUpdate(feedQueryDelete, withArgumentsIn: [])
            database.close()
        }
    }

    private func feedsDelete() {
        if databaseOpen() {
            let feedsQueryDelete = "DELETE FROM FEEDS"
            
            database.executeUpdate(feedsQueryDelete, withArgumentsIn: [])
            database.close()
        }
    }
}
