//
//  FifthViewController.swift
//  Make A Date
//
//  Created by Shefali Satpathy on 4/12/18.
//  Copyright © 2018 Sakada Lim. All rights reserved.
//

import Foundation
import UIKit

class FifthViewController : UIViewController {
    
    @IBOutlet weak var tableView05: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    
    var viewModel = ViewModel04()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView05?.register(CustomCell.nib, forCellReuseIdentifier: CustomCell.identifier)
        tableView05?.estimatedRowHeight = 100
        tableView05?.rowHeight = UITableViewAutomaticDimension
        tableView05?.allowsMultipleSelection = false
        tableView05?.dataSource = viewModel
        tableView05?.delegate = viewModel
        tableView05?.separatorStyle = .none
        
        viewModel.didToggleSelection = { [weak self] hasSelection in
            self?.doneButton?.isEnabled = hasSelection
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func done(_ sender: Any) {
        UserInterests.setQuestion5(viewModel.selectedItems.map{$0.title}[0])
        tableView05?.reloadData()
        UserInterests.printResult()
        
        if UserInterests.current.makeNew {
            print("Create new user interest")
            UserInterests.createNewUserInterests()
        } else {
            print("UPDATE user interest")
            UserInterests.updateUserInterests()
        }
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
