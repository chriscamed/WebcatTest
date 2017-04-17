//
//  ViewController.swift
//  WebcatTest
//
//  Created by Camilo Medina on 4/15/17.
//  Copyright © 2017 webcat. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }

}

