//
//  ViewController.swift
//  Icarus
//
//  Created by Jason Park on 3/3/18.
//  Copyright © 2018 Jason Park. All rights reserved.
//

import UIKit
import Firebase

class TabBarController: UITabBarController {

    ///////////////////////////////////////////////////////////////////
    //--------MARK: VIEW DID LOAD------------------------------------//
    ///////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        setupTabBarViewControllers()
        
    }

    
    
    
    ///////////////////////////////////////////////////////////////////
    //--------MARK: PRIVATE FUNCTIONS--------------------------------//
    ///////////////////////////////////////////////////////////////////
    
    //--------Check If User is Logged-In
    fileprivate func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
    }
    
    //--------Setup TabBarController's Controllers
    fileprivate func setupTabBarViewControllers() {
        let homeNavigationController = UINavigationController(rootViewController: HomeController())
        let profileNavigationController = UINavigationController(rootViewController: ProfileController())
        
        viewControllers = [homeNavigationController, profileNavigationController]
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
        present(loginController, animated: false, completion: nil)
        
    }
    
    
    
}

