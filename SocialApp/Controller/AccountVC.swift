//
//  AccountVC.swift
//  SocialApp
//
//  Created by baytoor on 11/24/17.
//  Copyright © 2017 unicorn. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class AccountVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem?.action = #selector(self.signOutBtnPressed(_:))
    }

    @IBAction func signOutBtnPressed(_ sender: UIBarButtonItem) {
        print("MSG: Signed Out")
        KeychainWrapper.standard.removeObject(forKey: keyUID)
        try! Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
        print("MSG: Signed out")
    }

}
