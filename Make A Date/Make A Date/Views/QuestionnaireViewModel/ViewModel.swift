//
//  ViewModel.swift
//  Make A Date
//
//  Created by Shefali Satpathy on 4/10/18.
//  Copyright © 2018 Sakada Lim. All rights reserved.
//

import Foundation
import UIKit

let dataArray = [Model(title: "Food"), Model(title: "Art"), Model(title: "Animals"), Model(title: "Music"), Model(title: "Museums"), Model(title: "TV/Movies"), Model(title: "Nightlife"), Model(title: "Fashion"), Model(title: "Fitness"), Model(title: "Watching Sports")]


class ViewModelItem {
    private var item: Model
    
    var isSelected = false
    
    var title: String {
        return item.title
    }
    
    init(item: Model) {
        self.item = item
    }
}

class ViewModel: NSObject {
    var items = [ViewModelItem]()
    
    var didToggleSelection: ((_ hasSelection: Bool) -> ())? {
        didSet {
            didToggleSelection?(!selectedItems.isEmpty)
        }
    }
    
    var selectedItems: [ViewModelItem] {
        return (items.filter){ return $0.isSelected }
    }
    
    
    override init() {
        super.init()
        items = dataArray.map { ViewModelItem(item: $0) }

    }
}

extension ViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as? CustomCell {
            cell.item = items[indexPath.row]
            
            // select/deselect the cell
            if items[indexPath.row].isSelected {
                if !cell.isSelected {
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }
            } else {
                if cell.isSelected {
                    tableView.deselectRow(at: indexPath, animated: false)
                }
            }
            
            return cell
        }
        return UITableViewCell()
    }
}

extension ViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // update ViewModel item
        items[indexPath.row].isSelected = true
        
        didToggleSelection?(!selectedItems.isEmpty)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        // update ViewModel item
        items[indexPath.row].isSelected = false
        
        didToggleSelection?(!selectedItems.isEmpty)
    }
    
//    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        if selectedItems.count > 2 {
//            return nil
//        }
//        return indexPath
//    }
}
