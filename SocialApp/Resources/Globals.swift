//
//  Globals.swift
//  SocialApp
//
//  Created by baytoor on 11/12/17.
//  Copyright © 2017 unicorn. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let darkBlue = 0x2D3E4F
let lightBlue = 0x1DB4DD
let gray = 0xAEAEAE

let dataBase = Database.database().reference()
let storage = Storage.storage().reference()

let keyUID = "kq8bQx2eMx01hAlv"

let defaults = UserDefaults.standard

func setUserDefaults() {
    let signedInUser = User.init()
    defaults.set(signedInUser.displayName, forKey: "displayName")
    defaults.set(signedInUser.email, forKey: "email")
    defaults.set(signedInUser.phoneNumber, forKey: "phoneNumber")
    defaults.set(signedInUser.course, forKey: "course")
    defaults.set(signedInUser.faculty, forKey: "faculty")
    defaults.set(signedInUser.uid, forKey: "uid")
    defaults.set(signedInUser.photoURL, forKey: "photoURL")
    defaults.set(signedInUser.isDriver, forKey: "isDriver")
    
    if defaults.string(forKey: "faculty") != "" && defaults.string(forKey: "course") != "" {
        defaults.set("\(defaults.string(forKey: "faculty")!), \(defaults.string(forKey: "course")!)", forKey: "info")
    } else if defaults.string(forKey: "faculty") != "" {
        defaults.set("\(defaults.string(forKey: "faculty")!)", forKey: "info")
    } else if defaults.string(forKey: "course") != "" {
        defaults.set("\(defaults.string(forKey: "course")!)", forKey: "info")
    }
}
