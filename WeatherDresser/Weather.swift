//
//  Weather.swift
//  WeatherDresser
//
//  Created by Lily Li on 8/9/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import Foundation
import FirebaseDatabase


class Weather {
    
    static var weatherArr = [Int]()
    static var iconArr = [String]()
    static var dateArr = [Date]()
    
    private func getDatabase() {
        
    }
    
    static func reload() {
        let zip: Int = 94087
        
        let urlString = "http://api.openweathermap.org/data/2.5/forecast/daily?zip=\(zip),us&lang=en&units=Imperial&APPID=db2d26bbe612a3f926d3804997956ccb"
        let session = URLSession.shared
        let url = URL(string: urlString)
        
        let downloadGroup = DispatchGroup()
        downloadGroup.enter()
        
        let task = session.dataTask(with: url!) { (data, response, error) in
            if let data = data {
                let json = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                let temperatureDict = json["list"] as! NSArray
                for index in 1 ... 5{
                    let today = temperatureDict[index] as! NSDictionary
                    let unixValue = today["dt"] as! Double
                    let todaysTemp = today["temp"] as! NSDictionary
                    let maxTemp = todaysTemp["max"] as! NSInteger
                    let minTemp = todaysTemp["min"] as! NSInteger
                    let avgTemp = (maxTemp + minTemp)/2
                    let date = NSDate(timeIntervalSince1970: unixValue) as Date
                    
                    let todaysWeather = today["weather"] as! NSArray
                    let weather = todaysWeather[0] as! NSDictionary
                    let todayDescription = weather["main"] as! NSString as String
                    
                    var todayIcon = ""
                    
                    if(todayDescription.lowercased().contains("clear")){
                        todayIcon = "Sun"
                    }
                    else if(todayDescription.lowercased().contains("clouds")){
                        todayIcon = "Cloudy"
                    }
                    else if(todayDescription.lowercased().contains("rain")){
                        todayIcon = "Rainy"
                    }
                    else{
                        todayIcon = "Partly Cloudy"
                    }
                    
                    iconArr.append(todayIcon)
                    dateArr.append(date)
                    weatherArr.append(avgTemp)
                    
                }
                downloadGroup.leave()
            }
        }
        task.resume()
        downloadGroup.wait()
    }
    
    static func getPicture(_ day: Int) -> String {
        let randInt: Int = Int(arc4random_uniform(10) + 1)
        let temp = weatherArr[day]
        
        if(temp < 50){
            return "Cold\(randInt)"
        }
        else if(temp < 60 && temp >= 50){
            return "MedCold\(randInt)"
        }
        else if(temp < 70 && temp >= 60){
            return "MedHot\(randInt)"
        }
        else if(temp >= 80){
            return "Hot\(randInt)"
            
        }
        else{
            return "MedHot\(randInt)"
        }
    }
    
    static func getUnixString(_ day: Int) -> String {
        let date = dateArr[day]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: date)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd-MMM-EEEE-yyyy"
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
    }
    
    static func getFullDayOfWeek(_ int: Int) -> String {
        let str = getUnixString(int)
        var dateArr = str.components(separatedBy: "-")
        return dateArr[2]
    }
    
    static func getDate(_ int: Int) -> String{
        let str = getUnixString(int)
        var dateArr = str.components(separatedBy: "-")
        return dateArr[0]
    }
    
    static func getMonth(_ int: Int) -> String {
        let str = getUnixString(int)
        var dateArr = str.components(separatedBy: "-")
        return dateArr[1]
    }
    static func getDayOfWeek(_ int: Int)-> String{
        let str = getUnixString(int)
        var dateArr = str.components(separatedBy: "-")
        return dateArr[2]
    }
    


}
