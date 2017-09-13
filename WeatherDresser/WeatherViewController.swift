//
//  ViewController.swift
//  WeatherDresser
//
//  Created by Lily Li on 7/5/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import UIKit
import MBProgressHUD
import FirebaseDatabase


class WeatherViewController: UIViewController {
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var dayOneButton: UIButton!
    @IBOutlet weak var dayTwoButton: UIButton!
    @IBOutlet weak var dayThreeButton: UIButton!
    @IBOutlet weak var dayFiveButton: UIButton!
    @IBOutlet weak var dayFourButton: UIButton!
    @IBOutlet weak var outfitImage: UIImageView!
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var currentCityLabel: UILabel!
    
    @IBOutlet weak var dayOneLabel: UILabel!
    @IBOutlet weak var dayTwoLabel: UILabel!
    @IBOutlet weak var dayThreeLabel: UILabel!
    @IBOutlet weak var dayFourLabel: UILabel!
    @IBOutlet weak var dayFiveLabel: UILabel!
    
    @IBOutlet weak var iconImage: UIImageView!
    
    var originalTopMargin:CGFloat!
    
    var dayOne: Int?
    var dayTwo: Int?
    var dayThree: Int?
    var dayFour: Int?
    var dayFive: Int?
    
    var picString: String!
    
    var likePicsArray = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Weather.reload()
        
        dayOne = Weather.weatherArr[0]
        dayTwo = Weather.weatherArr[1]
        dayThree = Weather.weatherArr[2]
        dayFour = Weather.weatherArr[3]
        dayFive = Weather.weatherArr[4]
        
        //currentCityLabel.text = "showing weather for: Santa Clara"
        currentCityLabel.text = "showing weather for: \(Weather.zipCode!)"
        //fix this hardcoded "Santa Clara"
        
        dayOneButton.setTitle("\(dayOne!)", for: .normal)
        dayOneButton.titleLabel?.minimumScaleFactor = 0.5
        dayOneButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        dayTwoButton.setTitle("\(dayTwo!)", for: .normal)
        dayTwoButton.titleLabel?.minimumScaleFactor = 0.5
        dayTwoButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        dayThreeButton.setTitle("\(dayThree!)", for: .normal)
        dayThreeButton.titleLabel?.minimumScaleFactor = 0.5
        dayThreeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        dayFourButton.setTitle("\(dayFour!)", for: .normal)
        dayFourButton.titleLabel?.minimumScaleFactor = 0.5
        dayFourButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        dayFiveButton.setTitle("\(dayFive!)", for: .normal)
        dayFiveButton.titleLabel?.minimumScaleFactor = 0.5
        dayFiveButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        dateLabel.text = Weather.getDate(0)
        monthLabel.text = Weather.getMonth(0).lowercased()
        dayLabel.text = Weather.getFullDayOfWeek(0).lowercased()
        
        update(0)
        dayOneButton.isSelected = true
        
        dayOneLabel.text = Weather.getDayOfWeek(0).lowercased()
        dayTwoLabel.text = Weather.getDayOfWeek(1).lowercased()
        dayThreeLabel.text = Weather.getDayOfWeek(2).lowercased()
        dayFourLabel.text = Weather.getDayOfWeek(3).lowercased()
        dayFiveLabel.text = Weather.getDayOfWeek(4).lowercased()
        
        var bool = false
        
