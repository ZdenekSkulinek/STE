//
//  CarPassengerModel1
//  ste
//
//  Created by Zdeněk Skulínek on 31.07.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import CoreGraphics

class CarPassengerModel1 :  Car
{
    var xPosition:Double
    
    required init(position:Double = 0.0) {
        
        xPosition = position
        
    }
    
    
    func move( offset:Double) {
        
        xPosition += offset
    }
    
    
    func getLength() -> Double {
        
        return 2807
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
        
        return 216
    }
    
    
    func getFrontSpace() -> Double {
        
        return 50
    }
    
    
    func getRearSpace() -> Double {
        
        return 2757
    }
    
    
    func getRect()->CGRect {
        
        return CGRect(x: xPosition, y: CAR_POSY, width: getLength(), height: getHeight())
    }
    
    func getBitmapName()->String {
        
        return "passenger_car_1.png"
    }
    
    func getSolidRect()->CGRect {
        
        return CGRect(x: xPosition + getFrontSpace(), y: CAR_POSY, width: -getFrontSpace() + getRearSpace(), height: getHeight())
    }
}
