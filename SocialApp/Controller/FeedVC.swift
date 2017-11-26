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

class FeedVC: UIViewController {
    
    @IBOutlet weak var popUp: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fromField: UITextField!
    @IBOutlet weak var toField: UITextField!
    @IBOutlet weak var timeFromField: UITextField!
    @IBOutlet weak var timeTillField: UITextField!
    
    let inter = ["car", "startup", "mercedes"]
    var passangers = [OtherUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateList()
        closePopUp()
        view.backgroundColor = UIColor(darkBlue)
        tableView.delegate = self
        tableView.dataSource = self
        
        let user = User.init("Information System", "2", inter, "14:20 - 14:40", "Tolebi 21 ~> SDU", "1")
        DataService.ds.createPassanger(user)
        
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        openPopUp()
    }
    
    @IBAction func closeBtnPressed(_ sender: UIButton) {
        closePopUp()
        self.view.endEditing(true)
    }
    
    func openPopUp() {
        fromField.becomeFirstResponder()
        tableView.isScrollEnabled = false
        tableView.alpha = 0.5
        popUp.isHidden = false
    }
    
    func closePopUp() {
        tableView.isScrollEnabled = true
        tableView.alpha = 1
        popUp.isHidden = true
    }
    
    func updateList() {
        DataService.ds.refPassangers.observe(.value) { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                self.tableView.reloadData()
                for snap in snapshot {
                    if let userData = snap.value as? Dictionary<String, Any> {
                        let uid = snap.key
                        let passanger = OtherUser.init(uid, userData)
                        self.passangers.append(passanger)
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
}

extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passangers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PassangerCell") as? PassangerCell {
            cell.update(otherUser: passangers[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
}















