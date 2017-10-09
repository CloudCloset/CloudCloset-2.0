//
//  LoginViewController.swift
//  WeatherDresser
//
//  Created by Lily Li on 8/9/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase

typealias FIRUser = FirebaseAuth.User


class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        
        authUI.delegate = self
        
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
        
        print("the login button was pressed")
    }
}
extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        if let error = error {
            if error.localizedDescription.contains("Network error") {
                let alertController = UIAlertController(title: "No network", message: "Make sure you're connected to wifi or data.", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Try again", style: .cancel, handler: nil)
                alertController.addAction(cancel)
                present(alertController, animated: true)
            }
            else if error.localizedDescription.contains("couldn’t be completed") {
                
                print("login cancelled")
                
            }
            else {
                let alertController = UIAlertController(title: "Something went wrong", message: "", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Try again", style: .cancel, handler: nil)
                alertController.addAction(cancel)
                present(alertController, animated: true)
                print("Error signing in: \(error.localizedDescription)")
                
            }
            return
        }
        guard let user = user
            else { return }
        UserService.show(forUID: user.uid) { (user) in
            if let user = user {
                User.setCurrent(user, writeToUserDefaults: true)
                let storyboard = UIStoryboard(name: "Main", bundle: .main)
                
                if let initialViewController = storyboard.instantiateInitialViewController() {
                    self.view.window?.rootViewController = initialViewController
                    self.view.window?.makeKeyAndVisible()
                }
                print("existing user")
            }
            else {
                self.performSegue(withIdentifier: Constants.Segue.toCreateNewUser, sender: self)
                print("new user")
            }
        }}
}
