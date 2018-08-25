//
//  ExpandedFaveViewController.swift
//  WeatherDresser
//
//  Created by Kristie Huang on 8/11/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import Foundation
import UIKit

class ExpandedFavesViewController : UIViewController {
    
    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBOutlet weak var buyButton: UIButton!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bestTemperatureLabel: UILabel!
    @IBOutlet weak var storeLabel: UILabel!
    
    @IBOutlet weak var occasionLabel: UILabel!


    @IBOutlet weak var itemImage: UIImageView!
    
    @IBAction func buyButtonTapped(_ sender: Any) {
        
        UIApplication.shared.openURL(NSURL(string: (item?.link)!)! as URL)
    }
    
    var ind: Int = 0
    var item: Clothing? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        ind = FavoritesViewController.ind
        item = FavoritesViewController.arrPics[ind]
        
        itemNameLabel.text = item?.title
        priceLabel.text = item?.price
        bestTemperatureLabel.text = item?.temp
        storeLabel.text = "Dynamite Clothing"
        
        let url = URL(string: (item?.imageLink)!)
        let data = try? Data(contentsOf: url!) //make sure image in this url does exist, otherwise unwrap in a if let check / try-catch
        itemImage.image = UIImage(data: data!)
    }
    
    override func viewDidLoad() {
        
        

        
        super.viewDidLoad()

        
        
    }
    
}
