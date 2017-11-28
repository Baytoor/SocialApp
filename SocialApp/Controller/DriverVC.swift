//
//  FeedVC.swift
//  SocialApp
//
//  Created by baytoor on 11/23/17.
//  Copyright © 2017 unicorn. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class DriverVC: UIViewController {
    
    @IBOutlet weak var addBtn: UIBarButtonItem!
    @IBOutlet weak var popUp: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fromField: UITextField!
    @IBOutlet weak var toField: UITextField!
    @IBOutlet weak var timeFromField: UITextField!
    @IBOutlet weak var timeTillField: UITextField!
    
    var drivers = [OtherUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closePopUp()
        view.backgroundColor = UIColor(darkBlue)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.updateList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Auth.auth().currentUser?.reload()
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        openPopUp()
    }
    
    @IBAction func closeBtnPressed(_ sender: UIButton) {
        closePopUp()
    }
    
    @IBAction func addDriverBtnPressed(_ sender: Any){
        if (Auth.auth().currentUser?.isEmailVerified)! {
            if (fromField.text != "" || toField.text != "" || timeFromField.text != ""  || timeTillField.text != "")  {
                let user = User.init("\(timeFromField.text!) - \(timeTillField.text!)", "\(fromField.text!) ~> \(toField.text!)", "5")
                if user.phoneNumber != "" || user.displayName != "" {
                    DataService.ds.createDriver(user)
                    closePopUp()
                } else {
                    confirmAlert(message: "Please, fill your information in settings")
                }
            } else {
                confirmAlert(message: "Field is empty, please enter all fields")
            }
        } else {
            emailVerifyAlert()
        }
    }
    
    @IBAction func swapDestination(_ sender: Any){
        let temp = fromField.text
        fromField.text = toField.text
        toField.text = temp
    }
    
    @IBAction func checkMaxLength() {
        if (timeFromField.text?.count)! > 5 {
            timeFromField.deleteBackward()
        }
        if (timeTillField.text?.count)! > 5 {
            timeTillField.deleteBackward()
        }
    }
    
    func openPopUp() {
        fromField.becomeFirstResponder()
        tableView.isScrollEnabled = false
        tableView.alpha = 0.5
        popUp.isHidden = false
        addBtn.isEnabled = false
        
    }
    
    func closePopUp() {
        self.view.endEditing(true)
        tableView.isScrollEnabled = true
        tableView.alpha = 1
        popUp.isHidden = true
        addBtn.isEnabled = true
        fromField.text = ""
        toField.text = ""
        timeFromField.text = ""
        timeTillField.text = ""
    }
    
    func updateList() {
        DataService.ds.refDrivers.observe(.value) { (snapshot) in
            self.drivers.removeAll()
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let userData = snap.value as? Dictionary<String, Any> {
                        let uid = snap.key
                        let passanger = OtherUser.init(uid, userData)
                        self.drivers.append(passanger)
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func emailVerifyAlert() {
        let refreshAlert = UIAlertController(title: "Error", message: "Your email address has not yet been verified. Do you want us to send another verification email to \(User.init().email).", preferredStyle: .alert)
        refreshAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (_) in
            sendEmailVerification()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(refreshAlert, animated: true, completion: nil)
        closePopUp()
    }
    
    func confirmAlert(message: String) {
        let refreshAlert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        refreshAlert.addAction(UIAlertAction(title: "Okay", style: .default))
        present(refreshAlert, animated: true, completion: nil)
        closePopUp()
    }
    
    func copyAlert(user: String, phone: String) {
        let refreshAlert = UIAlertController(title: "Copy phone number?", message: user, preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        refreshAlert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (action: UIAlertAction!) in
            UIPasteboard.general.string = phone
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
}


extension DriverVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drivers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PassangerCell") as? PassangerCell {
            cell.configureCell(otherUser: drivers[indexPath.row])
            return cell
        }
        return PassangerCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        copyAlert(user: drivers[indexPath.row].displayName, phone: drivers[indexPath.row].phoneNumber)
    }
    
}
















