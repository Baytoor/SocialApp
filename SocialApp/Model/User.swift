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
    
    private var _uid: String = (Auth.auth().currentUser?.uid)!
    private var _displayName: String = (Auth.auth().currentUser?.displayName)!
    private var _email: String = (Auth.auth().currentUser?.email)!
    private var _photoURL: URL = (Auth.auth().currentUser?.photoURL)!
    private var _phoneNumber: String = (Auth.auth().currentUser?.phoneNumber)!
//    private var _faculty: String
//    private var _course: String
//    private var _interest: [String]
//    private var _type: Bool
    
//    var uid: String {
//        return _uid
//    }
//    var displayName: String {
//        return _displayName
//    }
//    var email: String {
//        return _email
//    }
//    var photoURL: URL {
//        return _photoURL
//    }
//    var phoneNumber: String {
//        return _phoneNumber
//    }
//    var faculty: String {
//        return _faculty
//    }
//    var course: String {
//        return _course
//    }
//
//    init(_ user: Auth, _ faculty: String, _ course: String) {
//        _uid = user.currentUser!.uid
//        _displayName = user.currentUser!.displayName!
//        _email = user.currentUser!.email!
//        _photoURL = user.currentUser!.photoURL!
//        _phoneNumber = user.currentUser!.phoneNumber!
//        _faculty = faculty
//        _course = course
//    }
 
}
