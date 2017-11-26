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
//    private var _interests: [String]
    
    
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
        } else {
            _displayName = ""
        }
        if let email = Auth.auth().currentUser?.email{
            _email = email
        } else {
            _email = ""
        }
        if let phoneNumber = Auth.auth().currentUser?.phoneNumber {
            _phoneNumber = phoneNumber
        } else {
            _phoneNumber = ""
        }
        if let photoURL = Auth.auth().currentUser?.photoURL {
            _photoURL = "\(photoURL)"
        } else {
            _photoURL = "https://avpn.asia/wp-content/uploads/2015/05/empty_profile.png"
        }
        _uid = (Auth.auth().currentUser?.uid)!
        _info = "SDU, student"
        _time = ""
        _destination = ""
        _hasSeat = ""
        _faculty = ""
        _course = ""
    }
    
    convenience init(_ faculty: String, _ course: String) {
        self.init()
        self._info = "\(faculty), \(course)"
        self._faculty = faculty
        self._course = course
    }
    
    convenience init(_ time: String, _ destination: String, _ hasSeat: String) {
        self.init()
        self._time = time
        self._destination = destination
        self._hasSeat = hasSeat
    }
    
    
}
