//
//  User.swift
//  SocialApp
//
//  Created by baytoor on 11/25/17.
//  Copyright © 2017 unicorn. All rights reserved.
//

//let uid = user.uid
//let email = user.email
//let photoURL = user.photoURL
//let name = user.displayName
//let phoneNumber = user.phoneNumber

import Foundation
import Firebase
import SwiftKeychainWrapper

class User {
    
    private var _uid: String
    private var _displayName: String
    private var _email: String
    private var _photoURL: String
    private var _phoneNumber: String
    private var _info: String
    private var _time: String
    private var _destination: String
    private var _hasSeat: String
    private var _isDriver: Int
    private var _isVerified: Bool
    
    var isVerified: Bool {
        return _isVerified
    }
    var isDriver: Int {
        return _isDriver
    }
    var uid: String {
        return _uid
    }
    var displayName: String {
        return _displayName
    }
    var email: String {
        return _email
    }
    var photoURL: String {
        return _photoURL
    }
    var phoneNumber: String {
        return _phoneNumber
    }
    var info: String {
        return _info
    }
    var time: String {
        return _time
    }
    var destination: String {
        return _destination
    }
    var hasSeat: String {
        return _hasSeat
    }
    
    init() {
        if let displayName = Auth.auth().currentUser?.displayName{
            _displayName = displayName
        } else {
            _displayName = ""
        }
        if let email = Auth.auth().currentUser?.email{
            _email = email
        } else {
            _email = ""
        }
        if (Auth.auth().currentUser?.isEmailVerified)! {
            _isVerified = true
        } else {
            _isVerified = false
        }
        if let phoneNumberFB = Auth.auth().currentUser?.phoneNumber {
            _phoneNumber = phoneNumberFB
        } else if let phoneNumberUD = defaults.string(forKey: "phoneNumber") {
            _phoneNumber = phoneNumberUD
        } else {
            _phoneNumber = ""
        }
        if let photoURL = Auth.auth().currentUser?.photoURL {
            _photoURL = "\(photoURL)"
        } else {
            _photoURL = "https://github.com/Baytoor/SocialApp/blob/master/SocialApp/Assets.xcassets/noPhoto.imageset/noPhoto.png"
        }
        _uid = (Auth.auth().currentUser?.uid)!
        _time = ""
        _destination = ""
        _hasSeat = ""
        _info = ""
        if let info = defaults.string(forKey: "info"){
            _info = info
        } else {
            _info = ""
        }
        
        let isDriverUD = defaults.integer(forKey: "isDriver") 
        _isDriver = isDriverUD
        
    }
    
    convenience init(_ time: String, _ destination: String, _ hasSeat: String) {
        self.init()
        self._time = time
        self._destination = destination
        self._hasSeat = hasSeat
    }
    
    
}
