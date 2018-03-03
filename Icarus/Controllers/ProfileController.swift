//
//  ProfileController.swift
//  Icarus
//
//  Created by Jason Park on 3/3/18.
//  Copyright © 2018 Jason Park. All rights reserved.
//

import UIKit
import Firebase

class ProfileController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupProfileController()
    }
    
    
    
    
    ///////////////////////////////////////////////////////////////////
    //--------MARK: PRIVATE FUNCTIONS--------------------------------//
    ///////////////////////////////////////////////////////////////////
    
    //--------Setup HomeController
    fileprivate func setupProfileController() {
        view.backgroundColor = UIColor.white
        navigationItem.title = "Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    
    
    
    ///////////////////////////////////////////////////////////////////
    //--------MARK: HANDLERS-----------------------------------------//
    ///////////////////////////////////////////////////////////////////
    
    //--------Logout
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
}
