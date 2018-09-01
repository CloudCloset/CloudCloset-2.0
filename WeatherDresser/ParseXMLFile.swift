//
//  ParseXMLFile.swift
//  WeatherDresser
//
//  Created by Kristie Huang on 8/2/18.
//  Copyright © 2018 Lily Li. All rights reserved.
//

import Foundation
//: Playground - noun: a place where people can play

import UIKit

class Clothing: CustomStringConvertible {
    
    var title = ""
    

    var description = ""
    var category = ""
    var link = ""
    var id = ""
    var imageLink = ""
    var price = ""; //"29.95 USD" is a string!!
    
    
    var temp = ""
    
    
    var longDesc: String {
        return "" + title + description + category;
    }
    
    init(title:String = "", description:String = "", link:String = "", id:String = "", imageLink:String = "", price:String = "", temp:String = "", longDesc:String = "") {
        
    
    }

}




class ClothesParser: NSObject {
    var xmlParser: XMLParser?
    var clothesArr: [Clothing] = []
    var xmlText = ""
    var currentItem: Clothing?
    
    init(withXML xml: String) {
        
        if let data = xml.data(using: String.Encoding.utf8) {
            xmlParser = XMLParser(data: data)
        }
    }
    
    func parse() -> [Clothing] {
        
        xmlParser?.delegate = self
        xmlParser?.parse()
        return clothesArr
    }
}




extension ClothesParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        xmlText = "" //reset text everytime u didStartElement
        
        if elementName == "entry" {
            currentItem = Clothing();
        }
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "title" {
            currentItem?.title = xmlText.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        }
        if elementName == "id" {
            currentItem?.id = xmlText.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        }
        if elementName == "description" {
            currentItem?.description = xmlText.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        }
        if elementName == "product_type" {
            currentItem?.category = xmlText.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        }
        if elementName == "link" {
            currentItem?.link = xmlText.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        }
        if elementName == "image_link" {
            currentItem?.imageLink = xmlText.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        }
        if elementName == "sale_price" {
            currentItem?.price = xmlText.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        }
        
        //FOR INTS
        //        if elementName == "NUMBERRR" {
        //            if let rating = Int(xmlText) {
        //                currentItem?.NUMBER = rating;
        //            }
        //        }
        
        if elementName == "entry" { //end of object node
            
            if let item = currentItem {
                clothesArr.append(item)
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        xmlText += string
    }
    
}



