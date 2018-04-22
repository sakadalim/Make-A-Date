//
//  EventPageViewController.swift
//  Make A Date
//
//  Created by John Buckley on 4/15/18.
//  Copyright © 2018 Sakada Lim. All rights reserved.
//

import UIKit
import CoreLocation

class EventPageViewController: UIViewController, CLLocationManagerDelegate {
    var res = [SearchResultCell]()
    
    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var eventSearchBar: UISearchBar!
    //@property (strong, nonatomic) CLLocationManager *LocationManager;
    var locationMan = CLLocationManager()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations[0]
        let long = userLocation.coordinate.longitude
        let lat = userLocation.coordinate.latitude
        print("(\(lat), \(long))")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if CLLocationManager.locationServicesEnabled() {
            locationMan.requestWhenInUseAuthorization()
            locationMan.requestAlwaysAuthorization()
        }
        switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
            // Request when-in-use authorization initially
                locationMan.requestWhenInUseAuthorization()
                break
            
            case .restricted, .denied:
            // Disable location features
                locationMan.requestWhenInUseAuthorization()
                break
        
        case .authorizedAlways, .authorizedWhenInUse:
            locationMan.delegate = self
            locationMan.desiredAccuracy = kCLLocationAccuracyBest
            locationMan.startUpdatingLocation()
        }
        eventTableView.dataSource = self
        eventTableView.delegate = self
        
    }

}

extension EventPageViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        print (res.count)
        //return res.count
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 2
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
        cell.locationName!.text = "TEST"
        cell.locationCategory!.text = "FOOD"
        
        return cell
    }
    
}
