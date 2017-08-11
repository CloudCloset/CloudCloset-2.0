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

class OptionsViewController: UIViewController {
    
    @IBOutlet weak var zipcode: UILabel!
    
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var convert: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        zipcode.text = UserDefaults.standard.string(forKey: Constants.UserDefaults.zipCode)
//        
//        var genderValue = "undefined"
//        
//        let ref = Database.database().reference().child("users").child(User.current.uid)
//        ref.observeSingleEvent(of: .value, with: { snapshot in
//            
//            if !snapshot.exists() { return }
//            genderValue = (snapshot.value(forKey: "gender") as? String)!
//        })
//        
//        if genderValue == "f" {
//            gender.text = "female"
//        }
//        else {
//            gender.text = "male"
//        }
//        convert.text = UserDefaults.standard.string(forKey: Constants.UserDefaults.tempControl)
    }
    
    @IBAction func unwindToOptions(_ segue: UIStoryboardSegue) {

    }
    
}
