//
//  Rope.swift
//  ste
//
//  Created by Zdeněk Skulínek on 11.09.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import CoreGraphics

let SCREEN_ROPE_POSX = 0.0
let SCREEN_ROPE_POSY = PILLAR_ROPE_POSITION_Y + CAR_POSY - SCREEN_ROPE_HEIGHT
let SCREEN_ROPE_LENGTH = 2000.0
let SCREEN_ROPE_HEIGHT = 100.0
let SCREEN_ROPE_STEP = 20.0
let CONST_ROPE_A = 1.0
let SCREEN_ROPE_WIDTH = 3.0 //pixels





class Rope :  ModelObjectBase
{
    var xPosition:Double
    
    required init(position:Double) {
        
        xPosition = position
        
    }
    
    
    func move( offset:Double) {
        
        xPosition += offset
    }
    
    
    func getLength() -> Double {
        
        return SCREEN_ROPE_LENGTH
    }
    
    
    func getHeight() -> Double {
        
        return SCREEN_ROPE_HEIGHT
    }
    
    
    func getPosition() -> Double {
        
        return xPosition
    }
    
    func setPosition( position: Double) {
        
        xPosition = position
    }
    
    
    func getRect()->CGRect {
        
        return CGRect(x: SCREEN_ROPE_POSX + xPosition, y: SCREEN_ROPE_POSY, width: getLength(), height: getHeight())
    }
    
    func getBitmapName()->String {
        
        return ""
    }
    
}
