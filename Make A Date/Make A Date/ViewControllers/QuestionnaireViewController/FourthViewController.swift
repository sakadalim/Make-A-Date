//
//  FourthViewController.swift
//  Make A Date
//
//  Created by Shefali Satpathy on 4/12/18.
//  Copyright © 2018 Sakada Lim. All rights reserved.
//

import Foundation
import UIKit

class FourthViewController : UIViewController {
    
    @IBOutlet weak var tableView04: UITableView!
    @IBOutlet weak var nextButton04: UIButton!
    
    var viewModel = ViewModel03()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView04?.register(CustomCell.nib, forCellReuseIdentifier: CustomCell.identifier)
        tableView04?.estimatedRowHeight = 100
        tableView04?.rowHeight = UITableViewAutomaticDimension
        tableView04?.allowsMultipleSelection = false
        tableView04?.dataSource = viewModel
        tableView04?.delegate = viewModel
        tableView04?.separatorStyle = .none
        
        viewModel.didToggleSelection = { [weak self] hasSelection in
            self?.nextButton04?.isEnabled = hasSelection
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func next04(_ sender: Any) {
        UserInterests.setQuestion4(viewModel.selectedItems.map{$0.title}[0])
        tableView04?.reloadData()
    }
}
