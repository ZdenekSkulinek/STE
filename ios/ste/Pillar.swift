//
//  Pillar.swift
//  ste
//
//  Created by Zdeněk Skulínek on 11.09.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import CoreGraphics

let PILLAR_ROPE_POSITION_Y = 746.0

class Pillar :  ModelObjectBase
{
    var xPosition:Double
    
    required init(position:Double) {
        
        xPosition = position
        
    }
    
    
    func move( offset:Double) {
        
        xPosition += offset
    }
    
    
    func getLength() -> Double {
        
        return 147.0
    }
    
    
    func getHeight() -> Double {
        
        return 800.0
    }
    
    
    func getPosition() -> Double {
        
        return xPosition
    }
    
    func setPosition( position: Double) {
    
        xPosition = position
    }
    
    
    func getRect()->CGRect {
        
        return CGRect(x: xPosition, y: CAR_POSY, width: getLength(), height: getHeight())
    }
    
    func getRopePositionX()->Double {
    
        return 38.0
    }
    
    func getRopePositionY()->Double {
        
        return PILLAR_ROPE_POSITION_Y
    }
    
    func getBitmapName()->String {
        
        return "pillar.png"
    }
    
}
