//
//  CarPassengerHistoricL
//  ste
//
//  Created by Zdeněk Skulínek on 31.07.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import CoreGraphics

class CarPassengerHistoricL :  Car
{
    var xPosition:Double
    
    required init(position:Double = 0.0 ) {
        
        xPosition = position
        
    }
    
    
    func move( offset:Double) {
        
        xPosition += offset
    }
    
    
    func getLength() -> Double {
        
        return 258
    }
    
    
    func getHeight() -> Double {
        
        return 494
    }
    
    
    func getPosition() -> Double {
        
        return xPosition
    }
    
    
    func getFrontChasis() -> Double {
        
        return Double.nan
    }
    
    
    func getRearChasis() -> Double {
        
        return Double.nan
    }
    
    
    func getFrontSpace() -> Double {
        
        return 28
    }
    
    
    func getRearSpace() -> Double {
        
        return 258
    }
    
    
    func getRect()->CGRect {
        
        return CGRect(x: xPosition, y: CAR_POSY, width: getLength(), height: getHeight())
    }
    
    func getBitmapName()->String {
        
        return "passenger_car_historic_l.png"
    }
    
    func getSolidRect()->CGRect {
        
        return CGRect(x: xPosition + getFrontSpace(), y: CAR_POSY, width: -getFrontSpace() + getRearSpace(), height: getHeight())
    }
    
}
