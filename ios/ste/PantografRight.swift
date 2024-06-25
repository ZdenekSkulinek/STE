//
//  PantografRight
//  ste
//
//  Created by Zdeněk Skulínek on 31.07.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import CoreGraphics

class PantografRight :  ModelObjectBase
{
    var target:Car
    
    required init(target:Car) {
        
        self.target = target
        
    }
    
    
    func getLength() -> Double {
        
        return 243
    }
    
    
    func getHeight() -> Double {
        
        return 186
    }
    
    
    func getPosition() -> Double {
        
        return target.getPosition() + 1770
    }
    
    
    func getFrontSpace() -> Double {
        
        return 115
    }
    
    
    func getRearSpace() -> Double {
        
        return 243
    }
    
    
    func getRect()->CGRect {
        
        return CGRect(x: getPosition(), y: CAR_POSY + 509.0 , width: getLength(), height: getHeight())
    }
    
    func getDangerousRect()->CGRect {
        
        return CGRect(x: getPosition() + getFrontSpace() , y: CAR_POSY + 509.0  , width: getRearSpace(), height: getHeight())
    }
    
    func getBitmapName()->String {
        
        return "pantograf_right.png"
    }
    
}
