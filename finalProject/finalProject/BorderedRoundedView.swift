//
//  BorderedRoundedView.swift
//  finalProject
//
//  Created by Giovanni Gatto on 12/11/15.
//  Copyright © 2015 Giovanni Gatto. All rights reserved.
//

import Foundation

import UIKit

@IBDesignable

class BorderedRoundedView: UIButton {
    
    
    @IBInspectable var cornerRadius :CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
            //only mask to bounds if corner radius is greater than 0
            //mask to bounds clips corners of box to make rounded
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor : UIColor? {
        didSet {
            layer.borderColor = borderColor?.CGColor
            //this sets UIcolor to CGcolor
        }
    }
    
}