//
//  QuestionnaireInitialViewController.swift
//  Make A Date
//
//  Created by Sakada Lim on 4/20/18.
//  Copyright © 2018 Sakada Lim. All rights reserved.
//

import Foundation
import UIKit

class QuestionnaireInitialViewController: UIViewController {
    
    
    @IBAction func didTapBackButton(_ sender:Any){
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
}
