//
//  SecondViewController.swift
//  Make A Date
//
//  Created by Shefali Satpathy on 4/12/18.
//  Copyright © 2018 Sakada Lim. All rights reserved.
//

import Foundation
import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var tableView02: UITableView!
    @IBOutlet weak var nextButton02: UIButton!
    
    var viewModel = ViewModel02()
    var questionTesting = Questionnaire()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView02?.register(CustomCell.nib, forCellReuseIdentifier: CustomCell.identifier)
        tableView02?.estimatedRowHeight = 100
        tableView02?.rowHeight = UITableViewAutomaticDimension
        tableView02?.allowsMultipleSelection = false
        tableView02?.dataSource = viewModel
        tableView02?.delegate = viewModel
        tableView02?.separatorStyle = .none

        viewModel.didToggleSelection = { [weak self] hasSelection in
            self?.nextButton02?.isEnabled = hasSelection
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
    
    @IBAction func next(_ sender: Any) {
//        print(viewModel.selectedItems.map { $0.title })
        questionTesting.setQuestion_02(viewModel)
        tableView02?.reloadData()
    }
    
    
    
}
