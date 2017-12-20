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
    @IBOutlet weak var personPhone: UILabel!

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
        personPhone.text = passenger?.phoneNumber
        personName.text = passenger?.displayName
        personInfo.text = passenger?.info
        personImage.image = UIImage(data: NSData(contentsOf: URL(string: passenger!.photoURL)!)! as Data)
        personDestination.text = passenger?.destination
        personName.backgroundColor = UIColor.white
        personTime.backgroundColor = UIColor.white
        personDestination.backgroundColor = UIColor.white
        personInfo.backgroundColor = UIColor.white
        personPhone.backgroundColor = UIColor.white
    }
    
    @IBAction func orderBtnPressed() {
        let seatRef = DataService.ds.refPassangers.child(passenger!.uid).child("hasSeat")
        seatRef.observeSingleEvent(of: .value) { (snapshot) in
            var seatLeft:Int = Int(snapshot.value as! String)!
            if seatLeft > 0 {
                seatLeft -= 1
            }
            seatRef.parent?.updateChildValues(["hasSeat": "\(seatLeft)"])
        }
        
    }

    
    
    
    
    
    
    
    
}
