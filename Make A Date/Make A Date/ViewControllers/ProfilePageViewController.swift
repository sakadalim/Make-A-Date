//
//  ViewController.swift
//  Make A Date
//
//  Created by Sakada Lim on 3/21/18.
//  Copyright © 2018 Sakada Lim. All rights reserved.
//

import UIKit
import AWSMobileClient
import AWSAuthCore
import AWSAuthUI
import AWSDynamoDB


class ProfilePageViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var nameLabel:UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    var genderArray = ["Male", "Female"]
    var genderPicker = UIPickerView()
    var location: Location? {
        didSet {
            locationTextField.text = location.flatMap({ $0.title }) ?? ""
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if !AWSSignInManager.sharedInstance().isLoggedIn {
            presentAuthUIViewController()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        location = nil
        locationTextField.delegate = self
        setupDatePicker()
        setupGenderPicker()
        disableEdit()
        NotificationCenter.default.addObserver(self, selector: #selector(getDataUpdate), name: NSNotification.Name(rawValue: userProfileDidUpdateNotification), object: nil)
        
        
    }
    
    @objc private func getDataUpdate() {
        if UserProfile.currentProfile == nil {
            let alert = UIAlertController(title: "Update Profile", message:"Please update your profile.", preferredStyle: UIAlertControllerStyle.alert)
            
            let continueButton = UIAlertAction(title: "Continue", style: .default){ _ in
                self.enableEdit()
            }
            // add the actions (buttons)
            alert.addAction(continueButton)
            // show the alert
            self.present(alert, animated: true, completion: nil)
        } else {
            DispatchQueue.main.async {
                self.updateTextFields()
            }
        }

    }
    
    func updateTextFields(){
        if UserProfile.currentProfile != nil {
            self.fullNameTextField.text = (UserProfile.currentProfile?._fullName)!
            self.dateOfBirthTextField.text = (UserProfile.currentProfile?._dateOfBirth)!
            self.genderTextField.text = (UserProfile.currentProfile?._gender)!
            self.locationTextField.text = (UserProfile.currentProfile?._locationName)!
            if let firstName = (UserProfile.currentProfile?._fullName)!.components(separatedBy: " ").first{
                self.nameLabel.text = firstName
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLocationPicker" {
            let locationPicker = segue.destination as! LocationPickerViewController
            locationPicker.location = location
            locationPicker.showCurrentLocationButton = true
            locationPicker.useCurrentLocationAsHint = true
            locationPicker.selectCurrentLocationInitially = true
        
            locationPicker.completion = { self.location = $0 }
            
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return genderArray.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = genderArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderArray[row]
    }
    func setupGenderPicker(){
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderTextField.inputView = genderPicker
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ProfilePageViewController.genderDoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        genderTextField.inputAccessoryView = toolBar
    }
    func setupDatePicker(){
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.addTarget(self, action: #selector(ProfilePageViewController.datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        dateOfBirthTextField.inputView = datePickerView
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ProfilePageViewController.DOBDoneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        dateOfBirthTextField.inputAccessoryView = toolBar
        
    }
    
    @objc func DOBDoneClick(sender:Any) {
        dateOfBirthTextField.resignFirstResponder()
    }
//    @objc func DOBCancelClick(sender:Any) {
//        dateOfBirthTextField.resignFirstResponder()
//    }
    @objc func genderDoneClick(sender:Any) {
        genderTextField.resignFirstResponder()
    }
//    @objc func genderCancelClick(sender:Any) {
//        genderTextField.resignFirstResponder()
//    }
    
    // Make a dateFormatter in which format you would like to display the selected date in the textfield.
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateOfBirthTextField.text = dateFormatter.string(from: sender.date)
        
    }
    override func  touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func presentAuthUIViewController() {
        let config = AWSAuthUIConfiguration()
        config.enableUserPoolsUI = true
        config.backgroundColor = UIColor.jewel
        config.font = UIFont (name: "Helvetica Neue", size: 15)
        config.isBackgroundColorFullScreen = false
        config.canCancel = false
        config.logoImage = UIImage(named: "logo.png")
        AWSAuthUIViewController.presentViewController(
            with: self.navigationController!,
            configuration: config, completionHandler: { (provider: AWSSignInProvider, error: Error?) in
                if error == nil {
                    self.viewDidLoad()
                } else {
                    // end user faced error while loggin in, take any required action here.
                }
        })
    }
    
    func enableEdit(){
        fullNameTextField.isUserInteractionEnabled = true
        dateOfBirthTextField.isUserInteractionEnabled = true
        genderTextField.isUserInteractionEnabled = true
        locationTextField.isUserInteractionEnabled = true
        doneButton.isHidden = false
    }
    
    func disableEdit(){
        fullNameTextField.isUserInteractionEnabled = false
        dateOfBirthTextField.isUserInteractionEnabled = false
        genderTextField.isUserInteractionEnabled = false
        locationTextField.isUserInteractionEnabled = false
        doneButton.isHidden = true
    }
    func clearTextField(){
        fullNameTextField.text = ""
        dateOfBirthTextField.text = ""
        genderTextField.text = ""
        locationTextField.text = ""
        print("TEXT FIELD CLEARED")
    }
    @IBAction func didTapDoneButton(_ sender: Any) {
        
        if fullNameTextField.text == "" || dateOfBirthTextField.text == "" || genderTextField.text == "" || locationTextField.text == "" {
            let alertController = UIAlertController(title: "Missing Information", message: "Enter all information", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "OK",
                                         style: .default,
                                         handler: nil)
            alertController.addAction(actionOk)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        if UserProfile.currentProfile == nil {
            UserProfile.createNewUserProfile(fullName: fullNameTextField.text!, dob: dateOfBirthTextField.text!, gender: genderTextField.text!, locationName: locationTextField.text!)
        } else {
            UserProfile.updateUserProfile(fullName: fullNameTextField.text!, dob: dateOfBirthTextField.text!, gender: genderTextField.text!, locationName: locationTextField.text!)
        }
        UserProfile.getUserProfile()
        updateTextFields()
        disableEdit()
        if UserInterests.current.makeNew {
            // create the alert
            let alert = UIAlertController(title: "Tell Us Your Interests", message:"", preferredStyle: UIAlertControllerStyle.alert)
            
            let continueButton = UIAlertAction(title: "Continue", style: .default){ _ in
                
                let storyboard = UIStoryboard(name: "UserQuestionnaire", bundle: nil)
                guard let userInterestViewController = storyboard.instantiateInitialViewController() else {
                    fatalError("Couldn't instantiate inital view controller for UserQuestionnaire storyboard.")
                }
                self.present(userInterestViewController, animated: true)
            }
            // add the actions (buttons)
            alert.addAction(continueButton)
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapSettingButton(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let signOutAction = UIAlertAction(title: "Sign Out", style: .default){ _ in
            if (AWSSignInManager.sharedInstance().isLoggedIn) {
                AWSSignInManager.sharedInstance().logout(completionHandler: {(result: Any?, error: Error?) in
                    self.navigationController!.popToRootViewController(animated: false)
                    self.presentAuthUIViewController()
                    self.clearTextField()
                })
                UserProfile.currentProfile = nil
            } else {
                assert(false)
            }
        }
        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel, handler: nil)
        let editAction = UIAlertAction(title:"Edit Profile", style: .default){_ in
            self.enableEdit()
        }
        let changeInterestAction = UIAlertAction(title:"Update Interest", style: .default){_ in
            // present interest storyboard here
            let storyboard = UIStoryboard(name: "UserQuestionnaire", bundle: nil)
            guard let userInterestViewController = storyboard.instantiateInitialViewController() else {
                fatalError("Couldn't instantiate inital view controller for UserQuestionnaire storyboard.")
            }
            self.present(userInterestViewController, animated: true)
            
            
        }
        alertController.view.tintColor = UIColor.rose
        alertController.addAction(changeInterestAction)
        alertController.addAction(editAction)
        alertController.addAction(signOutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: userProfileDidUpdateNotification), object: self)
    }

}

extension ProfilePageViewController: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        performSegue(withIdentifier: "toLocationPicker", sender: self)
        return false
    }
    
    
    
}
