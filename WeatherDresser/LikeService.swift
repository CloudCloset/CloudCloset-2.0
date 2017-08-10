//
//  LikeService.swift
//  WeatherDresser
//
//  Created by Lily Li on 8/10/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct LikeService {
    static func create(for pic: String, success: @escaping (Bool) -> Void) {
        
        let currentUID = User.current.uid
        
        let likesRef = Database.database().reference().child("users").child(currentUID).child("likePic").child(pic)
        likesRef.setValue(true) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            }
            
            return success(true)
        }
    }
    
    static func delete(for pic: String, success: @escaping (Bool) -> Void) {
        
        let currentUID = User.current.uid
        
        let likesRef = Database.database().reference().child("users").child(currentUID).child("likePic").child(pic)
        likesRef.setValue(nil) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            }
            
            return success(true)
        }
    }
}
