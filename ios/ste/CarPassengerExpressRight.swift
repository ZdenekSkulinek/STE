//
//  CarPassengerGreen
//  ste
//
//  Created by Zdeněk Skulínek on 31.07.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import CoreGraphics

class CarPassengerExpressRight :  Car
{
    var xPosition:Double
    
    required init(position:Double = 0.0 ) {
        
        xPosition = position
        
    }
    
    
    func move( offset:Double) {
        
        xPosition += offset
    }
    
    
    func getLength() -> Double {
        
        return 2388
    }
    
    
    func getHeight() -> Double {
        
        return 509
    }
    
    
    func getPosition() -> Double {
        
        return xPosition
    }
    
    
    func getFrontChasis() -> Double {
        
        return 262
    }
    
    
    func getRearChasis() -> Double {
        
        return 1876
    }
    
    
    func getFrontSpace() -> Double {
        
        return 30
    }
    
    
    func getRearSpace() -> Double {
        
        return 2359
    }
    
    
    func getRect()->CGRect {
        
        return CGRect(x: xPosition, y: CAR_POSY, width: getLength(), height: getHeight())
    }
    
    func getBitmapName()->String {
        
        return "passenger_car_express_right.png"
    }
    
    func getSolidRect()->CGRect {
        
        return CGRect(x: xPosition + getFrontSpace(), y: CAR_POSY, width: -getFrontSpace() + getRearSpace(), height: getHeight())
    }
    
}
