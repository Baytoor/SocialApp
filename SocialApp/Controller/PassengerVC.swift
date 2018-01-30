//
//  PassengeraVC.swift
//  SocialApp
//
//  Created by baytoor on 12/16/17.
//  Copyright © 2017 unicorn. All rights reserved.
//

import UIKit

class PassengerVC: UIViewController {
    
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var personTime: UILabel!
    @IBOutlet weak var personDestination: UILabel!
    @IBOutlet weak var personInfo: UILabel!

    var passenger: OtherUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        personImage.layer.cornerRadius = personImage.frame.width/2
        personImage.layer.masksToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setInfo()
    }

    func setInfo() {
        personTime.text = passenger?.time
        personName.text = passenger?.displayName
        personInfo.text = passenger?.info
        personImage.image = passenger?.image
        personDestination.text = passenger?.destination
        personName.backgroundColor = UIColor.white
        personTime.backgroundColor = UIColor.white
        personDestination.backgroundColor = UIColor.white
        personInfo.backgroundColor = UIColor.white
    }
    
    @IBAction func orderBtnPressed() {
        guard isInternetAvailable() else { noInternetConnectionError(); return }
        
        let seatRef = DataService.ds.refPassangers.child(passenger!.uid).child("hasSeat")
        seatRef.observeSingleEvent(of: .value) { (snapshot) in
            var seatLeft:Int = Int(snapshot.value as! String)!
            if seatLeft > 0 {
                seatLeft -= 1
            }
            seatRef.parent?.updateChildValues(["hasSeat": "\(seatLeft)"])
            seatRef.parent?.child("driver").updateChildValues([User.init().uid: "me"])
        }
    }
    
    @IBAction func callBtnPressed(_ sender: Any){
        if let url = URL(string: "TEL://\(passenger!.phoneNumber)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func noInternetConnectionError() {
        let refreshAlert = UIAlertController(title: "No internet connection", message: "Please check your internet connection", preferredStyle: .alert)
        refreshAlert.addAction(UIAlertAction(title: "Okay", style: .default))
        present(refreshAlert, animated: true, completion: nil)
    }
    
}
