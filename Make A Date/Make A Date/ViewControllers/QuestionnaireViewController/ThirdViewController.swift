//
//  ThirdViewController.swift
//  Make A Date
//
//  Created by Shefali Satpathy on 4/12/18.
//  Copyright © 2018 Sakada Lim. All rights reserved.
//

import Foundation
import UIKit

class ThirdViewController : UIViewController {
    
    @IBOutlet weak var tableView03: UITableView!
    @IBOutlet weak var nextButton03: UIButton!
    
    var viewModel = ViewModel02()
    var questionTesting = Questionnaire()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView03?.register(CustomCell.nib, forCellReuseIdentifier: CustomCell.identifier)
        tableView03?.estimatedRowHeight = 100
        tableView03?.rowHeight = UITableViewAutomaticDimension
        tableView03?.allowsMultipleSelection = false
        tableView03?.dataSource = viewModel
        tableView03?.delegate = viewModel
        tableView03?.separatorStyle = .none
        
        viewModel.didToggleSelection = { [weak self] hasSelection in
            self?.nextButton03?.isEnabled = hasSelection
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
    
    @IBAction func next_03(_ sender: Any) {
//        print(viewModel.selectedItems.map { $0.title })
        questionTesting.setQuestion_03(viewModel)
        tableView03?.reloadData()
    }
}
