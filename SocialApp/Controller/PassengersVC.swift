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
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var buttonTF: UITextField!
    
    var cells: [PassangerCell] = []
    var passengers = [OtherUser]()
    var refreshControl: UIRefreshControl!
    var bottomConstraints: NSLayoutConstraint?
    
    override func viewDidAppear(_ animated: Bool) {
        reloadUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonView.isHidden = true
        buttonTF.isHidden = true
        buttonTF.backgroundColor = UIColor.clear
        buttonTF.textColor = UIColor.white
        
        refreshControl = UIRefreshControl()
        if !isInternetAvailable() {
            refreshControl.attributedTitle = NSAttributedString(string: "")
        } else {
            refreshControl.attributedTitle = NSAttributedString(string: "")
        }
        refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: UIControlEvents.valueChanged)
        
        refresh(sender: self)
        buttonInfoAppear(msg: "Uploading...", color: UIColor(hex: green))
        
        closePopUp()
        view.backgroundColor = UIColor(hex: darkBlue)
        
        tableView.addSubview(refreshControl)
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
    
    @objc func refresh(sender: AnyObject) {
        buttonInfoDisappear()
        if !isInternetAvailable() {
            refreshControl.endRefreshing()
            buttonInfoAppear(msg: "No internet connection", color: UIColor(hex: red))
        } else {
            refreshControl.attributedTitle = NSAttributedString(string: "")
        }
        updateList {
            self.refreshControl.endRefreshing()
            if (Auth.auth().currentUser?.isEmailVerified)! {
                self.tableView.reloadData()
                self.buttonInfoDisappear()
            } else {
                self.buttonInfoAppear(msg: "Verify your email, you can resend verification in settings", color: UIColor(hex: red))
            }
        }
    }
    
    @IBAction func addPassangerBtnPressed(_ sender: Any){
        if (fromField.text!.count>0 && toField.text!.count>0 && timeFromField.text!.count>0)  {
            var user = User.init()
            if timeTillField.text != "" || timeTillField.text == nil {
                if  checkDate(time: timeFromField.text!) && checkDate(time: timeTillField.text!) {
                    user = User.init("\(timeFromField.text!) - \(timeTillField.text!)", "\(fromField.text!) ~> \(toField.text!)", "1")
                    DataService.ds.createPassanger(user)
                    closePopUp()
                }
            } else {
                if checkDate(time: timeFromField.text!) && (timeTillField.text == "") {
                    user = User.init("\(timeFromField.text!)", "\(fromField.text!) ~> \(toField.text!)", "3")
                    DataService.ds.createPassanger(user)
                    closePopUp()
                }
            }
        } else {
            errorAlert(message: "Field is empty, please enter all fields")
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
    
    func buttonInfoAppear(msg: String, color: UIColor) {
        buttonView.isHidden = false
        buttonTF.isHidden = false
        buttonView.backgroundColor = color
        buttonTF.text = msg
    }
    
    func buttonInfoDisappear() {
        buttonView.isHidden = true
        buttonTF.isHidden = true
        buttonView.backgroundColor = UIColor.clear
        buttonTF.text = ""
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
                errorAlert(message: "Please, fill your information in settings")
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
                if hour<24 && hour>=0 && min<60 && min>=0 && (String(format: "%02d", hour)==hm[0]) && (String(format: "%02d", min)==hm[1]) {
                    print("MSG: \(hm[0]) is \(String(format: "%02d", hour)). \(hm[1]) is \(String(format: "%02d", min))")
                    return true
                }
            }
        } else if time.count != 5{
            errorAlert(message: "Wrong format of time")
            return false
        }
        errorAlert(message: "Wrong format of time")
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
        refreshAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: { (_) in
            sendEmailVerification()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func errorAlert(message: String) {
        let refreshAlert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        refreshAlert.addAction(UIAlertAction(title: "Okay", style: .default))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination: PassengerVC = segue.destination as! PassengerVC
        let indexPath = sender as! IndexPath
        let cell = cells[indexPath.row]
        destination.passenger = cell.person
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
            cells.insert(cell, at: indexPath.row)
            return cell
        }
        return PassangerCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "PassengerVC", sender: indexPath)
    }
    
}
















