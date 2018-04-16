//
//  ViewModel02.swift
//  Make A Date
//
//  Created by Shefali Satpathy on 4/12/18.
//  Copyright © 2018 Sakada Lim. All rights reserved.
//

import Foundation
import UIKit

let dataArray02 = [Model(title: "Never"), Model(title: "Almost Never"), Model(title: "Sometimes"), Model(title: "Almost Always"), Model(title: "Everyday")]

class ViewModelItem02 {
    private var item02: Model
    
    var isSelected = false
    
    var title: String {
        return item02.title
    }
    
    init(item02: Model) {
        self.item02 = item02
    }
}

class ViewModel02: NSObject {
    var items02 = [ViewModelItem02]()
    
    var didToggleSelection: ((_ hasSelection: Bool) -> ())? {
        didSet {
            didToggleSelection?(!selectedItems.isEmpty)
        }
    }
    
    var selectedItems: [ViewModelItem02] {
        return items02.filter { return $0.isSelected }
    }
    
    override init() {
        super.init()
        items02 = dataArray02.map { ViewModelItem02(item02: $0) }
    }
}


extension ViewModel02: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items02.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as? CustomCell {
            cell.item02 = items02[indexPath.row]
            
            // select/deselect the cell
            if items02[indexPath.row].isSelected {
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

extension ViewModel02: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // update ViewModel item
        items02[indexPath.row].isSelected = true
        
        didToggleSelection?(!selectedItems.isEmpty)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        // update ViewModel item
        items02[indexPath.row].isSelected = false
        
        didToggleSelection?(!selectedItems.isEmpty)
    }
    
}

