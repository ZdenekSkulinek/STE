//
//  LocoDieselYellow
//  ste
//
//  Created by Zdeněk Skulínek on 31.07.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import CoreGraphics

class LocoDieselYellow :  Loco
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
        
        return 2238
    }
    
    
    func getHeight() -> Double {
        
        return 222
    }
    
    
    func getPosition() -> Double {
        
        return xPosition
    }
    
    
    func getFrontChasis() -> Double {
        
        return 318
    }
    
    
    func getRearChasis() -> Double {
        
        return 1463
    }
    
    
     func getEndOfGamePosition() -> Double {
    
        return 1802
    }
    
    
    func getRearSpace() -> Double {
        
        return 2140
    }
    
    
    func getRect()->CGRect {
        
        return CGRect(x: xPosition, y: CAR_POSY, width: getLength(), height: getHeight())
    }
    
    func getBitmapName()->String {
        
        return "loco_yellow.png"
    }
    
    
    func getDoorRect()->CGRect {
        
        return CGRect(x: 1223 + xPosition, y: 222 + CAR_POSY, width: 115, height: 216)
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
