
//
//  Test.swift
//  Make A Date
//
//  Created by Peter D'Agostino on 4/26/18.
//  Copyright © 2018 Sakada Lim. All rights reserved.
//

import Foundation
import UIKit

protocol PassBackDelegate: class {
    func rangeChanged(rangee: Float?)
    func stringChanged(search: String?)
    
}

class SearchViewController: UIViewController {
    
    var rangeVal: Float?
    //var search: String?
    var searchTerm: String?
    
    weak var delegate: PassBackDelegate?
    @IBOutlet weak var rangeSlider: UISlider!
    @IBOutlet var searchString: UITextField!
    @IBOutlet var rangeLabel: UILabel!
    
    @IBAction func changeRange(_ sender: Any) {

        var val = rangeSlider.value
        rangeLabel.text = String(format: "%.2f", rangeVal!) + "mi"
        rangeVal = rangeSlider.value
        delegate?.rangeChanged(rangee: rangeVal)
    }
    
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        performSegue(withIdentifier: "backToEventTable", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("PREPAREBACK" + searchString.text!)
        print("Preparebackcheck")
        //mainView?.passDataBack(rangee: rangeVal!,searc: searchString.text!)
    }
    

    @IBAction func changeTerm(_ sender: Any) {
        var term = searchString.text
        delegate?.stringChanged(search: term)
        searchTerm = term
        print("CHANGE VAL" + searchString.text!)
    }
    override func viewWillDisappear(_ animated: Bool) {
         navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)

        if let rangee = rangeVal{
            rangeSlider.value=rangee
        }
        var currentVal=rangeSlider.value
        rangeLabel.text = String(format: "%.2f", rangeVal!) + "mi"
        if let termee = searchTerm{
            searchString.text = termee
        }
        
        print("Check STR" + self.searchString.text!)
        
        
    }
}

