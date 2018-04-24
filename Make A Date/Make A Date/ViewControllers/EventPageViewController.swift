//
//  EventPageViewController.swift
//  Make A Date
//
//  Created by John Buckley on 4/15/18.
//  Copyright © 2018 Sakada Lim. All rights reserved.
//

import UIKit
import CoreLocation
import AFNetworking

class ResultContent {
    var locationName: String?
    var locationCategory: String?
    var locationImage: String?
    var distance: String?
    var locationAddress: String?
}
class EventPageViewController: UIViewController, CLLocationManagerDelegate {
    var res = [ResultContent]()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "toSettings":
            print("note cell tapped")
            
            
        default:
            print("unexpected segue identifier")
        }
    }
    @IBAction func reload(_ sender: Any) {
        res = [ResultContent]()
        self.viewDidLoad()
    }
    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var eventSearchBar: UISearchBar!
    //@property (strong, nonatomic) CLLocationManager *LocationManager;
    var locationMan = CLLocationManager()
    var locationStr: String?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations[0]
        let long = userLocation.coordinate.longitude
        let lat = userLocation.coordinate.latitude
        //locationStr = "\(lat),\(long)"
        print("\(lat),\(long)")
        
    }
    func refresh(refreshControl: UIRefreshControl) {
        
        //your code here
        
        refreshControl.endRefreshing()
        
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.eventTableView.dataSource = self
        self.eventTableView.delegate = self
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
        var loc = locationMan.location
        if loc != nil{
            let long = loc!.coordinate.longitude
            let lat = loc!.coordinate.latitude
            print("Getting Location")
            locationStr = "\(lat),\(long)"
        }
        
        print("DOING AGAIN")
        Business.searchWithTerm(term: "", coords: locationStr, sort: nil, categories: nil, deals: nil, completion:
            { (businesses: [Business]?, error: Error?) -> Void in
                
                if let businesses = businesses{
                    for business in businesses{
                        var newCell = ResultContent()
                        
                        //newCell.locationImage = business.imageURL!
                        //print(business.name!)
                        //let bus = business.name!
                        newCell.locationName = business.name!
                        newCell.locationCategory = business.categories!
                        newCell.distance = business.distance!
                        newCell.locationAddress = business.address!
                        self.res.append(newCell)
                        print("HERE \(newCell.locationName!)")
                        DispatchQueue.main.async {
                            self.eventTableView.reloadData()
                        }
                    }
                }
                
        }
        )
        
        
        
        
        
    }
    
}

extension EventPageViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        print (self.res.count)
        //return res.count
        return self.res.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 2
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
        cell.locationName?.text = self.res[indexPath.row].locationName!
        cell.locationCategory?.text = self.res[indexPath.row].locationCategory!
        cell.locationAddress?.text = self.res[indexPath.row].locationAddress!
        cell.distance?.text = self.res[indexPath.row].distance!
        print(indexPath.row)
        print(self.res[indexPath.row].locationName)
        //print(cell.locationName.text)
        //print("HERE")
        return cell
    }
    
    
    public func reloadData(_ completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: {
            self.loadView()
        }, completion:{ _ in
            completion()
        })
    }
}

