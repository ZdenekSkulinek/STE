//
//  Time.swift
//  ste
//
//  Created by Zdeněk Skulínek on 11.09.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation

//
//  CarPassengerYellow
//  ste
//
//  Created by Zdeněk Skulínek on 31.07.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import CoreGraphics

let TIMEPOSX = 50.0
let TIMEPOSY = 1030.0
let CHARWIDTH = 35.0
let CHARHEIGHT = 48.0

class Time : ModelObjectBase
{
    var time:Double
    
    required init() {
        
        time = 0.0
        
    }
    
    func setTime( time:Double ) {
    
        self.time = time
    }
    
    
    func getTime()->Double {
     
        return time
    }

    
    
    func getRect()->CGRect {
        
        return CGRect(x: TIMEPOSX, y: TIMEPOSY, width: CHARWIDTH * 3.0 , height: CHARHEIGHT )
    }
    
    func getBitmapName()->String {
        
        return ""
    }
    
}

