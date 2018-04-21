//
//  UserProfile.swift
//  MySampleApp
//
//
// Copyright 2018 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.19
//

import Foundation
import UIKit
import AWSDynamoDB
import AWSAuthCore

let userProfileDidUpdateNotification = "userProfileDidUpdateNotification"

@objcMembers
class UserProfile: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    
    var _userId: String?
    var _dateOfBirth: String?
    var _fullName: String?
    var _gender: String?
    var _locationName: String?
    var _updatedDate: NSNumber?
    
    var makeNew = true
        
    static var currentProfile: UserProfile?
    
    class func dynamoDBTableName() -> String {

        return "makeadate-mobilehub-1183265318-UserProfile"
    }
    
    class func hashKeyAttribute() -> String {

        return "_userId"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
               "_userId" : "userId",
               "_dateOfBirth" : "dateOfBirth",
               "_fullName" : "fullName",
               "_gender" : "gender",
               "_locationName" : "locationName",
               "_updatedDate" : "updatedDate",
        ]
    }
    
    class func createNewUserProfile(fullName: String, dob: String, gender: String, locationName: String){
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        let profile: UserProfile = UserProfile()
        
        profile._userId = AWSIdentityManager.default().identityId
        profile._dateOfBirth = dob
        profile._fullName = fullName
        profile._gender = gender
        profile._locationName = locationName
        profile._updatedDate = NSDate().timeIntervalSince1970 as NSNumber
        
        dynamoDbObjectMapper.save(profile, completionHandler: {
            (error: Error?) -> Void in
            if let error = error {
                print("Amazon DynamoDB Save Error on create new profilee: \(error)")
                return
            }
            print("New UserProfile successfully saved to DDB")
        })
        
    }
    
    class func getUserProfile(){
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        dynamoDbObjectMapper.load(UserProfile.self, hashKey: AWSIdentityManager.default().identityId as Any, rangeKey:nil).continueWith { (task: AWSTask<AnyObject>!) -> Any? in
            if let error = task.error as NSError? {
                print("The request failed. Error: \(error)", task)
            } else if let  gotProfile = task.result as? UserProfile {
                
                print("Got User Profile 2")
                UserProfile.currentProfile = gotProfile
                UserProfile.currentProfile?.makeNew = false
                NotificationCenter.default.post(name:
                    NSNotification.Name(rawValue: userProfileDidUpdateNotification), object: nil)
                return nil
            }
            print("USER NOT IN DB")
            return nil
        }
    }
    
    class func updateUserProfile(fullName: String, dob: String, gender: String, locationName: String){
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        let profile: UserProfile = UserProfile()
        profile._userId = AWSIdentityManager.default().identityId
        profile._dateOfBirth = dob
        profile._fullName = fullName
        profile._gender = gender
        profile._locationName = locationName
        profile._updatedDate = NSDate().timeIntervalSince1970 as NSNumber
        let updateMapperConfig = AWSDynamoDBObjectMapperConfiguration()
        updateMapperConfig.saveBehavior = .updateSkipNullAttributes
        dynamoDbObjectMapper.save(profile, configuration: updateMapperConfig, completionHandler: {(error: Error?) -> Void in
            if let error = error {
                print(" Amazon DynamoDB Save Error on note update: \(error)")
                return
            }
            print("User Profile Updated!")
        })
        
        
    }
}




