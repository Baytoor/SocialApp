//
//  DataService.swift
//  SocialApp
//
//  Created by baytoor on 11/26/17.
//  Copyright © 2017 unicorn. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let ds = DataService()
    
    private var _refBase = dataBase
    private var _refPassangers = dataBase.child("passengers")
    private var _refDrivers = dataBase.child("drivers")
    private var _refUsers = dataBase.child("users")
    
    var refBase: DatabaseReference {
        return _refBase
    }
    var refPassangers: DatabaseReference {
        return _refPassangers
    }
    var refDrivers: DatabaseReference {
        return _refDrivers
    }
    var refUsers: DatabaseReference {
        return _refUsers
    }
    
    func createDriver(_ user: User){
        refDrivers.child(user.uid).updateChildValues(setUserData(user))
    }
    
    func createPassanger(_ user: User) {
        refPassangers.child(user.uid).updateChildValues(setUserData(user))
    }
    
    func createUser(_ user: User){
        let userData = ["displayName": user.displayName, "email": user.email, "info": user.info, "phoneNumber": user.phoneNumber, "photoURL": user.photoURL, "isDriver": user.isDriver, "isVerified": user.isVerified as Any] as [String : Any]
        refUsers.child(user.uid).updateChildValues(userData)
    }
    
    private func setUserData(_ user: User) -> Dictionary<String, String>{
        let userData = ["displayName": user.displayName, "email": user.email, "destination": user.destination, "hasSeat": user.hasSeat, "info": user.info, "phoneNumber": user.phoneNumber, "photoURL": user.photoURL, "time": user.time, "postedDay": "\(NSCalendar.current.component(.day, from: Date()))"]
        return userData
    }
    
    private func setInterestsData(_ interests: [String]) -> Dictionary<Int, String>{
        var interestsData: Dictionary = [Int: String]()
        for i in 0..<interests.count {
            interestsData[i] = interests[i]
        }
        return interestsData
    }
    
}
