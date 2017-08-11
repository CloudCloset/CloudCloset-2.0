//
//  CreateUserViewController.swift
//  WeatherDresser
//
//  Created by Lily Li on 8/9/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateUserViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderControl: UISegmentedControl!
    var gender: String = "f"
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func genderChanged(_ sender: Any) {
        switch genderControl.selectedSegmentIndex
        {
        case 0:
            gender = "f"
        case 1:
            gender = "m"
        case 2:
            gender = "e"
        default:
            gender = "e"
            break
        }
    }
    @IBAction func nextButtonTapped(_ sender: Any) {
        guard let firUser = Auth.auth().currentUser,
            let zipCode = nameTextField.text,
            !zipCode.isEmpty else { let alertController = UIAlertController(title: "please enter a 4 digit pin", message:
                "", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return }
        
        UserDefaults.standard.set(zipCode, forKey: Constants.UserDefaults.zipCode)
        
        
        UserService.create(firUser, gender: gender) { (user) in
            guard let user = user else {
                let alertController = UIAlertController(title: "please enter a 4 digit pin", message:
                    "", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            User.setCurrent(user, writeToUserDefaults: true)
            
            let initialViewController = UIStoryboard.initialViewController(for: .main)
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
        }
    }
    
}
