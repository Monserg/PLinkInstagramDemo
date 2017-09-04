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
    private func openDatabase() -> Bool {
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
    
    func createDatabase() -> Bool {
        var created = false
        
        if !FileManager.default.fileExists(atPath: databasePath) {
            database = FMDatabase(path: databasePath!)
            
            if database != nil {
                // Open the database.
                if database.open() {
                    let createUserQuery = "CREATE TABLE USER (\(fieldCodeID) text primary key not null, \(fieldUserName) text not null, \(fieldFullName) text not null, \(fieldAccessToken) text not null)"
                    
                    do {
                        try database.executeUpdate(createUserQuery, values: nil)
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
    
    
    // User model
    private func createUser() -> Bool {
        if openDatabase() {
            let createUserQuery = "Create User (\(fieldCodeID) Text primary key not null, \(fieldUserName) Text not null, \(fieldFullName) Text not null, \(fieldAccessToken) Text not null)"
            
            do {
                try database.executeUpdate(createUserQuery, values: nil)
            }
                
            catch {
                print("Could not create User")
                print(error.localizedDescription)
            }
            
            database.close()
            
            return true
        }
        
        return false
    }
    
    func loadUser() -> User? {
        var userModel: User?
        
        if openDatabase() {
            let userLoadQuery = "SELECT * FROM USER"
            
            // Execute query and save the results
            let userQueryResults = database.executeQuery(userLoadQuery, withArgumentsIn: [])
            
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
    
    func createUser(_ user: User) {
        if openDatabase() {
            let userCreateQuery = "INSERT INTO USER (\(fieldCodeID), \(fieldUserName), \(fieldFullName), \(fieldAccessToken)) VALUES ('\(user.codeID)', '\(user.name)', '\(user.fullName)', '\(user.accessToken)')"
            
            database.executeUpdate(userCreateQuery, withArgumentsIn: [])
            database.close()
        }
    }
    
    func updateUser(_ user: User) {
        if openDatabase() {
            let userUpdateQuery = "UPDATE USER SET ID = \(user.codeID), NAME = \(user.name), FULLNAME = \(user.fullName), ACCESSTOKEN = \(user.accessToken)"
            
            database.executeUpdate(userUpdateQuery, withArgumentsIn: [])
            database.close()
        }
    }
}
