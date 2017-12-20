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

class PassengersVC: UIViewController {
    
    @IBOutlet weak var addBtn: UIBarButtonItem!
    @IBOutlet weak var popUp: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fromField: UITextField!
    @IBOutlet weak var toField: UITextField!
    @IBOutlet weak var timeFromField: UITextField!
    @IBOutlet weak var timeTillField: UITextField!
    
    var passengers = [OtherUser]()
    var refreshControl: UIRefreshControl!
    var bottomConstraints: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        if !isInternetAvailable() {
            refreshControl.attributedTitle = NSAttributedString(string: "Check your internet connection")
        } else {
            refreshControl.attributedTitle = NSAttributedString(string: "")
        }
        refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: UIControlEvents.valueChanged)
//        refresh(sender: self)
        
        tableView.addSubview(refreshControl)
        
        closePopUp()
        view.backgroundColor = UIColor(darkBlue)
        
        tableView.delegate = self
        tableView.dataSource = self
        fromField.delegate = self
        toField.delegate = self
        timeFromField.delegate = self
        timeTillField.delegate = self
        
        bottomConstraints = NSLayoutConstraint(item: popUp, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraints!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: Notification.Name.UIKeyboardWillHide, object: nil)

    }
    
    @objc func handleKeyboardNotification(notification: Notification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let isKeyboardShowing = notification.name == Notification.Name.UIKeyboardWillShow
            
            if isKeyboardShowing {
                bottomConstraints?.constant = -keyboardFrame!.height + (self.tabBarController?.tabBar.frame.size.height)!
            } else {
                bottomConstraints?.constant = +keyboardFrame!.height - (self.tabBarController?.tabBar.frame.size.height)!
            }
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadUser()
    }
    
    @objc func refresh(sender: AnyObject) {
        
        if !isInternetAvailable() {
            refreshControl.attributedTitle = NSAttributedString(string: "Check your internet connection")
        } else {
            refreshControl.attributedTitle = NSAttributedString(string: "")
        }
        
        updateList {
            if (Auth.auth().currentUser?.isEmailVerified)! {
                UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.refreshControl.endRefreshing()
                }, completion: nil)
                self.tableView.reloadData()
            } else {
                self.refreshControl.attributedTitle = NSAttributedString(string: "Please, verify your email")
            }
        }
    }
    
    @IBAction func addPassangerBtnPressed(_ sender: Any){
        if (fromField.text!.count>1 && toField.text!.count>1 && timeFromField.text!.count>1)  {
            var user = User.init()
            if  checkDate(time: timeFromField.text!) && checkDate(time: timeTillField.text!) {
                user = User.init("\(timeFromField.text!) - \(timeTillField.text!)", "\(fromField.text!) ~> \(toField.text!)", "1")
                DataService.ds.createPassanger(user)
                closePopUp()
            } else if checkDate(time: timeFromField.text!) {
                user = User.init("\(timeFromField.text!)", "\(fromField.text!) ~> \(toField.text!)", "3")
                DataService.ds.createPassanger(user)
                closePopUp()
            }
        } else {
            confirmAlert(message: "Field is empty, please enter all fields")
        }
    }
    
    func updateList(completion: (()->Void)!) {
        DataService.ds.refPassangers.observeSingleEvent(of: .value) { (snapshot) in
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
            completion()
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
    
    @IBAction func addBtnPressed(_ sender: Any) {
        if (Auth.auth().currentUser?.isEmailVerified)!{
            if User.init().phoneNumber.count>1 || User.init().displayName.count>1  {
                openPopUp()
            } else {
                confirmAlert(message: "Please, fill your information in settings")
            }
        } else {
            emailVerifyAlert()
        }
    }
    
    @IBAction func closeBtnPressed(_ sender: UIButton) {
        closePopUp()
    }
    
    func checkDate(time: String) -> Bool {
        if time.count == 5 {
            let hm = time.components(separatedBy: ":")
            if let hour = Int(hm[0]), let min = Int(hm[1]){
                if hour>24 && min>60 {
                    confirmAlert(message: "Wrong format of time")
                    return false
                } else {
                    return true
                }
            }
        } else if time.count == 0 {
            return false
        }
        confirmAlert(message: "Wrong format of time")
        return false
    }
    
    func openPopUp() {
        fromField.becomeFirstResponder()
        tableView.isScrollEnabled = false
        tableView.isUserInteractionEnabled = false
        tableView.alpha = 0.5
        popUp.isHidden = false
        addBtn.isEnabled = false
        
    }
    
    func closePopUp() {
        self.view.endEditing(true)
        tableView.isScrollEnabled = true
        tableView.isUserInteractionEnabled = true
        tableView.alpha = 1
        popUp.isHidden = true
        addBtn.isEnabled = true
        fromField.text = ""
        toField.text = ""
        timeFromField.text = ""
        timeTillField.text = ""
    }
    
    //Alerts and sends email verification
    func emailVerifyAlert() {
        let refreshAlert = UIAlertController(title: "Error", message: "Your email address has not yet been verified. Do you want us to send another verification email to \(User.init().email).", preferredStyle: .alert)
        refreshAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (_) in
            sendEmailVerification()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func confirmAlert(message: String) {
        let refreshAlert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        refreshAlert.addAction(UIAlertAction(title: "Okay", style: .default))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func copyAlert(user: String, phone: String) {
        let refreshAlert = UIAlertController(title: "Copy phone number?", message: user, preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        refreshAlert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (action: UIAlertAction!) in
            UIPasteboard.general.string = phone
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination: PassengerVC = segue.destination as! PassengerVC
        destination.passenger = passengers[(tableView.indexPathForSelectedRow?.row)!]
    }
    
}

//Delegate and DataSource functions
extension PassengersVC: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case fromField:
                toField.becomeFirstResponder()
                break
            case toField:
                timeFromField.becomeFirstResponder()
                break
            case timeFromField:
                timeTillField.becomeFirstResponder()
            default:
                textField.resignFirstResponder()
        }
        return true
    }
    
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
//        copyAlert(user: passengers[indexPath.row].displayName, phone: passengers[indexPath.row].phoneNumber)
        if isInternetAvailable() {
            self.performSegue(withIdentifier: "PassengerVC", sender: self)
        } else {
            refresh(sender: self)
        }
    }
    
}
















