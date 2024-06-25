//
//  CarCargoPipes
//  ste
//
//  Created by Zdeněk Skulínek on 31.07.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import CoreGraphics

class CarCargoPipes :  Car
{
    var xPosition:Double
    
    required init(position:Double = 0.0) {
        
        xPosition = position
        
    }
    
    
    func move( offset:Double) {
        
        xPosition += offset
    }
    
    
    func getLength() -> Double {
        
        return 2103
    }
    
    
    func getHeight() -> Double {
        
        return 542
    }
    
    
    func getPosition() -> Double {
        
        return xPosition
    }
    
    
    func getFrontChasis() -> Double {
        
        return 172
    }
    
    
    func getRearChasis() -> Double {
        
        return 1701
    }
    
    
    func getFrontSpace() -> Double {
        
        return 165
    }
    
    
    func getRearSpace() -> Double {
        
        return 1940
    }
    
    
    func getRect()->CGRect {
        
        return CGRect(x: xPosition, y: CAR_POSY, width: getLength(), height: getHeight())
    }
    
    func getBitmapName()->String {
        
        return "cargo_car_pipes.png"
    }
    
    func getSolidRect()->CGRect {
        
        return CGRect(x: xPosition + getFrontSpace(), y: CAR_POSY, width: -getFrontSpace() + getRearSpace(), height: getHeight())
    }
}
