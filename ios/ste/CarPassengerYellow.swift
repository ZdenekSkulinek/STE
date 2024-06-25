//
//  CarPassengerYellow
//  ste
//
//  Created by Zdeněk Skulínek on 31.07.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import CoreGraphics

class CarPassengerYellow :  Car
{
    var xPosition:Double
    
    required init(position:Double = 0.0 ) {
        
        xPosition = position
        
    }
    
    
    func move( offset:Double) {
        
        xPosition += offset
    }
    
    
    func getLength() -> Double {
        
        return 3136
    }
    
    
    func getHeight() -> Double {
        
        return 540
    }
    
    
    func getPosition() -> Double {
        
        return xPosition
    }
    
    
    func getFrontChasis() -> Double {
        
        return 320
    }
    
    
    func getRearChasis() -> Double {
        
        return 2595
    }
    
    
    func getFrontSpace() -> Double {
        
        return 55
    }
    
    
    func getRearSpace() -> Double {
        
        return 3181
    }
    
    
    func getRect()->CGRect {
        
        return CGRect(x: xPosition, y: CAR_POSY, width: getLength(), height: getHeight())
    }
    
    func getBitmapName()->String {
        
        return "passenger_car_yellow.png"
    }
    
    func getSolidRect()->CGRect {
        
        return CGRect(x: xPosition + getFrontSpace(), y: CAR_POSY, width: -getFrontSpace() + getRearSpace(), height: getHeight())
    }
}
