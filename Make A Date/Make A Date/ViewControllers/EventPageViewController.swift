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

import Foundation

class ResultContent {
    var locationName: String?
    var locationCategory: String?
    //var locationImage: String?
    var distance: String?
    var locationAddress: String?
    var rating: String?
    var imageUrl: URL?
}

class EventPageViewController: UIViewController, CLLocationManagerDelegate, PassBackDelegate {
    func rangeChanged(rangee: Float?) {
        range = rangee
    }
    
    var res = [ResultContent]()
    var range: Float?
    var searchTerm: String?
    var secView: SearchViewController?
    func stringChanged(search: String?) {
        searchTerm? = search!
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "toSettings":
            
            let vc = segue.destination as? SearchViewController
            vc?.rangeVal = self.range
            vc?.searchTerm = self.searchTerm
            vc?.delegate=self
            print(vc?.searchString?.text)
            print("PASSING A->B")
            
            

        default:
            print("unexpected segue identifier")
        }
    }
    
    @IBAction func reload(_ sender: Any) {
        res = [ResultContent]()
        self.viewDidLoad()
    }
    @IBOutlet weak var eventTableView: UITableView!
    //@property (strong, nonatomic) CLLocationManager *LocationManager;
    var locationMan = CLLocationManager()
    var locationStr: String?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func returnTo(seque:UIStoryboardSegue){
        res = [ResultContent]()
        self.viewDidLoad()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations[0]
        let long = userLocation.coordinate.longitude
        let lat = userLocation.coordinate.latitude
        print("\(lat),\(long)")
        
    }
    func refresh(refreshControl: UIRefreshControl) {
        
        refreshControl.endRefreshing()
        
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("VIEWDIDLOAD")
        if range == nil{
            range = 15
        }
        if searchTerm == nil{
            searchTerm = ""
        }


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
            locationStr = "\(lat),\(long)"
        }
        
        print(searchTerm)
        var rangeinmeters:Int = Int(range! * 1.60934)*1000
        Business.searchWithTerm(term: searchTerm!, coords: locationStr, range: rangeinmeters, sort: nil, categories: nil, deals: nil, completion:
            { (businesses: [Business]?, error: Error?) -> Void in
                
                if let businesses = businesses{
                    var count = 0
                    for business in businesses{
                        var newCell = ResultContent()
                        newCell.locationName = business.name!
                        newCell.locationCategory = business.categories!
                        newCell.distance = business.distance!
                        newCell.locationAddress = business.address!
                        newCell.rating = "\(business.rating!)/5.0"
                        
                        if business.imageURL != nil{
                            newCell.imageUrl = business.imageURL!
                        }else{
                            newCell.imageUrl = nil
                        }
                        self.res.append(newCell)
                        count+=1
                        print("Total Res: \(count)")
                        
                        self.eventTableView.reloadData()
                        }
                    }
                }
                
        )
        
    }

}

extension EventPageViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
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
        cell.rating?.text = "\(self.res[indexPath.row].rating!)"
        if(self.res[indexPath.row].imageUrl) != nil{
            cell.downloadImage(url:self.res[indexPath.row].imageUrl!)
        }else{
            var yourImage: UIImage = UIImage(named: "not-found")!
            cell.locationImage.image = yourImage
        }
        
        print(indexPath.row)
        print(self.res[indexPath.row].locationName)
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

