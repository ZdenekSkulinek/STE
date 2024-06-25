//
//  Demon.swift
//  ste
//
//  Created by Zdeněk Skulínek on 22.09.17.
//  Copyright © 2017 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import CoreGraphics

let DEMON_FIRST_THROW: Double = 1.0//sec
let DEMON_NEXT_THROW: Double = 5.0//sec
let DEMON_CHARGE_TIME: Double = 0.75//sec
let DEMON_DEATH_TIME: Double = 2.5 //sec
let DEMON_WIDTH: Double = 98.0
let DEMON_HEIGHT: Double = 230.0
let BITMAP_DEMON_COUNT:Int = 4
let DEMON_VELOCITY = 140.0
let DEMON_STEP_SIZE = 8.0
let DEMON_START_POSITION = 1000.0
let BULLET_Y_POSITION = 140.0
let DEMON_DEATH_WIDTH = 222.0
let DEMON_DEATH_HEIGHT = 115.0

enum EDemonStates
{
    case DEMON_STATE_WAIT
    case DEMON_STATE_GO
    case DEMON_STATE_CHARGE
    case DEMON_STATE_DEATH
    case DEMON_STATE_POSTMORTAL
}

class Demon : ModelObjectBase
{
    var walkIndex: Int
    var walkIndexIncrease: Bool
    var walkStepLength: Double
    var xPosition: Double
    var xManPosition: Double
    var yPosition: Double
    var goingToLeft: Bool
    var state: EDemonStates
    var timer:Double
    var bullet: Bullet?
    var car: Car?
    public
    weak var view : GraphicObjectBase?
    
    init(car:Car ,xposition:Double = 0.0){
        
        walkIndex = 0
        walkStepLength = 0.0
        walkIndexIncrease = true
        state = EDemonStates.DEMON_STATE_WAIT
        goingToLeft = true
        xPosition =  xposition
        xManPosition = 0.0
        yPosition = car.getHeight() + CAR_POSY
        timer = 0.0
        bullet = nil
        self.car = car
    }
    
    func setYPosition(yposition:Double) {
        
        yPosition = yposition
    }
    
    func getBitmapName()->String {
        
        return ""
    }
    
    func getRect()->CGRect {
        
        if (state == EDemonStates.DEMON_STATE_DEATH)
        {
            return CGRect(x: CGFloat( Double(car!.getSolidRect().minX) + xPosition - (DEMON_DEATH_WIDTH-DEMON_WIDTH)/2.0), y: CGFloat( yPosition ), width: CGFloat( DEMON_DEATH_WIDTH ), height: CGFloat(DEMON_DEATH_HEIGHT) )
        }
        else
        {
            return CGRect(x: CGFloat( Double(car!.getSolidRect().minX) + xPosition ), y: CGFloat( yPosition ), width: CGFloat( DEMON_WIDTH ), height: CGFloat(DEMON_HEIGHT) )
        }
    }
    
    func getAnimState()->EDemonStates {
        
        return state
    }
    
    func getBullet()->Bullet? {
        
        return bullet
    }
    
    func updateWithPosition(position:Double, step: Double)->Bullet? {
        
        
        switch (state)
        {
        case EDemonStates.DEMON_STATE_WAIT:
            if((xPosition+Double(car!.getSolidRect().minX)-position) < DEMON_START_POSITION && (position-Double(car!.getSolidRect().minX)-xPosition)<DEMON_START_POSITION)
            {
                state=EDemonStates.DEMON_STATE_GO
                timer=DEMON_FIRST_THROW
                
            }
            break
        case EDemonStates.DEMON_STATE_GO:
            timer -= 1.0 / FRAME_RATE
            if(timer < 0.0)
            {
                state = EDemonStates.DEMON_STATE_CHARGE
                timer = DEMON_CHARGE_TIME
                if (bullet==nil) {
                    bullet = Bullet()
                    if(goingToLeft)
                    {
                        bullet?.setGoingToLeft(gleft: true)
                        bullet?.setX(x: xPosition+Double(car!.getSolidRect().minX) + DEMON_WIDTH / 2.0)
                    }
                    else
                    {
                        bullet?.setGoingToLeft(gleft: false)
                        bullet?.setX(x: xPosition + Double(car!.getSolidRect().minX) + DEMON_WIDTH / 2.0 - BULLET_LENGTH )
                    }
                    bullet?.setY(y: yPosition + BULLET_Y_POSITION)
                }
                break;
            }
            if(xPosition + Double(car!.getSolidRect().minX) < position)
            {

                xPosition += DEMON_VELOCITY / FRAME_RATE
                if (xPosition > Double ( (car?.getSolidRect().width)!) - DEMON_WIDTH / 2.0 ) {
                    xPosition = Double( (car?.getSolidRect().width)! ) - DEMON_WIDTH / 2.0
                }
                walkStepLength += DEMON_VELOCITY / FRAME_RATE
                if(walkStepLength > DEMON_STEP_SIZE) {
                    walkStepLength -= DEMON_STEP_SIZE
                    if(walkIndexIncrease) {
                        walkIndex += 1
                        if(walkIndex == BITMAP_DEMON_COUNT) {
                            walkIndex -= 2
                            walkIndexIncrease = false
                        }
                    }
                    else{
                        walkIndex -= 1
                        if(walkIndex == -1) {
                            walkIndex = 1
                            walkIndexIncrease = true
                        }
                    }
                }
                goingToLeft = false
            }
            else {
                xPosition -= DEMON_VELOCITY / FRAME_RATE
                if ( xPosition < 0.0 ) {
                    
                    xPosition = 0.0
                }
                walkStepLength -= DEMON_VELOCITY / FRAME_RATE
                if(walkStepLength < -DEMON_STEP_SIZE) {
                    walkStepLength += DEMON_STEP_SIZE
                    if(walkIndexIncrease) {
                        walkIndex += 1
                        if(walkIndex == BITMAP_DEMON_COUNT) {
                            walkIndex -= 2
                            walkIndexIncrease = false
                        }
                    }
                    else {
                        walkIndex -= 1
                        if(walkIndex == -1) {
                            walkIndex = 1
                            walkIndexIncrease = true
                        }
                    }
                }
                goingToLeft = true
            }
            break
        case EDemonStates.DEMON_STATE_CHARGE:
            
            timer -= 1.0 / FRAME_RATE
            
            bullet?.setX(x: (bullet?.getX())!+step)
            if(timer < 0.0) {
                state = EDemonStates.DEMON_STATE_GO
                timer = DEMON_NEXT_THROW
                let bb:Bullet? = bullet
                bullet = nil
                xManPosition = position
                return bb
            }
            break
        case EDemonStates.DEMON_STATE_DEATH:
            timer -= 1.0 / FRAME_RATE
            if(timer < 0.0) {
                state = EDemonStates.DEMON_STATE_POSTMORTAL
            }
            let bb:Bullet? = bullet
            bullet = nil
            return bb
        case EDemonStates.DEMON_STATE_POSTMORTAL:
            break
        }
        xManPosition = position
        return nil
    }
    
    func kill() {
        timer = DEMON_DEATH_TIME
        state = EDemonStates.DEMON_STATE_DEATH
        bullet = nil
    }
    
    func getWalkIndex()->Int {
        return walkIndex
    }
    
    func isGoingToLeft()->Bool {
        return goingToLeft
    }
    
}
