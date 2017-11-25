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

let keyUID = "uid"

func getUserInfo() {
    let user = Auth.auth().currentUser
    if let user = user {
        let uid = user.uid
        let email = user.email
        let photoURL = user.photoURL
        let name = user.displayName
        let phoneNumber = user.phoneNumber
        print("UserID:\(uid)\nEmail:\(String(describing: email))\nPhoto:\(String(describing: photoURL))\nName:\(String(describing: name))\nPhoneNumber:\(String(describing: phoneNumber))")
    }
}
