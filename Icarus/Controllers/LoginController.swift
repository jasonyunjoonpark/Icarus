//
//  LoginController.swift
//  Icarus
//
//  Created by Jason Park on 3/3/18.
//  Copyright © 2018 Jason Park. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import Firebase
import AVFoundation

class LoginController: UIViewController {
    
    var Player: AVPlayer!
    var PlayerLayer: AVPlayerLayer!

    ///////////////////////////////////////////////////////////////////
    //--------MARK: CUSTOM UI----------------------------------------//
    ///////////////////////////////////////////////////////////////////
    
    //--------Title Label
    let titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Icarus"
        title.textAlignment = .center
        title.textColor = UIColor.white
        title.font = UIFont.systemFont(ofSize: 50, weight: UIFont.Weight.bold)
        title.font = UIFont(name: "AvenirNext-Italic" , size: 40)
        
        return title
    }()
    
    //--------Sign In With Facebook Button
    let signInWithFacebookButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 65/255, green: 93/255, blue: 174/255, alpha: 1)
        button.setTitle("Sign in with Facebook", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        
        button.addTarget(self, action: #selector(handleSignInWithFacebookButtonClicked), for: .touchUpInside)
        return button
    }()
    
    
    
    
    ///////////////////////////////////////////////////////////////////
    //--------MARK: VIEW DID LOAD------------------------------------//
    ///////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup background
        setupVideoBackground()
        //add subviews
        view.addSubview(titleLabel)
        view.addSubview(signInWithFacebookButton)
        //setup subview constraints
        setupTitleLabelConstraints()
        signInWithFacebookButtonConstraints()
    }

    
    
    
    ///////////////////////////////////////////////////////////////////
    //--------MARK: PRIVATE FUNCTIONS--------------------------------//
    ///////////////////////////////////////////////////////////////////
    
    //--------Login to Firebase
    fileprivate func loginToFirebase() {
        let accessToken = AccessToken.current
        guard let accessTokenString = accessToken?.authenticationToken else { return }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            
            if error != nil {
                print(error)
                return
            }
            guard let uid = user?.uid else { return }
            
            let ref = Database.database().reference(fromURL: "https://icarus-70ec4.firebaseio.com/")
            let usersReference = ref.child("users")
            
            //If user exists: login, otherwise user info into Firebase
            usersReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.hasChild(uid) {
                    print("User exists in Firebase already")
                } else {
                    
                }
                
            })
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    //--------Get Facebook Graph Request
    fileprivate func getFacebookGraphRequest(){
        
        //Setup graph request with parameters
        let graphRequestConnection = GraphRequestConnection()
        let graphRequest = GraphRequest.init(graphPath: "me", parameters: ["fields": "id, email, name, picture.type(large)"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: .defaultVersion)
        
        //get graph request
        graphRequestConnection.add(graphRequest) { (httpResponse, result) in
            
        }
        
        
    }
    
    
    
    
    ///////////////////////////////////////////////////////////////////
    //--------MARK: HANDLERS-----------------------------------------//
    ///////////////////////////////////////////////////////////////////

    //--------Clicked On Sign In With Facebook Button
    
    @objc func handleSignInWithFacebookButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (result) in
            switch result {
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                print("User logged in succesfully")
                self.loginToFirebase()
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User login cancelled")
            }
        }
    }
    
    //--------Handle Video Player End
    @objc func handlePlayerVideoEnded(notification: NSNotification) {
        Player.seek(to: kCMTimeZero)
    }
    
    
    ///////////////////////////////////////////////////////////////////
    //--------MARK: CONSTRAINTS--------------------------------------//
    ///////////////////////////////////////////////////////////////////
    
    
    fileprivate func setupTitleLabelConstraints() {
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: signInWithFacebookButton.topAnchor, constant: -300).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    fileprivate func signInWithFacebookButtonConstraints() {
        signInWithFacebookButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signInWithFacebookButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200).isActive = true
        signInWithFacebookButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        signInWithFacebookButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    
    
    
    ///////////////////////////////////////////////////////////////////
    //--------MARK: SETUP VIEW---------------------------------------//
    ///////////////////////////////////////////////////////////////////
    
    //--------Setup Video Background
    fileprivate func setupVideoBackground() {
        guard let url = Bundle.main.url(forResource: "video", withExtension: "mp4") else { return }
        Player = AVPlayer.init(url: url)
        
        PlayerLayer =  AVPlayerLayer(player: Player)
        PlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        PlayerLayer.frame = view.layer.frame
        
        Player.actionAtItemEnd = AVPlayerActionAtItemEnd.none
        
        Player.play()
        
        view.layer.insertSublayer(PlayerLayer, at: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePlayerVideoEnded(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: Player.currentItem)
    }
        
}















