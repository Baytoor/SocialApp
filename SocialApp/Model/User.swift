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
    private var _faculty: String
    private var _course: String
    private var _info: String
    private var _time: String
    private var _destination: String
    private var _hasSeat: String
    private var _isDriver: Int
//    private var _imageData: Data
//    private var _interests: [String]
    
    var isDriver: Int {
        return _isDriver
    }
//    var imageData: Data {
//        return _imageData
//    }
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
    var faculty: String {
        return _faculty
    }
    var course: String {
        return _course
    }
//    var interests: [String] {
//        return _interests
//    }

    init() {
        if let displayName = Auth.auth().currentUser?.displayName{
            _displayName = displayName
        } else if let displayName = defaults.string(forKey: "displayName") {
            _displayName = displayName
        } else {
            _displayName = ""
        }
        if let email = Auth.auth().currentUser?.email{
            _email = email
        } else {
            _email = ""
        }
        if let phoneNumberFB = Auth.auth().currentUser?.phoneNumber {
            _phoneNumber = phoneNumberFB
        } else if let phoneNumberUD = defaults.string(forKey: "phoneNumber") {
            _phoneNumber = phoneNumberUD
        } else {
            _phoneNumber = ""
        }
//        do {
//            if let imageData = defaults.data(forKey: "imageData") {
//                _imageData = imageData
//            }  else {
//                _imageData = try Data(contentsOf: (Auth.auth().currentUser?.photoURL)!)
//            }
//        } catch {
//            _imageData = UIImagePNGRepresentation(#imageLiteral(resourceName: "noPhoto"))! as Data
//        }
        if let photoURL = Auth.auth().currentUser?.photoURL {
            _photoURL = "\(photoURL)"
        } else {
            _photoURL = "https://github.com/Baytoor/SocialApp/blob/master/SocialApp/Assets.xcassets/noPhoto.imageset/noPhoto.png"
        }
        _uid = (Auth.auth().currentUser?.uid)!
        _time = ""
        _destination = ""
        _hasSeat = ""
        if let faculty = defaults.string(forKey: "faculty") {
            _faculty = faculty
        } else {
            _faculty = ""
        }
        if let course = defaults.string(forKey: "course") {
            _course = course
        } else {
            _course = ""
        }
        
        let isDriverUD = defaults.integer(forKey: "isDriver") 
        _isDriver = isDriverUD
        
        _info = ""
        if _faculty != "" && _course != "" {
            _info = "\(_faculty), \(_course) course"
        } else if _faculty != "" {
            _info = _faculty
        } else if _course != "" {
            _info = _course
        }
    }
    
    convenience init(_ time: String, _ destination: String, _ hasSeat: String) {
        self.init()
        self._time = time
        self._destination = destination
        self._hasSeat = hasSeat
    }
    
    
}
