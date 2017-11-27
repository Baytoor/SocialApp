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

    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var processingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var facebook: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        outProcess()
        emailField.text = ""
        passField.text = ""
        errorLbl.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        outProcess()
        emailField.text = ""
        passField.text = ""
        errorLbl.text = ""
        view.backgroundColor = UIColor(darkBlue)
        facebook.setImage(#imageLiteral(resourceName: "facebook").maskWithColor(color: UIColor(lightBlue)), for: .highlighted)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.textFieldShouldReturn(_:)))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: keyUID) {
            performSegue(withIdentifier: "accessApp", sender: nil)
            inProcess()
        }
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    func inProcess() {
        signInBtn.isEnabled = false
        signInBtn.setTitle("", for: .normal)
        facebook.isEnabled = false
        facebook.alpha = 0.5
        resetBtn.alpha = 0.5
        resetBtn.isEnabled = false
        logo.alpha = 0.5
        stackView.alpha = 0.5
        processingIndicator.isHidden = false
        processingIndicator.startAnimating()
    }
    
    func outProcess(){
        signInBtn.isEnabled = true
        signInBtn.setTitle("Sign In", for: .normal)
        facebook.isEnabled = true
        facebook.alpha = 1
        resetBtn.alpha = 1
        resetBtn.isEnabled = true
        logo.alpha = 1
        stackView.alpha = 1
        processingIndicator.isHidden = true
        processingIndicator.stopAnimating()
    }
    
    func errorDescription(_ error: String){
        outProcess()
        errorLbl.isHidden = false
        errorLbl.text = error
        errorLbl.textColor = UIColor.red
        signInBtn.isEnabled = true
    }
    
    
    
    
}

extension LaunchPageVC {
    @IBAction func signInPressed(_ sender: Any) {
        inProcess()
        self.view.endEditing(true)
        if let email = emailField.text, let pass = passField.text {
            if email=="" || pass=="" {
                errorDescription("Field is empty")
            } else if pass.count < 6 {
                errorDescription("Password must have at least 6 characters")
            } else {
                Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
                    if error == nil {
                        print("MSG: User authenticated with firebase using email")
                        self.completeSignIn(uid: (user?.uid)!)
                        self.newUser(completionHandler: {
                            self.performSegue(withIdentifier: "accessApp", sender: nil)
                        })
                    } else {
                        let errCode = AuthErrorCode(rawValue: error!._code)
                        if errCode == AuthErrorCode.userNotFound{
                            Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
                                if error != nil {
                                    print("MSG: Unable to authenticate with firebase using email")
                                    self.errorDescription("Unable to authenticate with firebase")
                                } else {
                                    print("MSG: New user was created using email")
                                    self.completeSignIn(uid: (user?.uid)!)
                                    self.newUser(completionHandler: {
                                        self.performSegue(withIdentifier: "accessApp", sender: nil)
                                    })
                                }
                            })
                        } else if errCode == AuthErrorCode.invalidEmail {
                            self.errorDescription("Invalid email")
                        } else if errCode == AuthErrorCode.wrongPassword {
                            self.errorDescription("Wrong password")
                        }
                    }
                })
            }
        }
    }
    
    @IBAction func fbRegisterBtn(_ sender: Any){
        inProcess()
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("MSG: Unable to authenticate with facebook \(String(describing: error))")
                self.errorDescription("Unable to authenticate with facebook")
            } else if result?.isCancelled == true {
                print("MSG: User cancelled facebook authentication")
                self.outProcess()
            } else {
                print("MSG: Succesfully authenticated with facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: AuthCredential ) {
        inProcess()
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("MSG: Unable to authenticate with firebase \(String(describing: error))")
                self.errorDescription("Unable to authenticate")
            } else {
                print("MSG: Succesfully authenticated with firebase")
                if let user = user {
                    self.completeSignIn(uid: user.uid)
                }
            }
        }
    }
    
    func completeSignIn(uid: String) {
        uploadUser()
        let saveSuccessful: Bool = KeychainWrapper.standard.set(uid, forKey: keyUID)
        if saveSuccessful {
            print("MSG: Data saved to keychain")
        }
        uploadUser()
        performSegue(withIdentifier: "accessApp", sender: nil)
    }
    
    @IBAction func resetPassword(_ sender: Any) {
        if emailField.text != nil || emailField.text != "" {
            Auth.auth().sendPasswordReset(withEmail: emailField.text!) { (error) in
                if error != nil {
                    print("MSG: Check correction of email. Unable to reset password")
                    self.confirmAlert(message: "Enter your mail to email field")
                } else {
                    self.confirmAlert(message: "Check your email, verification message was sent")
                    print("MSG: Password reset message was sent")
                }
            }
        } else {
            confirmAlert(message: "Enter your email to email field")
        }
    }
    
    func confirmAlert(message: String) {
        let refreshAlert = UIAlertController(title: "SDU companion", message: message, preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Back", style: .cancel))
        present(refreshAlert, animated: true, completion: nil)
        view.endEditing(true)
    }
    
    func newUser(completionHandler: (() -> Void)!) {
        if let user = Auth.auth().currentUser {
            if !user.isEmailVerified {
                user.sendEmailVerification(completion: { (error) in
                    if error != nil {
                        print("MSG: Error was occured")
                    } else {
                        print("MSG: Verification message was sent")
                        self.performSegue(withIdentifier: "accessApp", sender: nil)
                    }
                })
            }
        }
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        StorageServices.ss.uploadMedia(uid: User.init().uid, image: #imageLiteral(resourceName: "noPhoto"), completion:{ (url) in
            changeRequest?.photoURL = url
            changeRequest?.commitChanges { error in
                if error == nil {
                    completionHandler()
                } else {
                    self.errorDescription("Now it's not available to update profile image")
                    completionHandler()
                }
            }
        })
    }
    
}










