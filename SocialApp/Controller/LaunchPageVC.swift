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
import SwiftKeychainWrapper

class LaunchPageVC: UIViewController {

    @IBOutlet weak var facebook: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        facebook.setImage(#imageLiteral(resourceName: "facebook").maskWithColor(color: UIColor(lightBlue)), for: .highlighted)
        errorLbl.isHidden = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.textFieldShouldReturn(_:)))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: keyUID) {
            performSegue(withIdentifier: "accessApp", sender: nil)
        }
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        if let email = emailField.text, let pass = passField.text {
            if pass.count >= 6 {
            Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
                if error == nil {
                    print("MSG: User authenticated with firebase using email")
                    if let user = user {
                        self.completeSignIn(id: user.uid)
                    }
                } else {
                    let errCode = AuthErrorCode(rawValue: error!._code)
                    if errCode == AuthErrorCode.userNotFound{
                        Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
                            if error != nil {
                                print("MSG: Unable to authenticate with firebase using email")
                            } else {
                                print("MSG: New user was created usting email")
                                if let user = user {
                                    self.completeSignIn(id: user.uid)
                                }
                            }
                        })
                    } else if errCode == AuthErrorCode.invalidEmail {
                        self.errorLbl.isHidden = false
                        self.errorLbl.text = "Invalid email"
                        self.errorLbl.textColor = UIColor.red
                    } else if errCode == AuthErrorCode.wrongPassword {
                        self.errorLbl.isHidden = false
                        self.errorLbl.text = "Wrong password"
                        self.errorLbl.textColor = UIColor.red
                    }
                }
            })
            } else {
                errorLbl.isHidden = false
                errorLbl.text = "Password must have 6 characters"
                errorLbl.textColor = UIColor.red
            }
            
        }
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
                if let user = user {
                    self.completeSignIn(id: user.uid)
                }
                
            }
        }
    }
    
    func completeSignIn(id: String) {
        let saveSuccessful: Bool = KeychainWrapper.standard.set(id, forKey: keyUID)
        if saveSuccessful {
            print("MSG: Data saved to keychain")
        }
        performSegue(withIdentifier: "accessApp", sender: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "SignInVC" {
//            let destination = segue.destination as! SignInVC
//
//        }
//    }
}










