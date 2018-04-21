//
//  ViewController.swift
//  Make A Date
//
//  Created by Sakada Lim on 3/21/18.
//  Copyright © 2018 Sakada Lim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var viewModel = ViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView?.register(CustomCell.nib, forCellReuseIdentifier: CustomCell.identifier)
        tableView?.estimatedRowHeight = 100
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.allowsMultipleSelection = true
        tableView?.dataSource = viewModel
        tableView?.delegate = viewModel
        tableView?.separatorStyle = .none
        
        viewModel.didToggleSelection = { [weak self] hasSelection in
            self?.nextButton?.isEnabled = hasSelection
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    @IBAction func next(_ sender: Any) {
//        questionTesting.setQuestion_01(viewModel)
        print(Set(viewModel.selectedItems.map{$0.title}))
        UserInterests.setQuestion1(Set(viewModel.selectedItems.map{$0.title}))
        tableView?.reloadData()
    }
}

