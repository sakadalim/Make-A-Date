//
//  searchSettingsViewController.swift
//  AFNetworking
//
//  Created by Peter D'Agostino on 4/23/18.
//

import Foundation
import UIKit

class searchSettingViewController: UIViewController{
    
    
    @IBAction func slideChanged(_ sender: Any) {
        var currentVal=rangeSlider.value
        rangeLabel.text = "\(currentVal)mi"
    }
    @IBOutlet weak var rangeLabel: UILabel!
    @IBOutlet weak var rangeSlider: UISlider!
    @IBAction func back(_ sender: UIButton!) {
        performSegue(withIdentifier: "toEvents", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var currentVal=rangeSlider.value
        rangeLabel.text = "\(currentVal)mi"
    }
}
