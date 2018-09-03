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
    @IBOutlet weak var tempControl: UISegmentedControl!
    var gender: String = "f"
    var temptConvert: String = "f"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateUserViewController.dismissKeyboard))
        
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
            gender = "b"
        default:
            gender = "b"
            break
        }
    }
    @IBAction func tempChanged(_ sender: Any) {
        switch tempControl.selectedSegmentIndex
        {
        case 0:
            temptConvert = "f"
        case 1:
            temptConvert = "c"
            
        default:
            temptConvert = "f"
            break
        }
        
    }
    @IBAction func nextButtonTapped(_ sender: Any) {
        guard let firUser = Auth.auth().currentUser,
            let zipCode = nameTextField.text,
            Int(zipCode)?.digitCount == 5 else { let alertController = UIAlertController(title: "Please enter a 4-digit pin", message:
                "", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return }
        
        UserDefaults.standard.set(zipCode, forKey: Constants.UserDefaults.zipCode)
        UserDefaults.standard.set(temptConvert, forKey: Constants.UserDefaults.tempControl)
        
        
        UserService.create(firUser, gender: gender) { (user) in
            guard let user = user else {
                let alertController = UIAlertController(title: "Please enter a 4-digit pin", message:
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
