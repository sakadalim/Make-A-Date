//
//  ViewController.swift
//  Make A Date
//
//  Created by Sakada Lim on 3/21/18.
//  Copyright © 2018 Sakada Lim. All rights reserved.
//

import UIKit
import AWSMobileClient
import AWSAuthCore
import AWSAuthUI

class MainViewController: UIViewController {
    
    @IBOutlet weak var textfield: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        textfield.text = "View Controller Loaded"
        
        // Get the AWSCredentialsProvider from the AWSMobileClient
        let credentialsProvider = AWSMobileClient.sharedInstance().getCredentialsProvider()
        
        // Get the identity Id from the AWSIdentityManager
        let identityId = AWSIdentityManager.default().identityId
        
        
//        if !AWSSignInManager.sharedInstance().isLoggedIn {
//            AWSAuthUIViewController
//                .presentViewController(with: self.navigationController!,
//                                       configuration: nil,
//                                       completionHandler: { (provider: AWSSignInProvider, error: Error?) in
//                                        if error != nil {
//                                            print("Error occurred: \(String(describing: error))")
//                                        } else {
//                                            // Sign in successful.
//                                        }
//                })
//        }
        if !AWSSignInManager.sharedInstance().isLoggedIn {
            presentAuthUIViewController()
        }
    }
    
    func presentAuthUIViewController() {
        let config = AWSAuthUIConfiguration()
        config.enableUserPoolsUI = true
//        config.addSignInButtonView(class: AWSFacebookSignInButton.self)
//        config.addSignInButtonView(class: AWSGoogleSignInButton.self)
        config.backgroundColor = UIColor.jewel
        config.font = UIFont (name: "Helvetica Neue", size: 15)
        config.isBackgroundColorFullScreen = false
        config.canCancel = true
//        config.logoImage =
        AWSAuthUIViewController.presentViewController(
            with: self.navigationController!,
            configuration: config, completionHandler: { (provider: AWSSignInProvider, error: Error?) in
                if error == nil {
                    // SignIn succeeded.
                } else {
                    // end user faced error while loggin in, take any required action here.
                }
        })
    }
}

