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



class ProfilePageViewController: UIViewController {
    
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let credentialsProvider = AWSMobileClient.sharedInstance().getCredentialsProvider()
        let identityId = AWSIdentityManager.default().identityId
        
        disableEdit()
        setupDatePicker()
        
        if !AWSSignInManager.sharedInstance().isLoggedIn {
            presentAuthUIViewController()
        }
    }
    
    func setupDatePicker(){
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.addTarget(self, action: #selector(ProfilePageViewController.datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        self.dateOfBirthTextField.inputView = datePickerView
    }
    
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
        AWSAuthUIViewController.presentViewController(
            with: self.navigationController!,
            configuration: config, completionHandler: { (provider: AWSSignInProvider, error: Error?) in
                if error == nil {
                    // SignIn succeeded.
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
    
    @IBAction func didTapSettingButton(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let signOutAction = UIAlertAction(title: "Sign Out", style: .default){ _ in
            if (AWSSignInManager.sharedInstance().isLoggedIn) {
                AWSSignInManager.sharedInstance().logout(completionHandler: {(result: Any?, error: Error?) in
                    self.navigationController!.popToRootViewController(animated: false)
                    self.presentAuthUIViewController()
                })
                // print("Logout Successful: \(signInProvider.getDisplayName)");
            } else {
                assert(false)
            }
        }
        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel, handler: nil)
        let editAction = UIAlertAction(title:"Edit Profile", style: .default){_ in
            self.enableEdit()
        }
        alertController.view.tintColor = UIColor.rose
        alertController.addAction(editAction)
        alertController.addAction(signOutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }

}

