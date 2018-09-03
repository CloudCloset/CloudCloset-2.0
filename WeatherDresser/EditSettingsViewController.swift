//
//  EditSettingsViewController.swift
//  WeatherDresser
//
//  Created by Lily Li on 8/11/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit
import FirebaseDatabase

class EditSettingsViewController: UIViewController {
    @IBOutlet weak var zipcodeTextField: UITextField!
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
            temptConvert = "f˚"
        case 1:
            temptConvert = "c˚"
            
        default:
            temptConvert = "f˚"
            break
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveEditSettings" {
            let zipCode = zipcodeTextField.text
            
            if zipCode?.characters.count == 5 {
                Database.database().reference().child("users").child(User.current.uid).updateChildValues(["gender" : "\(gender)"])
                
                UserDefaults.standard.set(zipCode, forKey: Constants.UserDefaults.zipCode)
                UserDefaults.standard.set(temptConvert, forKey: Constants.UserDefaults.tempControl)
                
            }else {
                let alertController = UIAlertController(title: "Please enter a valid 5-digit zipcode!", message:
                    "", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
        }
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "saveEditSettings", sender: self)
    }
}
