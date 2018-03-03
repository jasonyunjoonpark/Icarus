//
//  HomeController.swift
//  Icarus
//
//  Created by Jason Park on 3/3/18.
//  Copyright © 2018 Jason Park. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupHomeController()
    }

    
    
    
    ///////////////////////////////////////////////////////////////////
    //--------MARK: PRIVATE FUNCTIONS--------------------------------//
    ///////////////////////////////////////////////////////////////////
    
    //--------Setup HomeController
    fileprivate func setupHomeController() {
        view.backgroundColor = UIColor.white
        navigationItem.title = "Home"
    }
    
    
}
