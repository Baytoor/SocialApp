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
    
    var isEditingMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfo()
        popUp.isHidden = true
        view.backgroundColor = UIColor(darkBlue)
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.textFieldShouldReturn(_:)))
//        view.addGestureRecognizer(tap)
        
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
    
//    @IBAction func editingMode(_ sender: Any) {
//        if !isEditingMode {
//            UIView.animate(withDuration: 0.3, animations: {
//                self.popUp.center.y = self.popUp.center.y-160
//            })
//            isEditingMode = true
//        }
//    }
//
//    func finishEditing() {
//        self.view.endEditing(true)
//        if isEditingMode{
//            UIView.animate(withDuration: 0.3, animations: {
//                self.popUp.center.y = self.popUp.center.y+160
//            })
//            isEditingMode = false
//        }
//    }
    
    
}
