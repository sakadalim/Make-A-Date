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
    var questionTesting = Questionnaire()
    
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        print("Questionnaire starts...")
    }
    
    @IBAction func next(_ sender: Any) {
//        print(viewModel.selectedItems.map { $0.title })
        questionTesting.setQuestion_01(viewModel)
        tableView?.reloadData()
    }
}

