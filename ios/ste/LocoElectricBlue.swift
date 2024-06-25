//
//  LocoElectricBlue
//  ste
//
//  Created by Zdeněk Skulínek on 31.07.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import CoreGraphics

class LocoElectricBlue :  Loco
{
    var xPosition:Double
    var animState:EAnimationStates
    var animOffset: Double
    
    required init() {
        
        xPosition = 0
        animState = EAnimationStates.ANIMATION_NONE
        animOffset = 0
        
    }
    
    
    func move( offset:Double) {
        
        xPosition += offset
    }
    
    
    func getLength() -> Double {
        
        return 2336
    }
    
    
    func getHeight() -> Double {
        
        return 487
    }
    
    
    func getPosition() -> Double {
        
        return xPosition
    }
    
    
    func getFrontChasis() -> Double {
        
        return 318
    }
    
    
    func getRearChasis() -> Double {
        
        return 1318
    }
    
    
     func getEndOfGamePosition() -> Double {
        
        return 1968
    }
    
    
    func getRearSpace() -> Double {
        
        return 1880
    }
    
    
    func getRect()->CGRect {
        
        return CGRect(x: xPosition, y: CAR_POSY, width: getLength(), height: getHeight())
    }
    
    func getBitmapName()->String {
        
        return "loco_blue.png"
    }
    
    
    func getDoorRect()->CGRect {
        
        return CGRect(x: 325 + xPosition, y: 695.0 - 488.0 + CAR_POSY, width: 411.0 - 325.0, height: 488.0 - 290.0)
    }
    
    
    func getAnimState()->EAnimationStates {
        
        return animState
    }
    
    
    func getAnimOffset()->Double {
        
        return animOffset
    }
    
    func setAnimState( state:EAnimationStates ) {
        
        animState = state
    }
    
    
    func setAnimOffset( offset: Double ) {
        
        animOffset = offset
    }
    
    func getSolidRect()->CGRect {
    
    return CGRect(x: xPosition , y: CAR_POSY, width: getRearSpace(), height: getHeight())
    }
}
