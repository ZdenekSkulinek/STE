//
//  Lintel.swift
//  ste
//
//  Created by Zdeněk Skulínek on 13.09.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import CoreGraphics

let SCREEN_LABEL_START_FIRST_APPEAR  = -2880.0 //pixels
let SCREEN_LABEL_START_FIRST_DURATION = 1280.0 //pixels
let SCREEN_LABEL_START_SECOND_APPEAR = -960.0 //pixels
let SCREEN_LABEL_START_SECOND_DURATION = 960.0 //pixels

class Lintel :  ModelObjectBase
{
    var xPosition:Double
    var yHeight:Double
    
    required init(position:Double) {
        
        xPosition = position
        yHeight = 1050.0
    }
    
    
    func move( offset:Double) {
        
        xPosition += offset
    }
    
    
    func getLength() -> Double {
        
        return 176.0
    }
    
    
    func getHeight() -> Double {
        
        return yHeight
    }
    
    
    func setHeight( height:Double ) {
        
        yHeight = height
    }
    
    
    func getPosition() -> Double {
        
        return xPosition
    }
    
    func setPosition( position: Double) {
        
        xPosition = position
    }
    
    
    func getRect()->CGRect {
        
        return CGRect(x: xPosition, y: CAR_POSY + yHeight - 1050.0, width: getLength(), height: 1050.0)
    }
    
    
    func getDangerousRect()->CGRect {
        
        return CGRect(x: xPosition, y: CAR_POSY + getHeight() - 138.0 , width: getLength(), height: 138.0 )
    }
    
    
    func isWarningShown()->Bool {
        
        if( xPosition >= SCREEN_LABEL_START_FIRST_APPEAR && xPosition <= ( SCREEN_LABEL_START_FIRST_APPEAR +
            SCREEN_LABEL_START_FIRST_DURATION ) ) {
        
            return true
        }
        if( xPosition >= SCREEN_LABEL_START_SECOND_APPEAR && xPosition <= ( SCREEN_LABEL_START_SECOND_APPEAR +
            SCREEN_LABEL_START_SECOND_DURATION ) ) {
            
            return true
        }
        return false
    }
    
    func getBitmapName()->String {
        
        return "pillar.png"
    }
    
}
