//
//  CarCargoContainer
//  ste
//
//  Created by Zdeněk Skulínek on 31.07.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import CoreGraphics

class CarCargoContainer :  Car
{
    var xPosition:Double
    
    required init(position:Double) {
        
        xPosition = position
        
    }
    
    
    func move( offset:Double) {
        
        xPosition += offset
    }
    
    
    func getLength() -> Double {
        
        return 2140
    }
    
    
    func getHeight() -> Double {
        
        return 580
    }
    
    
    func getPosition() -> Double {
        
        return xPosition
    }
    
    
    func getFrontChasis() -> Double {
        
        return 172
    }
    
    
    func getRearChasis() -> Double {
        
        return 1729
    }
    
    
    func getFrontSpace() -> Double {
        
        return 74
    }
    
    
    func getRearSpace() -> Double {
        
        return 2066
    }
    
    
    func getRect()->CGRect {
        
        return CGRect(x: xPosition, y: CAR_POSY, width: getLength(), height: getHeight())
    }
    
    func getBitmapName()->String {
        
        return "cargo_car_container.png"
    }
    
    func getSolidRect()->CGRect {
        
        return CGRect(x: xPosition + getFrontSpace(), y: CAR_POSY, width: -getFrontSpace() + getRearSpace(), height: getHeight())
    }
    
}
