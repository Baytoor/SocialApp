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

class PassengerVC: UIViewController {
    
    @IBOutlet weak var addBtn: UIBarButtonItem!
    @IBOutlet weak var popUp: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fromField: UITextField!
    @IBOutlet weak var toField: UITextField!
    @IBOutlet weak var timeFromField: UITextField!
    @IBOutlet weak var timeTillField: UITextField!
    
    var passengers = [OtherUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closePopUp()
        view.backgroundColor = UIColor(darkBlue)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.updateList()
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        openPopUp()
    }
    
    @IBAction func closeBtnPressed(_ sender: UIButton) {
        closePopUp()
    }
    
    @IBAction func addPassangerBtnPressed(_ sender: Any){
        if (Auth.auth().currentUser?.isEmailVerified)! {
            if (fromField.text != "" || toField.text != "" || timeFromField.text != ""  || timeTillField.text != "")  {
                let user = User.init("\(timeFromField.text!) - \(timeTillField.text!)", "\(fromField.text!) ~> \(toField.text!)", "5")
                if user.phoneNumber != "" {
                    DataService.ds.createPassanger(user)
                    closePopUp()
                } else {
                    confirmAlert(message: "Please, fill your information in settings")
                }
            } else {
                confirmAlert(message: "Field is empty, please enter all fields")
            }
        } else {
            confirmAlert(message: "Please verify your email")
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
        DataService.ds.refPassangers.observe(.value) { (snapshot) in
            self.passengers.removeAll()
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let userData = snap.value as? Dictionary<String, Any> {
                        let uid = snap.key
                        let passanger = OtherUser.init(uid, userData)
                        self.passengers.append(passanger)
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func confirmAlert(message: String) {
        let refreshAlert = UIAlertController(title: "SDU companion", message: message, preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Back", style: .cancel))
        present(refreshAlert, animated: true, completion: nil)
        closePopUp()
    }
    
    func copyAlert(user: String, phone: String) {
        print("MSG: Alert")
        let refreshAlert = UIAlertController(title: "SDU companion", message: "Copy number of \(user)?", preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        refreshAlert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (action: UIAlertAction!) in
            UIPasteboard.general.string = phone
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
}


extension PassengerVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passengers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PassangerCell") as? PassangerCell {
            cell.configureCell(otherUser: passengers[indexPath.row])
            return cell
        }
        return PassangerCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        copyAlert(user: passengers[indexPath.row].displayName, phone: passengers[indexPath.row].phoneNumber)
    }
    
}
















