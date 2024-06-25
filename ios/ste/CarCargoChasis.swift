//
//  CarCargoChasis
//  ste
//
//  Created by Zdeněk Skulínek on 31.07.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import CoreGraphics

class CarCargoChasis :  Car
{
    var xPosition:Double
    
    required init(position:Double = 0.0) {
        
        xPosition = position
        
    }
    
    
    func move( offset:Double) {
        
        xPosition += offset
    }
    
    
    func getLength() -> Double {
        
        return 2458
    }
    
    
    func getHeight() -> Double {
        
        return 182
    }
    
    
    func getPosition() -> Double {
        
        return xPosition
    }
    
    
    func getFrontChasis() -> Double {
        
        return 283
    }
    
    
    func getRearChasis() -> Double {
        
        return 1951
    }
    
    
    func getFrontSpace() -> Double {
        
        return 81
    }
    
    
    func getRearSpace() -> Double {
        
        return 2450
    }
    
    
    func getRect()->CGRect {
        
        return CGRect(x: xPosition, y: CAR_POSY, width: getLength(), height: getHeight())
    }
    
    func getBitmapName()->String {
        
        return "cargo_car_chasis.png"
    }
    
    func getSolidRect()->CGRect {
        
        return CGRect(x: xPosition + getFrontSpace(), y: CAR_POSY, width:  -getFrontSpace() + getRearSpace(), height: getHeight())
    }
    
}
