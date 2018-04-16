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
    var questionTesting = Questionnaire()
    
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "Question_02":
            print("Question 02 starts...")
        default:
            print("unexpected segue identifier")
        }
    }
    
    @IBAction func done(_ sender: Any) {
//        print(viewModel.selectedItems.map { $0.title })
        questionTesting.setQuestion_05(viewModel)
        tableView05?.reloadData()
    }
}
