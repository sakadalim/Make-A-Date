//
//  SearchResultsCell.swift
//  Make A Date
//
//  Created by Peter D'Agostino on 4/18/18.
//  Copyright © 2018 Sakada Lim. All rights reserved.
//

import Foundation
import UIKit

class SearchResultCell : UITableViewCell {
    
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var locationCategory: UILabel!
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var locationAddress: UILabel!
    
    @IBOutlet weak var rating: UILabel!
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
                self.locationImage.image = UIImage(data: data)
            }
        }
    }
}
