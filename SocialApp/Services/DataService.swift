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
    private var _refPassangers = dataBase.child("passanger")
    
    var refBase: DatabaseReference {
        return _refBase
    }
    var refPassangers: DatabaseReference {
        return _refPassangers
    }
    
    func createFBDBUser(uid: String, userData: Dictionary<String, String>) {
        refPassangers.child(uid).updateChildValues(userData)
    }
    
}
