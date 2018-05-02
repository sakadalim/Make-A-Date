//
//  SavedItemsService.swift
//  Make A Date
//
//  Created by Sakada Lim on 4/30/18.
//  Copyright © 2018 Sakada Lim. All rights reserved.
//

import Foundation
import AWSDynamoDB
import AWSAuthCore

struct SavedItemsService {
    
    static func insertItem(_ item:ResultContent, startDate: String, endDate: String){
        
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        // Create a Note object using data model you downloaded from Mobile Hub
        let newItem: UserSavedItems = UserSavedItems()
        newItem._userId = AWSIdentityManager.default().identityId
        newItem._locationName = item.locationName
        newItem._locationAddress = item.locationAddress
        newItem._locationCategory = item.locationCategory
        newItem._distance = item.distance
        newItem._rating = item.rating
        newItem._imageUrl = item.imageUrl?.absoluteString
        newItem._startDate = startDate
        newItem._endDate = endDate
        newItem._updatedDate = NSDate().timeIntervalSince1970 as NSNumber
        
        //Save a new item
        dynamoDbObjectMapper.save(newItem, completionHandler: {
            (error: Error?) -> Void in
            
            if let error = error {
                print("Amazon DynamoDB Save Error on new SAVEDITEM: \(error)")
                return
            }
            print("New Item Successfully Saved to DB.")
        })
    }
    static func deleteItem(_ itemLocationName: String){
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        let itemToDelete = UserSavedItems()
        itemToDelete?._userId = AWSIdentityManager.default().identityId
        itemToDelete?._locationName = itemLocationName
        dynamoDbObjectMapper.remove(itemToDelete!, completionHandler: {(error: Error?) -> Void in
            if let error = error {
                print(" Amazon DynamoDB delete Saved Item ERROR: \(error)")
                return
            }
            print("A Saved Item was deleted in DDB.")
        })
    }
    func updateSavedItem(_ item: UserSavedItems)  {
        
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        let newItem: UserSavedItems = item
        newItem._updatedDate = NSDate().timeIntervalSince1970 as NSNumber
        let updateMapperConfig = AWSDynamoDBObjectMapperConfiguration()
        updateMapperConfig.saveBehavior = .updateSkipNullAttributes //ignore any null value attributes and does not remove in database
        dynamoDbObjectMapper.save(newItem, configuration: updateMapperConfig, completionHandler: {(error: Error?) -> Void in
            if let error = error {
                print(" Amazon DynamoDB UPDATE FAILED: \(error)")
                return
            }
            print("UPDATE SUCCESS.")
        })
    }

    
    
}
