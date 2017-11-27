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

class OtherUser {

    private var _uid: String
    private var _displayName: String
    private var _email: String
    private var _photoURL: String
    private var _phoneNumber: String
    private var _info: String
    private var _time: String
    private var _destination: String
    private var _hasSeat: String

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

    init(_ uid: String, _ userData: Dictionary<String, Any>) {
        self._uid = uid
        if let displayName = userData["displayName"] as? String {
            self._displayName = displayName
        } else {
            self._displayName = ""
        }
        if let email = userData["email"] as? String {
            self._email = email
        } else {
            self._email = ""
        }
        if let phoneNumber = userData["phoneNumber"] as? String {
            self._phoneNumber = phoneNumber
        } else {
            self._phoneNumber = ""
        }
        if let photoURL = userData["photoURL"] as? String {
            self._photoURL = photoURL
        } else {
            self._photoURL = ""
        }
        if let info = userData["info"] as? String {
            self._info = info
        } else {
            self._info = ""
        }
        if let time = userData["time"] as? String {
            self._time = time
        } else {
            self._time = ""
        }
        if let destination = userData["destination"] as? String {
            self._destination = destination
        } else {
            self._destination = ""
        }
        if let hasSeat = userData["hasSeat"] as? String {
            self._hasSeat = hasSeat
        } else {
            self._hasSeat = ""
        }
        
    }



}


