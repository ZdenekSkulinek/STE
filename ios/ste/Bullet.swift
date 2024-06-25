//
//  Bullet.swift
//  ste
//
//  Created by Zdeněk Skulínek on 08.02.17.
//  Copyright © 2017 Zdeněk Skulínek. All rights reserved.
//

import UIKit
import CoreGraphics

let BULLET_HEIGHT:Double = 15.0
let BULLET_LENGTH:Double = 45.0
var BULLET_VELOCITY:Double = 1700.0 //pixels/sec

class Bullet: NSObject {
    
    var goingToLeft:Bool
    var xPosition:Double
    var yPosition:Double
    public
    weak var view: GraphicObjectBase?

    override init()
    {
        goingToLeft = false
        xPosition = 0.0
        yPosition = 500.0
    }
    
    
    func updateWithManspeed( manspeed:Double )->Bool
    {
        if( goingToLeft ) {
            xPosition -= BULLET_VELOCITY / FRAME_RATE - manspeed
        }
        else {
            
            xPosition += BULLET_VELOCITY / FRAME_RATE + manspeed
        }
        
        
        if( xPosition + BULLET_LENGTH < 0.0 && goingToLeft )
        {
            return true
        }
        if( xPosition > SCREEN_WIDTH && !goingToLeft )
        {
            return true
        }
        return false
    }
    
    
    func setGoingToLeft( gleft:Bool )
    {
        goingToLeft = gleft
    }
    
    func isGoingToLeft()->Bool
    {
        return goingToLeft
    }
    
    func setX( x:Double )
    {
        xPosition = x
    }
    
    func getX() ->Double
    {
        return xPosition
    }
    
    func setY( y:Double )
    {
        yPosition = y
    }
    
    func setVelocity( vel:Double )
    {
        BULLET_VELOCITY = vel
    }
    
    func getRect()->CGRect {
        
        return CGRect(x: xPosition , y: yPosition , width: BULLET_LENGTH, height: BULLET_HEIGHT )
    }
    
    func getBitmapName()->String {
        
        return "bullet.png"
    }
}
