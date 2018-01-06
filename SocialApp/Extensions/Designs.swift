//
//  Designs.swift
//  SocialApp
//
//  Created by baytoor on 11/12/17.
//  Copyright © 2017 unicorn. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedBtn: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 5.0 {
        didSet {setUpView()}
    }
    override func prepareForInterfaceBuilder() {
        setUpView()
    }
    func setUpView() {
        layer.cornerRadius = self.cornerRadius
    }
}

//@IBDesignable
//class MaskedBtn: UIButton {
//    @IBInspectable var imageColor: String = "white" {
//        didSet {setColorView()}
//    }
//    override func prepareForInterfaceBuilder() {
//        setColorView()
//    }
//    func setColorView() {
//        if imageColor == "white" {
//            self.imageView?.image = self.imageView?.image?.maskWithColor(color: UIColor.white)
//        } else if imageColor == "lightblue" {
//            self.imageView?.image = self.imageView?.image?.maskWithColor(color: UIColor(hex: lightBlue))
//        } else {
//            self.imageView?.image = self.imageView?.image?.maskWithColor(color: UIColor(hex: darkBlue))
//        }
//    }
//}

