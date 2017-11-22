//
//  ViewController.swift
//  SocialApp
//
//  Created by baytoor on 11/12/17.
//  Copyright © 2017 unicorn. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import FirebaseAuth

class LaunchPageVC: UIViewController {

    @IBOutlet weak var facebook: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        facebook.setImage(#imageLiteral(resourceName: "facebook").maskWithColor(color: UIColor(lightBlue)), for: .highlighted)
    }

    @IBAction func signInPage(_ sender: Any) {
        self.performSegue(withIdentifier: "SignInVC", sender: self)
    }
    
    @IBAction func fbRegisterBtn(_ sender: Any){
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("MSG: Unable to authenticate with facebook \(String(describing: error))")
            } else if result?.isCancelled == true {
                print("MSG: User cancelled facebook authentication")
            } else {
                print("MSG: Succesfully authenticated with facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }

    func firebaseAuth(_ credential: AuthCredential ) {
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("MSG: Unable to authenticate with firebase \(String(describing: error))")
            } else {
                print("MSG: Succesfully authenticated with firebase")
            }
        }
    }
        
        
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "SignInVC" {
//            let destination = segue.destination as! SignInVC
//
//        }
//    }
}










