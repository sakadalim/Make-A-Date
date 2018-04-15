//
//  EventPageViewController.swift
//  Make A Date
//
//  Created by John Buckley on 4/15/18.
//  Copyright © 2018 Sakada Lim. All rights reserved.
//

import UIKit


class EventPageViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle, {
        return .lightContent
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 2
        let cell = tableView.dequeueReusableCell(withIdentifier: "listEventsTableViewCell", for: indexPath)
        cell.textLabel?.text = "Cell Row: \(indexPath.row) Section: \(indexPath.section)"
        
        return cell
    }
}

