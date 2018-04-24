//
//  searchSettingsViewController.swift
//  AFNetworking
//
//  Created by Peter D'Agostino on 4/23/18.
//

import Foundation
import UIKit

class searchSettingViewController: UIViewController {
    

    @IBAction func changeRange(_ sender: Any) {
        var val = rangeSlider.value
        rangeLabel.text = "\(val)mi"
    }
    @IBOutlet weak var rangeSlider: UISlider!
    @IBOutlet weak var rangeLabel: UILabel!
    
    @IBAction func goBack(_ sender: Any) {
        performSegue(withIdentifier: "toEvents", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var currentVal=rangeSlider.value
        rangeLabel.text = "\(currentVal)mi"
    }
}
