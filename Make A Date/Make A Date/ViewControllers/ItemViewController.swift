//
//  ItemViewController.swift
//  Make A Date
//
//  Created by Sakada Lim on 4/30/18.
//  Copyright © 2018 Sakada Lim. All rights reserved.
//

import Foundation
import UIKit
import EventKit

class ItemViewController: UIViewController{
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationAddressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    var resultContent: ResultContent!
    let startTimePicker = UIDatePicker()
    let endTimePicker = UIDatePicker()
    
    let store = EKEventStore()
    
    @IBAction func didTapSaveButton (){
        createEventinTheCalendar(with: resultContent.locationName!, forDate: startTimePicker.date, toDate: endTimePicker.date)
    }
    @IBAction func didTapShareButton(){
        
        // set up activity view controller
        let textToShare = [ "Check out ", resultContent.locationName ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook, UIActivityType.message ]
//        activityViewController.
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        downloadImage(url: resultContent.imageUrl!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationNameLabel.text = resultContent.locationName
        locationAddressLabel.text = resultContent.locationAddress
        categoryLabel.text = resultContent.locationCategory
        ratingLabel.text = resultContent.rating
        setupStartTimePicker()
        setupEndTimePicker()
        hideButtons()
    }
    func hideButtons(){
        saveButton.isHidden = true
        shareButton.isHidden = true
    }
    func showButtons(){
        if (startTimeTextField.text != "") && (endTimeTextField.text != ""){
            saveButton.isHidden = false
            shareButton.isHidden = false
        }
    }
    func setupStartTimePicker(){
        startTimePicker.datePickerMode = UIDatePickerMode.dateAndTime
        startTimePicker.minuteInterval = 10
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(startTimeDoneClicked));
        let spaceButton = UIBarButtonItem(barButtonSystemItem:.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(startTimeCancelClicked));
        
        toolBar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        startTimeTextField.inputView = startTimePicker
        startTimeTextField.inputAccessoryView = toolBar
    }
    func setupEndTimePicker(){
        endTimePicker.datePickerMode = UIDatePickerMode.dateAndTime
        endTimePicker.minuteInterval = 10
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(endTimeDoneClicked));
        let spaceButton = UIBarButtonItem(barButtonSystemItem:.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(endTimeCancelClicked));
        
        toolBar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        endTimeTextField.inputView = endTimePicker
        endTimeTextField.inputAccessoryView = toolBar
    }
    
    @objc func startTimeDoneClicked(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        startTimeTextField.text = dateFormatter.string(from: startTimePicker.date)
        self.view.endEditing(true)
        self.showButtons()
    }
    @objc func startTimeCancelClicked(){
        self.view.endEditing(true)
    }
    @objc func endTimeDoneClicked(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        endTimeTextField.text = dateFormatter.string(from: endTimePicker.date)
        self.view.endEditing(true)
        self.showButtons()
    }
    @objc func endTimeCancelClicked(){
        self.view.endEditing(true)
    }
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.itemImage.image = UIImage(data: data)
            }
        }
    }
    func createEventinTheCalendar(with title:String, forDate eventStartDate:Date, toDate eventEndDate:Date) {
        
        store.requestAccess(to: .event) { (success, error) in
            if  error == nil {
                let event = EKEvent.init(eventStore: self.store)
                event.title = title
                event.calendar = self.store.defaultCalendarForNewEvents // this will return deafult calendar from device calendars
                event.startDate = eventStartDate
                event.endDate = eventEndDate
                
                let alarm = EKAlarm.init(absoluteDate: Date.init(timeInterval: -3600, since: event.startDate))
                event.addAlarm(alarm)
                
                do {
                    try self.store.save(event, span: .thisEvent)
                    //event created successfullt to default calendar
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                }
                
            } else {
                //we have error in getting access to device calnedar
                print("error = \(String(describing: error?.localizedDescription))")
            }
        }
    }
}
