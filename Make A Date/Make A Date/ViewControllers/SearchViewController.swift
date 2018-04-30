
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
    var searchTerm: String?
    
    weak var delegate: PassBackDelegate?
    @IBOutlet weak var rangeSlider: UISlider!
    @IBOutlet var searchString: UITextField!
    @IBOutlet var rangeLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    var location: Location? {
        didSet {
            locationTextField.text = location.flatMap({ $0.title }) ?? ""
            if (location != nil){
                print("HEY  " + (location?.coordinate.latitude.description)! + ", " + (location?.coordinate.longitude.description)! )
            }
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        print("PREPAREBACK" + searchString.text!)
//        print("Preparebackcheck")
//        //mainView?.passDataBack(rangee: rangeVal!,searc: searchString.text!)
//    }
    

    @IBAction func changeTerm(_ sender: Any) {
        var term = searchString.text
        delegate?.stringChanged(search: term)
        searchTerm = term
        print("CHANGE VAL" + searchString.text!)
    }
//    override func viewWillDisappear(_ animated: Bool) {
//         navigationController?.setNavigationBarHidden(true, animated: false)
//    }
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
    }
}

extension SearchViewController: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        performSegue(withIdentifier: "searchLocationPicker", sender: self)
        return false
    }
    
    
    
}

