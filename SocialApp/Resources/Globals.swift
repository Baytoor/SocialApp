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

func uploadUser(){
    setUserDefaults {
        let user = User.init()
        DataService.ds.createUser(user)
    }
}

func setUserDefaults(compilation: (() -> Void)!) {
    let signedInUser = User.init()
    DataService.ds.refUsers.observe(.value) { (snapshot) in
        if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
            for snap in snapshot {
                if snap.key == signedInUser.uid {
                    if let userData = snap.value as? Dictionary<String, Any> {
                        if let phoneNumber = userData["phoneNumber"] {
                            defaults.set(phoneNumber, forKey: "phoneNumber")
                        } else {
                            defaults.set("", forKey: "phoneNumber")
                        }
                        if let info = userData["info"] {
                            defaults.set(info, forKey: "info")
                        } else {
                            defaults.set("", forKey: "info")
                        }
                        if let isDriver = userData["isDriver"] {
                            defaults.set(isDriver, forKey: "isDriver")
                        } else {
                            defaults.set("", forKey: "isDriver")
                        }
                        if let isVerified = userData["isVerified"] {
                            defaults.set(isVerified, forKey: "isVerified")
                        } else {
                            defaults.set("", forKey: "isVerified")
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

func reloadUser() {
    Auth.auth().currentUser?.reload(completion: { (error) in
        if error != nil {
            print("MSG: Unable to reload user")
        } else {
            
            
        }
    })
}

func sendEmailVerification() {
    if !User.init().isVerified {
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            if error != nil {
                print("MSG: Enable to send verification message")
            } else {
                print("MSG: Verification letter was sent")
            }
        })
    }
}

func signOut() {
    KeychainWrapper.standard.removeObject(forKey: keyUID)
    try! Auth.auth().signOut()
    defaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    print("MSG: Signed out")
}














