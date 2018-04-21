//
//  CustomCell.swift
//  Make A Date
//
//  Created by Shefali Satpathy on 4/10/18.
//  Copyright © 2018 Sakada Lim. All rights reserved.
//
import UIKit

class CustomCell: UITableViewCell {
    
    var item: ViewModelItem? {
        didSet {
            titleLabel?.text = item?.title
        }
    }
    
    var item02: ViewModelItem02? {
        didSet {
            titleLabel?.text = item02?.title
        }
    }
    
    var item03: ViewModelItem03? {
        didSet {
            titleLabel?.text = item03?.title
        }
    }
    
    var item04: ViewModelItem04? {
        didSet {
            titleLabel?.text = item04?.title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    @IBOutlet weak var titleLabel: UILabel?
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // update UI
        accessoryType = selected ? .checkmark : .none
    }

    
}

