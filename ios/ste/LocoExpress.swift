//
//  LocoExpress
//  ste
//
//  Created by Zdeněk Skulínek on 31.07.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import CoreGraphics

class LocoExpress :  Loco
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
        
        return 2633
    }
    
    
    func getHeight() -> Double {
        
        return 509
    }
    
    
    func getPosition() -> Double {
        
        return xPosition
    }
    
    
    func getFrontChasis() -> Double {
        
        return 504
    }
    
    
    func getRearChasis() -> Double {
        
        return 2121
    }
    
    
     func getEndOfGamePosition() -> Double {
        
        return 752
    }
    
    
    func getRearSpace() -> Double {
        
        return 2605
    }
    
    
    func getRect()->CGRect {
        
        return CGRect(x: xPosition, y: CAR_POSY, width: getLength(), height: getHeight())
    }
    
    func getBitmapName()->String {
        
        return "loco_express.png"
    }
    
    
    func getDoorRect()->CGRect {
        
        return CGRect(x: 698.0 + xPosition, y: 143 + CAR_POSY, width: 107.0, height: 256.0 )
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
