//
//  Day.swift
//  WeatherDresser
//
//  Created by Lily Li on 7/6/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import Foundation

class Day {
    var day: Int?
    static var cityName: String = "Santa Clara"
    static var zip: String = "95054"
    init(day: Int){
        self.day = day
    }
    
    static func setZip(zipCode: String){
        zip = zipCode
    }
    
    func getWeather() -> Int {
        let urlString = "http://api.openweathermap.org/data/2.5/forecast/daily?zip=\(Day.zip),us&lang=en&units=Imperial&APPID=db2d26bbe612a3f926d3804997956ccb"
        let session = URLSession.shared
        let url = URL(string: urlString)
        var todayTemp: Int?
        
        let downloadGroup = DispatchGroup()
        downloadGroup.enter()
        
        let task = session.dataTask(with: url!) { (data, response, error) in
            
            if let data = data {
                
                let json = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                let temperatureDict = json["list"] as! NSArray
                let today = temperatureDict[self.day!] as! NSDictionary
                let todaysTemp = today["temp"] as! NSDictionary
                todayTemp = todaysTemp["max"] as! NSInteger
                downloadGroup.leave()
            }
        }
        
        task.resume()
        
        downloadGroup.wait()
        
        return todayTemp!
    }
    
    func getPicture() -> String {
        let randInt: Int = Int(arc4random_uniform(10) + 1)
        let temp = self.getWeather()
        
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
    
    static func getCity() -> String {
        let urlString = "http://api.openweathermap.org/data/2.5/forecast/daily?zip=\(Day.zip),us&lang=en&units=Imperial&APPID=db2d26bbe612a3f926d3804997956ccb"
        let session = URLSession.shared
        let url = URL(string: urlString)
        var city: String?
        
        let downloadGroup = DispatchGroup()
        downloadGroup.enter()
        
        let task = session.dataTask(with: url!) { (data, response, error) in
            
            if let data = data {
                let json = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                
                print(json["message"] as? NSString)
                
                if let mssg = json["message"] as? NSString{
                    if (mssg.contains("invalid zipcode") || mssg.contains("city not found")){
                        print("crash now")
                        city = "no such city"
                        print("no such city: \(city!)")
                    }
                }
                else{
                    let dict = json["city"] as! NSDictionary
                    city = dict["name"] as! NSString as String
                    Day.cityName = city!
                    print(city!)
                }
                
                downloadGroup.leave()
            }
        }
        
        task.resume()
        
        downloadGroup.wait()
        
        return city!
    }
    
    private func getUnixString() -> String {
        
        let urlString = "http://api.openweathermap.org/data/2.5/forecast/daily?zip=\(Day.zip),us&lang=en&units=Imperial&APPID=db2d26bbe612a3f926d3804997956ccb"
        let session = URLSession.shared
        let url = URL(string: urlString)
        var unixValue: Double?
        
        let downloadGroup = DispatchGroup()
        downloadGroup.enter()
        
        let task = session.dataTask(with: url!) { (data, response, error) in
            
            if let data = data {
                let json = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                
                let temperatureDict = json["list"] as! NSArray
                let today = temperatureDict[self.day!] as! NSDictionary
                unixValue = today["dt"] as! Double
                
                downloadGroup.leave()
            }
        }
        
        task.resume()
        
        downloadGroup.wait()
        
        let date = NSDate(timeIntervalSince1970: unixValue!) as Date
        print(date)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: date)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd-MMM-EEE-yyyy"
        let myStringafd = formatter.string(from: yourDate!)
        
        print(myStringafd)
        return myStringafd
    }
    
    func getFullDayOfWeek() -> String {
        let urlString = "http://api.openweathermap.org/data/2.5/forecast/daily?zip=\(Day.zip),us&lang=en&units=Imperial&APPID=db2d26bbe612a3f926d3804997956ccb"
        let session = URLSession.shared
        let url = URL(string: urlString)
        var unixValue: Double?
        
        let downloadGroup = DispatchGroup()
        downloadGroup.enter()
        
        let task = session.dataTask(with: url!) { (data, response, error) in
            
            if let data = data {
                let json = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                
                let temperatureDict = json["list"] as! NSArray
                let today = temperatureDict[self.day!] as! NSDictionary
                unixValue = today["dt"] as! Double
                
                downloadGroup.leave()
            }
        }
        
        task.resume()
        
        downloadGroup.wait()
        
        let date = NSDate(timeIntervalSince1970: unixValue!) as Date
        print(date)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: date)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd-M-EEEE-y"
        let myStringafd = formatter.string(from: yourDate!)
        
        let dateArr = myStringafd.components(separatedBy: "-")
  
        print(dateArr[2])
        
        return dateArr[2]
    }
    
    func getDate() -> String{
        let dateStr = getUnixString()
        var dateArr = dateStr.components(separatedBy: "-")
        return dateArr[0]
    }
    
    func getMonth() -> String {
        let dateStr = getUnixString()
        var dateArr = dateStr.components(separatedBy: "-")
        return dateArr[1]
    }
    func getDayOfWeek()-> String{
        let dateStr = getUnixString()
        var dateArr = dateStr.components(separatedBy: "-")
        return dateArr[2]
    }
    
    func getIcon() -> String{
        let urlString = "http://api.openweathermap.org/data/2.5/forecast/daily?zip=\(Day.zip),us&lang=en&units=Imperial&APPID=db2d26bbe612a3f926d3804997956ccb"
        let session = URLSession.shared
        let url = URL(string: urlString)
        var todayIcon: String?
        var todayDescription: String?
        
        let downloadGroup = DispatchGroup()
        downloadGroup.enter()
        
        let task = session.dataTask(with: url!) { (data, response, error) in
            
            if let data = data {
                let json = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                
                let temperatureDict = json["list"] as! NSArray
                let today = temperatureDict[self.day!] as! NSDictionary
                let todaysWeather = today["weather"] as! NSArray
                let weather = todaysWeather[0] as! NSDictionary
                todayDescription = weather["main"] as! NSString as String
                downloadGroup.leave()
            }
        }
        
        task.resume()
        
        downloadGroup.wait()
        
        if(todayDescription?.lowercased().contains("clear"))!{
            todayIcon = "Sun"
        }
        else if(todayDescription?.lowercased().contains("clouds"))!{
            todayIcon = "Cloudy"
        }
        else if(todayDescription?.lowercased().contains("rain"))!{
            todayIcon = "Rainy"
        }
        else{
            todayIcon = "Partly Cloudy"
        }
        return todayIcon!
    }
}
