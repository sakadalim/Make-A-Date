
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
    func stringChanged(search: String)
    func locChange(loc: String)
    
}

class SearchViewController: UIViewController {
    
    var rangeVal: Float?
    var searchTerm: String?
    
    weak var delegate: PassBackDelegate?
    @IBOutlet weak var rangeSlider: UISlider!
    @IBOutlet var searchString: UITextField!
    @IBOutlet var rangeLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    var location: Location? {
        didSet {
            locationTextField.text = location.flatMap({ $0.title }) ?? ""
        }
    }
    @IBAction func changeRange(_ sender: Any) {

        var val = rangeSlider.value
        rangeLabel.text = String(format: "%.2f", rangeVal!) + "mi"
        rangeVal = rangeSlider.value
        delegate?.rangeChanged(rangee: rangeVal)
    }
    
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        performSegue(withIdentifier: "backToEventTable", sender: self)
        
    }
    
    

    @IBAction func changeTerm(_ sender: Any) {
        let term = searchString.text
        delegate?.stringChanged(search: term!)
        searchTerm = term
        print("CHANGE VAL" + searchString.text!)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        location = nil
        locationTextField.delegate = self
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchLocationPicker" {
            let locationPicker = segue.destination as! LocationPickerViewController
            locationPicker.location = location
            locationPicker.showCurrentLocationButton = true
            locationPicker.useCurrentLocationAsHint = true
            locationPicker.selectCurrentLocationInitially = true
            
            locationPicker.completion = { self.location = $0 }
        }
        if segue.identifier == "backToEventTable"{
            var term = searchString.text
            delegate?.stringChanged(search: term!)
            rangeVal = rangeSlider.value
            delegate?.rangeChanged(rangee: rangeVal)
            if location != nil{
                var lat = location?.coordinate.latitude.description
                var lon = location?.coordinate.longitude.description
                var locStr = lat!+","+lon!
                delegate?.locChange(loc: locStr)
            }
        }
    }
}

extension SearchViewController: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        performSegue(withIdentifier: "searchLocationPicker", sender: self)
        return false
    }
    
    
    
}

