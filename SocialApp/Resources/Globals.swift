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

func setUserDefaults(compilation: (() -> Void)!) {
    let signedInUser = User.init()
    DataService.ds.refUsers.observe(.value) { (snapshot) in
        if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
            for snap in snapshot {
                if snap.key == signedInUser.uid {
                    if let userData = snap.value as? Dictionary<String, Any> {
                        if let phoneNumber = userData["phoneNumber"] {
                            defaults.set(phoneNumber, forKey: "phoneNumber")
                        }
                        if let info = userData["info"] {
                            defaults.set(info, forKey: "info")
                        }
                        if let isDriver = userData["isDriver"] {
                            defaults.set(isDriver, forKey: "isDriver")
                        }
                        if let isVerified = userData["isVerified"] {
                            defaults.set(isVerified, forKey: "isVerified")
                        }
                    }
                }
            }
            compilation()
        } else {
            compilation()
        }
    }
}

func uploadUser(){
    setUserDefaults {
        let user = User.init()
        DataService.ds.createUser(user)
    }
}


//DataService.ds.refDrivers.observe(.value) { (snapshot) in
//    self.drivers.removeAll()
//    if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
//        for snap in snapshot {
//            if let userData = snap.value as? Dictionary<String, Any> {
//                let uid = snap.key
//                let passanger = OtherUser.init(uid, userData)
//                self.drivers.append(passanger)
//            }
//        }
//    }
//    self.tableView.reloadData()
//}




















