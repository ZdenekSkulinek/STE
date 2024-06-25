//
//  LocoDieselModel
//  ste
//
//  Created by Zdeněk Skulínek on 31.07.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import CoreGraphics

class LocoDieselModel :  Loco
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
        
        return 2317
    }
    
    
    func getHeight() -> Double {
        
        return 550
    }
    
    
    func getPosition() -> Double {
        
        return xPosition
    }
    
    
    func getFrontChasis() -> Double {
        
        return 395
    }
    
    
    func getRearChasis() -> Double {
        
        return 1545
    }
    
    
     func getEndOfGamePosition() -> Double {
        
        return 1970
    }
    
    
    func getRearSpace() -> Double {
        
        return 2080
    }
    
    
    func getRect()->CGRect {
        
        return CGRect(x: xPosition, y: CAR_POSY , width: getLength(), height: getHeight())
    }
    
    func getBitmapName()->String {
        
        return "loco_model_diesel.png"
    }
    
    
    func getDoorRect()->CGRect {
        
        return CGRect(x: 350 + xPosition, y: 239 + CAR_POSY, width: 74, height: 206)
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