        let ref = Database.database().reference().child("users").child(User.current.uid).child("likePic").child(picString)
        print(ref)
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? Bool
            if let value = value {
                bool = true
            }
            else {
                bool = false
            }
            dispatchGroup.leave()
        })
        dispatchGroup.notify(queue: .main, execute: {
            self.likeButton.isSelected = bool
        })
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        
        var bool = false
        
        let ref = Database.database().reference().child("users").child(User.current.uid).child("likePic").child(picString)
        print(ref)
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? Bool
            if let value = value {
                bool = true
            }
            else {
                bool = false
            }
            dispatchGroup.leave()
        })
        dispatchGroup.notify(queue: .main, execute: {
            if bool == true {
                LikeService.delete(for: self.picString, success: { (nil) in
                    self.likeButton.isSelected = false
                    return
                })
            }
            else {
                LikeService.create(for: self.picString) { (true) in
                    self.likeButton.isSelected = true
                    return
                }
            }
        })

        //        LikeService.isLiked(picString: picString)
    }
    //    @IBAction func optionsButton(_ sender: Any) {
    //        performSegue(withIdentifier: "showOptions", sender: nil)
    //    }
    
    @IBAction func chooseAgainButton(_ sender: Any) {
        
        let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinnerActivity.label.text = "Loading"
        spinnerActivity.isUserInteractionEnabled = false
        if dayOneButton.isSelected {
            update(0)
        }
        else if dayTwoButton.isSelected {
            update(1)
        }
        else if dayThreeButton.isSelected {
            update(2)
        }
        else if dayFourButton.isSelected {
            update(3)
        }
        else if dayFiveButton.isSelected {
            update(4)
        }
    
        spinnerActivity.hide(animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        moveViewDown()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "backSegue" {
                print("back button tapped")
            }
        }
    }
    
    
    
    @IBAction func unwindToViewController(_ segue: UIStoryboardSegue) {
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dayOneButtonTapped(_ sender: Any) {
        
        dayOneButton.isSelected = true
        
        dayFiveButton.isSelected = false
        dayFourButton.isSelected = false
        dayThreeButton.isSelected = false
        dayTwoButton.isSelected = false
        
        dateLabel.text = Weather.getDate(0)
        monthLabel.text = Weather.getMonth(0).lowercased()
        dayLabel.text = Weather.getFullDayOfWeek(0).lowercased()
        
        update(0)
    }
    
    @IBAction func dayTwoButtonTapped(_ sender: Any) {
        dayTwoButton.isSelected = true
        
        dayFiveButton.isSelected = false
        dayFourButton.isSelected = false
        dayThreeButton.isSelected = false
        dayOneButton.isSelected = false
        
        dateLabel.text = Weather.getDate(1)
        monthLabel.text = Weather.getMonth(1).lowercased()
        dayLabel.text = Weather.getFullDayOfWeek(1).lowercased()
        
        update(1)
    }
    
    @IBAction func dayThreeButtonTapped(_ sender: Any) {
        dayThreeButton.isSelected = true
        
        dayFiveButton.isSelected = false
        dayFourButton.isSelected = false
        dayTwoButton.isSelected = false
        dayOneButton.isSelected = false
        
        dateLabel.text = Weather.getDate(2)
        monthLabel.text = Weather.getMonth(2).lowercased()
        dayLabel.text = Weather.getFullDayOfWeek(2).lowercased()
        
        update(2)
    }
    
    @IBAction func dayFourButtonTapped(_ sender: Any) {
        dayFourButton.isSelected = true
        
        dayFiveButton.isSelected = false
        dayThreeButton.isSelected = false
        dayTwoButton.isSelected = false
        dayOneButton.isSelected = false
        
        dateLabel.text = Weather.getDate(3)
        monthLabel.text = Weather.getMonth(3).lowercased()
        dayLabel.text = Weather.getFullDayOfWeek(3).lowercased()
        
        update(3)

    }
    @IBAction func dayFiveButtonTapped(_ sender: Any) {
        dayFiveButton.isSelected = true
        
        dayFourButton.isSelected = false
        dayThreeButton.isSelected = false
        dayTwoButton.isSelected = false
        dayOneButton.isSelected = false
        
        dateLabel.text = Weather.getDate(4)
        monthLabel.text = Weather.getMonth(4).lowercased()
        dayLabel.text = Weather.getFullDayOfWeek(4).lowercased()
        
        update(4)
    }
    
    
    //    @IBAction func goButtonTapped(_ sender: Any) {
    //        if let txt = locationTextField.text{
    //            if(txt.characters.count == 5 ){
    //                let zip: Int = Int(locationTextField.text!)!
    //                Day.setZip(zipCode: zip)
    //                locationTextField.text = "\(zip)"
    //                if(Day.getCity().contains("no such city")){
    //                showError(bigErrorMsg: "You're in the middle of nowhere", smallErrorMsg: "Literally. Invalid zipcode; try again!")
    //                    return
    //                }
    //                else{
    //                    update()
    //                }
    //            }
    //            else{
    //                showError(bigErrorMsg: "You're in the middle of nowhere", smallErrorMsg: "Literally. Invalid zipcode; try again!")
    //                return
    //
    //            }
    //        }
    //        else{
    //            showError(bigErrorMsg: "You're in the middle of nowhere", smallErrorMsg: "Literally. Invalid zipcode; try again!")
    //            return
    //        }
    //
    //        view.endEditing(true)
    //        moveViewDown()
    //    }
    func moveViewUp() {
        if topMarginConstraint.constant != originalTopMargin {
            return
        }
        
        topMarginConstraint.constant -= 135
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    func moveViewDown() {
        if topMarginConstraint.constant == originalTopMargin {
            return
        }
        
        topMarginConstraint.constant = originalTopMargin
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        
    }
    
    private func showError(bigErrorMsg: String, smallErrorMsg: String){
        let alertController = UIAlertController(title: "\(bigErrorMsg)", message:
            "\(smallErrorMsg)", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func update(_ day: Int) {
        let pic = Weather.getPicture(day)
        picString = pic
        outfitImage.image = UIImage(named: "\(pic)")
        iconImage.image = UIImage(named: Weather.iconArr[day])
        
        let ref = Database.database().reference().child("users").child(User.current.uid).child("likePic").child(picString)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? Bool
            if let _ = value {
                self.likeButton.isSelected = true
            }
            else {
                self.likeButton.isSelected = false
            }
        })
    }
    
}

