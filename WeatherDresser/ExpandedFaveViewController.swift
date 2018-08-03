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
    @IBOutlet weak var percentageCodeLabel: UILabel!
    
    @IBOutlet weak var occasionLabel: UILabel!
    
    
    var itemsArr: [Outfit] = []
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBAction func buyButtonTapped(_ sender: Any) {
        
        UIApplication.shared.openURL(NSURL(string: "http://www.kqzyfj.com/click-8431052-11757792?url=http%3A%2F%2Ftracking.lengow.com%2FshortUrl%2F8769-146981-100029176BLACKCOMBO%2F&cjsku=100029176BLACKCOMBO")! as URL)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "http://www.awltovhc.com/image-8431052-11757792?imgurl=http%3A%2F%2Fimages.gdicdn.com%2Fimages%2Fproduct%2F100029176%2F100029176_290_1000x728.jpg")!
        let data = try? Data(contentsOf: url)
        
        if let imageData = data {
            let image = UIImage(data: data!)
            itemImage.image = image
        }
        
        //
        //
        //        let item = itemsArr[indexPath]
        //        itemImage.image = item.image
        //        itemNameLabel.text = item.name
        //        priceLabel.text = item.price
        //        bestTemperatureLabel.text = item.temp
        //        storeLabel.text = item.store
        
        
        
        do {
            if let xmlUrl = Bundle.main.url(forResource: "Dynamite_Clothing-Dynamite_US_Google_Product_Feed-shopping 2", withExtension: "xml") {
                
                let xml = try String(contentsOf: xmlUrl)
                let clothesParser = ClothesParser(withXML: xml)
                
                
                let clothes = clothesParser.parse()
                
                for item in clothes {
                    
                    if item.longDesc.contains("crop") {
                        print("summer")
                    }
                }
            }
        }
        catch {
            print(error)
        }

        
        
        
    }
    
}
