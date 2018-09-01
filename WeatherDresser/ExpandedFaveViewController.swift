//
//  ExpandedFaveViewController.swift
//  WeatherDresser
//
//  Created by Kristie Huang on 8/11/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class ExpandedFavesViewController : UIViewController {
    
    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBOutlet weak var buyButton: UIButton!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bestTemperatureLabel: UILabel!
    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBAction func likeButtonTapped(_ sender: Any) {
        
        var bool = false
        
        let ref = Database.database().reference().child("users").child(User.current.uid).child("likePic").child(item.id)
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
                LikeService.delete(for: self.item.id, success: { (nil) in
                    self.likeButton.isSelected = false
                    return
                })
            }
            else {
                LikeService.create(for: self.item.id) { (true) in
                    self.likeButton.isSelected = true
                    return
                }
            }
        })
        

    }



    @IBOutlet weak var itemImage: UIImageView!
    
    @IBAction func buyButtonTapped(_ sender: Any) {
        
        UIApplication.shared.openURL(NSURL(string: item.link)! as URL)
    }
    
    var ind: Int = 0
    var item: Clothing = Clothing()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        ind = FavoritesViewController.ind
        item = FavoritesViewController.arrPics[ind]
        
        priceLabel.text = item.price
        bestTemperatureLabel.text = item.temp
        categoryLabel.text = item.category
        descLabel.text = item.description
        
        var newTitle = item.title
        if item.title.contains("Garage") {
            let r = item.title.index(item.title.startIndex, offsetBy: 8)..<item.title.endIndex
            newTitle = item.title[r]
            storeLabel.text = "Garage Clothing"

        }
        
        else if item.title.contains("Dynamite") {
            let r = item.title.index(item.title.startIndex, offsetBy: 10)..<item.title.endIndex
            newTitle = item.title[r]
            storeLabel.text = "Dynamite Clothing"

        }
        
        itemNameLabel.text = newTitle

        
        let url = URL(string: item.imageLink)
        let data = try? Data(contentsOf: url!)
        itemImage.image = UIImage(data: data!)
        
        
        
        
        
        
        
        var bool = false
        
        let ref = Database.database().reference().child("users").child(User.current.uid).child("likePic").child(item.id)
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
    
    override func viewDidLoad() {
        
        

        
        super.viewDidLoad()

        
        
    }
    
}
