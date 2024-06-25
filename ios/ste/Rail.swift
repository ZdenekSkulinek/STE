//
//  Rail.swift
//  ste
//
//  Created by Zdeněk Skulínek on 16.10.17.
//  Copyright © 2017 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

let RAIL_HEIGHT:Double = 25.0
let RAIL_LENGTH:Double = 76.0

class Rail: NSObject {
    
    var xPosition:Double
    var length:Int
    
    public
    
    init(length:Int, xPosition:Double) {
        self.xPosition = xPosition
        self.length = length
    }
    
    
    func setXPosition(xPosition:Double) {
        self.xPosition = xPosition
    }
    
    func getLength()->Int {
        return length
    }
    
    func updateWithManSpeed(manSpeed:Double) {
        xPosition += manSpeed
    }
    
    func getRect()->CGRect {
        
        return CGRect(x: xPosition , y: 0.0 , width: RAIL_LENGTH * Double(length), height: BULLET_HEIGHT )
    }
    
    func getBitmapName()->String {
        
        return "rail.png"
    }
}
