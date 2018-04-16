//
//  ViewModel03.swift
//  Make A Date
//
//  Created by Shefali Satpathy on 4/12/18.
//  Copyright © 2018 Sakada Lim. All rights reserved.
//

import Foundation
import UIKit

let dataArray03 = [Model(title: "Day"), Model(title: "Night")]

class ViewModelItem03 {
    private var item03: Model
    
    var isSelected = false
    
    var title: String {
        return item03.title
    }
    
    init(item03: Model) {
        self.item03 = item03
    }
}

class ViewModel03: NSObject {
    var items03 = [ViewModelItem03]()
    
    var didToggleSelection: ((_ hasSelection: Bool) -> ())? {
        didSet {
            didToggleSelection?(!selectedItems.isEmpty)
        }
    }
    
    var selectedItems: [ViewModelItem03] {
        return items03.filter { return $0.isSelected }
    }
    
    override init() {
        super.init()
        items03 = dataArray03.map { ViewModelItem03(item03: $0) }
    }
}


extension ViewModel03: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items03.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as? CustomCell {
            cell.item03 = items03[indexPath.row]
            
            // select/deselect the cell
            if items03[indexPath.row].isSelected {
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

extension ViewModel03: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // update ViewModel item
        items03[indexPath.row].isSelected = true
        
        didToggleSelection?(!selectedItems.isEmpty)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        // update ViewModel item
        items03[indexPath.row].isSelected = false
        
        didToggleSelection?(!selectedItems.isEmpty)
    }
    
}

