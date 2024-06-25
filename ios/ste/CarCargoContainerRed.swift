//
//  CarCargoContainerRed
//  ste
//
//  Created by Zdeněk Skulínek on 31.07.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import CoreGraphics

class CarCargoContainerRed :  Car
{
    var xPosition:Double
    
    required init(position:Double = 0.0) {
        
        xPosition = position
        
    }
    
    
    func move( offset:Double) {
        
        xPosition += offset
    }
    
    
    func getLength() -> Double {
    
        return 2454
    }
    
    
    func getHeight() -> Double {
        
        return 550
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
        
        return 2443
    }
    
    
    func getRect()->CGRect {
        
        return CGRect(x: xPosition, y: CAR_POSY, width: getLength(), height: getHeight())
    }
    
    func getBitmapName()->String {
        
        return "cargo_car_container_red.png"
    }
    
    func getSolidRect()->CGRect {
        
        return CGRect(x: xPosition + getFrontSpace(), y: CAR_POSY, width: -getFrontSpace() + getRearSpace(), height: getHeight())
    }
    
}