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
    
    var itemsArr: [Outfit] = []
    @IBOutlet weak var itemImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        let item = itemsArr[indexPath]
//        itemImage.image = item.image
//        itemNameLabel.text = item.name
//        priceLabel.text = item.price
//        bestTemperatureLabel.text = item.temp
//        storeLabel.text = item.store


        
    }
    
}
