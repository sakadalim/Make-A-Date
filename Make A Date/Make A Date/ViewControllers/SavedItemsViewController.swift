//
//  SavedItemsViewController.swift
//  Make A Date
//
//  Created by Sakada Lim on 4/30/18.
//  Copyright © 2018 Sakada Lim. All rights reserved.
//

import Foundation
import UIKit
import AWSDynamoDB
import AWSAuthCore

class SavedItemsViewController: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    
    var arrayOfSavedItems = [UserSavedItems]()
    let refreshControl = UIRefreshControl()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getSavedItems()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        refreshControl.addTarget(self, action: #selector(getSavedItems), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
    }
    @objc func getSavedItems() {
        self.arrayOfSavedItems.removeAll()
        // 1) Configure the query looking for all the notes created by this user (userId => Cognito identityId)
        let queryExpression = AWSDynamoDBQueryExpression()
        queryExpression.keyConditionExpression = "#userId = :userId"
        queryExpression.expressionAttributeNames = [
            "#userId": "userId",
        ]
        queryExpression.expressionAttributeValues = [
            ":userId": AWSIdentityManager.default().identityId
        ]
        
        // 2) Make the query
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        dynamoDbObjectMapper.query(UserSavedItems.self, expression: queryExpression) { (output: AWSDynamoDBPaginatedOutput?, error: Error?) in
            if error != nil {
                print("DynamoDB query request failed. Error: \(String(describing: error))")
            }
            if output != nil {
                print("Found [\(output!.items.count)] items")
                for item in output!.items {
                    if let savedItem = item as? UserSavedItems{
                        self.arrayOfSavedItems.append(savedItem)
                    }
                }
                DispatchQueue.main.async {
                    if self.refreshControl.isRefreshing {
                        self.refreshControl.endRefreshing()
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // deselect the selected row if any
        let selectedRow: IndexPath? = tableView.indexPathForSelectedRow
        if let selectedRowNotNill = selectedRow {
            tableView.deselectRow(at: selectedRowNotNill, animated: true)
        }
    }
    
}


extension SavedItemsViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfSavedItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
        cell.locationName?.text = self.arrayOfSavedItems[indexPath.row]._locationName!
        cell.locationCategory?.text = self.arrayOfSavedItems[indexPath.row]._locationCategory!
        cell.locationAddress?.text = self.arrayOfSavedItems[indexPath.row]._locationAddress!
        cell.distance?.text = self.arrayOfSavedItems[indexPath.row]._distance!
        cell.rating?.text = self.arrayOfSavedItems[indexPath.row]._rating!
        if(self.arrayOfSavedItems[indexPath.row]._imageUrl) != nil{
            cell.downloadImage(url:URL(string: self.arrayOfSavedItems[indexPath.row]._imageUrl!)!)
        }else{
            let yourImage: UIImage = UIImage(named: "not-found")!
            cell.locationImage.image = yourImage
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            SavedItemsService.deleteItem(self.arrayOfSavedItems[indexPath.row]._locationName!)
            self.arrayOfSavedItems.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
}
