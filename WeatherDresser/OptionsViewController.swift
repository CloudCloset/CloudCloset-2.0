//
//  OptionsViewController.swift
//  WeatherDresser
//
//  Created by Lily Li on 8/9/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth


class OptionsViewController: UIViewController {

    @IBOutlet weak var zipcode: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var gender: UILabel!
    
    var authHandle: AuthStateDidChangeListenerHandle?

    
    @IBAction func logOutTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let signOutAction = UIAlertAction(title: "Sign Out", style: .default) { _ in
            do {
                try Auth.auth().signOut()
            } catch let error as NSError {
                assertionFailure("Error signing out: \(error.localizedDescription)")
            }
        }
        
        
        alertController.addAction(signOutAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authHandle = Auth.auth().addStateDidChangeListener() { [unowned self] (auth, user) in
            guard user == nil else { return }
            
            let loginViewController = UIStoryboard.initialViewController(for: .login)
            self.view.window?.rootViewController = loginViewController
            self.view.window?.makeKeyAndVisible()
        }
        
        
    }
    
    
    deinit {
        if let authHandle = authHandle {
            Auth.auth().removeStateDidChangeListener(authHandle)
        }
    }
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        zipcode.text = UserDefaults.standard.string(forKey: Constants.UserDefaults.zipCode)
        
        var genderValue = "undefined"
        
        let ref = Database.database().reference().child("users").child(User.current.uid).child("gender")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() { return }
            genderValue = snapshot.value as! String
            
            if genderValue == "f" {
                self.gender.text = "female"
            }
            else if genderValue == "m" {
                self.gender.text = "male"
            }
            else {
                self.gender.text = "both"
            }
        })

        
        
        
        temperature.text = UserDefaults.standard.string(forKey: Constants.UserDefaults.tempControl)
        
        
        
        if let txt = zipcode.text{
            if(txt.characters.count == 5 ){
                let zip = zipcode.text!
                Day.setZip(zipCode: zip)

                zipcode.text = "\(zip)"
                
                if(Day.getCity().contains("no such city")){
                    showError(bigErrorMsg: "You're in the middle of nowhere", smallErrorMsg: "Literally. Invalid zipcode; try again!")
                    return
                }
                else{
                    Weather.zipCode = zipcode.text
                    Weather.reload()
                }
            }
            else{
                showError(bigErrorMsg: "You're in the middle of nowhere", smallErrorMsg: "Literally. Invalid zipcode; try again!")
                return
                
            }
        }
        else{
            showError(bigErrorMsg: "You're in the middle of nowhere", smallErrorMsg: "Literally. Invalid zipcode; try again!")
            return
        }
        
        view.endEditing(true)
        
        
        
    }
    
    @IBAction func unwindToOptions(_ segue: UIStoryboardSegue) {

    }
    
    private func showError(bigErrorMsg: String, smallErrorMsg: String){
        let alertController = UIAlertController(title: "\(bigErrorMsg)", message:
            "\(smallErrorMsg)", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
}
