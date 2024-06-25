
//
//  Man.swift
//  ste
//
//  Created by Zdeněk Skulínek on 27.08.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import CoreGraphics



let MAN_JUMP_TIME = 0.8 //seclet MAN_ROTATION_SPPED = 10*M_PI //rad/sec
let MAN_ROTATE_DECCEL_SPEED = 0.8 //degree/sec
let MAN_ROTATION_SPEED = 50.0  //degree/sec
let MAN_LAST_ROTATION_ANGLE = 270.0
let MAN_JUMP_MAX_HEIGHT = 500.0


let MAN_SHIFT_SPEED = 80.0
let MAN_DOWN_ACCELERATE = 350.0
let MAN_FALL_DECCELERATE = 350.0

let BITMAP_MAN_COUNT = 4
let BITMAP_MAN_HEIGHT = 216.0
let BITMAP_MAN_WIDTH = 115.0
let BITMAP_MAN_FALLING_HEIGHT = 172.0
let BITMAP_MAN_FALLING_WIDTH = 126.0
let BITMAP_MAN_LAYING_HEIGHT = 108.0
let BITMAP_MAN_LAYING_WIDTH = 135.0
let BITMAP_MAN_POSY_DOWN = CAR_POSY


enum EAnimationStates{
    case ANIMATION_NONE
    case ANIMATION_WIN_WAIT_FOR_TRAIN_MOVE
    case ANIMATION_WIN_WAIT_FOR_STEP_INSIDE
    case ANIMATION_WIN_WAIT_LOCO_MOVE
    case ANIMATION_WIN_WAIT_FOR_TRAIN_STALE
    case ANIMATION_WIN_OPENING_LOCO_DOORS
    case ANIMATION_WIN_OPEN_WAIT
    case ANIMATION_LOSE_FALL_DOWN
    case ANIMATION_LOSE_ROTATE_DOWN
    case ANIMATION_LOSE_WAIT_FOR_TRAIN_MOVE
    case ANIMATION_LOSE_WAIT
}

class Man : ModelObjectBase
{
    
    private var yRoofPosition: Double
    private var nextYRoofPosition: Double
    private var yPosition: Double
    private var xPosition: Double
    private var jumpHeight: Double
    private var goingToLeft: Bool
    private var laying: Bool
    private var totalVelocity: Double
    private var animState: EAnimationStates
    private var animOffset: Double
    private var jumpTime: Double
    

    private var jumpIndex: Int
    private var jumpVelocity: Double
    private var jumpMaxHeight: Double
    private var jumpStartHeight: Double
    private var walkIndex: Int
    private var walkIndexIncrease: Bool
    private var walkStepLength: Double
    private var animIndex: Int
    private var animSpeed: Double
    private var animAngle: Double
    private var animRotationDeccelerate: Double
    private var animRotationEndIndex: Int
    private var animRotationSpeed: Double

    private var size:CGSize
    private var goDownOnWin:Bool
    
    
    var MAN_VELOCITY =  575.0
    var MAN_STEP_SIZE = 16.0
    
    func setManVelocity( newVelocity:Double ) { MAN_STEP_SIZE *= newVelocity/MAN_VELOCITY;MAN_VELOCITY = newVelocity }
    func getYRoofPosition() ->Double { return yRoofPosition}
    func setYRoofPosition( newposition:Double) {
        yRoofPosition=newposition
        if ( jumpIndex==0) {
            yPosition = yRoofPosition + CAR_POSY
        }
    }
    func getNextYRoofPosition() ->Double { return nextYRoofPosition}
    func setNextYRoofPosition( newposition:Double) { nextYRoofPosition=newposition;}
    func getYPosition() ->Double { return yPosition}
    func setYPosition( newposition:Double) { yPosition=newposition}
    func getTotalVelocity() ->Double { return totalVelocity}
    func setTotalVelocity( newvelocity:Double) { totalVelocity=newvelocity}
    func getAnimState()->EAnimationStates { return animState}
    func setAnimState( animState: EAnimationStates ) { self.animState = animState}
    func isLaying()->Bool {return laying}
    func isGoingToLeft()->Bool {return goingToLeft}
    func getJumpIndex()->Int {return jumpIndex}
    func getAnimIndex()->Int {return animIndex}
    func getWalkIndex()->Int {return walkIndex}
    func getAnimOffset()->Double {return animOffset}
    func getAnimAngle()->Double {return animAngle}
    func getGoDownOnWin()->Bool { return goDownOnWin}
    func setGoDownOnWin(gow:Bool) { goDownOnWin=gow}
    func setJumpTime(jt:Double) { jumpTime = jt}
    
    init(){
        
        yRoofPosition = 20.0
        yPosition =  0.0
        xPosition =  ( SCREEN_WIDTH - BITMAP_MAN_WIDTH ) / 2.0 
        jumpHeight = 0.0
        goingToLeft = true
        laying = false
        totalVelocity = 0.0
        animState = EAnimationStates.ANIMATION_NONE
        animOffset = 0.0
        jumpIndex = 0
        jumpVelocity = 0.0
        walkIndex = 0
        walkIndexIncrease = true
        walkStepLength = 0.0
        animIndex = 0
        animSpeed = 0.0
        animAngle = 0.0
        animRotationDeccelerate = 0.0
        animRotationEndIndex = 0
        animRotationSpeed = 0.0
        size = CGSize(width: BITMAP_MAN_WIDTH, height: BITMAP_MAN_HEIGHT)
        nextYRoofPosition = yRoofPosition
        jumpMaxHeight = MAN_JUMP_MAX_HEIGHT
        jumpStartHeight = yRoofPosition
        goDownOnWin = true
        jumpTime = MAN_JUMP_TIME
    }
    
    func getRect()->CGRect {
        
        return CGRect(x: CGFloat( xPosition ), y: CGFloat( yPosition ), width: size.width, height: size.height )
    }
    
    func setDoorRect( doorRect:CGRect ) {
        
        let xratio = Double( doorRect.size.width ) / BITMAP_MAN_WIDTH
        let yratio = Double( doorRect.size.height ) / BITMAP_MAN_HEIGHT
        let ratio = xratio < yratio ? xratio : yratio
        size = CGSize(width: Double( size.width ) * ratio , height: Double( size.height ) * ratio)
        xPosition = Double( doorRect.origin.x + (doorRect.size.width - size.width) / CGFloat(2.0) )
        yPosition = Double( doorRect.origin.y )
    }
    
    
    func getBitmapName()->String {
        
        return ""
    }
    
    func fallDown(){
    
        animIndex = 0
        animState = EAnimationStates.ANIMATION_LOSE_FALL_DOWN
        animSpeed = totalVelocity
        //let t:Double = round ( MAN_ROTATION_SPEED / MAN_ROTATE_DECCEL_SPEED )
        let t:Double = round ( totalVelocity / MAN_FALL_DECCELERATE * FRAME_RATE )
        let rots: Double =  round( ( MAN_ROTATION_SPEED * t / 2.0 - MAN_LAST_ROTATION_ANGLE ) / 360.0 )
        animRotationSpeed = ( 360.0 * rots + MAN_LAST_ROTATION_ANGLE ) / t * 2.0
        animRotationDeccelerate = animRotationSpeed / t
        animRotationEndIndex = Int ( t )
        
    }
    
    
    func fallDown_lintel(){

        animIndex = 0
        animState = EAnimationStates.ANIMATION_LOSE_FALL_DOWN
        animSpeed = 0.0
        animRotationEndIndex = 0
    }
    
    
    func finish(){
        animIndex = 0
        animState = EAnimationStates.ANIMATION_WIN_WAIT_FOR_STEP_INSIDE
        animSpeed = totalVelocity;
    }
    
    
    func update(Left left:Bool, Right right:Bool, Down down:Bool, Jump jump:Bool) -> Double {
        
        if( animState != EAnimationStates.ANIMATION_NONE ) {
    
            switch ( animState ) {
                
                case EAnimationStates.ANIMATION_WIN_WAIT_FOR_TRAIN_MOVE:
    
                    if( jumpIndex != 0 ) {
                        
                        jumpIndex += 1
                        jumpHeight = yPosition - MAN_JUMP_MAX_HEIGHT * sin( Double(jumpIndex) / jumpTime * Double.pi / FRAME_RATE )
                        if( jumpHeight <= 0.0 ) {
                            jumpHeight = 0.0
                            jumpIndex = 0
                        }
                        return jumpVelocity / FRAME_RATE
                    }
                    else{
                        walkStepLength += MAN_VELOCITY / FRAME_RATE;
                        if( walkStepLength > MAN_STEP_SIZE ) {
                            walkStepLength -= MAN_STEP_SIZE
                            if( walkIndexIncrease ) {
                                walkIndex += 1
                                if( walkIndex == BITMAP_MAN_COUNT ) {
                                    walkIndex -= 2
                                    walkIndexIncrease = false
                                }
                            }
                            else{
                                walkIndex -= 1
                                if( walkIndex == -1 ) {
                                    walkIndex = 1
                                    walkIndexIncrease = true
                                }
                            }
                        }
                    }
                    goingToLeft = true
                    laying = false
                    return  MAN_VELOCITY / FRAME_RATE
                
                case EAnimationStates.ANIMATION_WIN_WAIT_LOCO_MOVE:
                    return MAN_VELOCITY / FRAME_RATE
                
                case EAnimationStates.ANIMATION_WIN_WAIT_FOR_STEP_INSIDE:
                    if( jumpIndex != 0 ) {
                        jumpIndex += 1
                        jumpHeight = MAN_JUMP_MAX_HEIGHT * sin( Double( jumpIndex ) / jumpTime * Double.pi / FRAME_RATE );
                        if( jumpHeight <= 0.0 ) {
                            jumpHeight = 0.0
                            jumpIndex = 0
                        }
                        return 0.0
                    }
                    if (goDownOnWin) {
                        yPosition -= MAN_SHIFT_SPEED / FRAME_RATE
                        if( yPosition < yRoofPosition - BITMAP_MAN_HEIGHT ) {
                            animState = EAnimationStates.ANIMATION_WIN_WAIT_LOCO_MOVE
                        }
                    }
                    else {
                        xPosition -= MAN_SHIFT_SPEED / FRAME_RATE
                        if( xPosition < (1920-115)/2 - BITMAP_MAN_WIDTH ) {
                            animState = EAnimationStates.ANIMATION_WIN_WAIT_LOCO_MOVE
                        }
                    }
                    return 0.0
                
                case EAnimationStates.ANIMATION_WIN_OPENING_LOCO_DOORS:
                    animOffset += MAN_SHIFT_SPEED / FRAME_RATE
                    if( animOffset > Double(BITMAP_MAN_WIDTH) ) {
                        animOffset = Double(BITMAP_MAN_WIDTH)
                        animState = EAnimationStates.ANIMATION_WIN_OPEN_WAIT
                    }
                    return 0.0
                
                case EAnimationStates.ANIMATION_LOSE_FALL_DOWN:
    
                    yPosition = -Double( animIndex ) * MAN_DOWN_ACCELERATE / FRAME_RATE + Double( yRoofPosition )
                    if( yPosition < BITMAP_MAN_POSY_DOWN ) {
    
                        yPosition = BITMAP_MAN_POSY_DOWN
                        animState = EAnimationStates.ANIMATION_LOSE_ROTATE_DOWN
                    }
                    size = CGSize(width: BITMAP_MAN_FALLING_WIDTH, height: BITMAP_MAN_FALLING_HEIGHT)
                    animSpeed -= MAN_FALL_DECCELERATE / FRAME_RATE
                    if( animSpeed < 0.0 ) {
                        animSpeed = 0.0
                    }
                    else {
                        
                        animAngle = -Double ( animIndex ) * Double ( animIndex ) * animRotationDeccelerate / 2.0 + Double ( animIndex ) * animRotationSpeed
                    }
                    animIndex += 1
                    
                    return ( -totalVelocity + animSpeed) / FRAME_RATE
                
                case EAnimationStates.ANIMATION_LOSE_ROTATE_DOWN:
                    animSpeed -= MAN_FALL_DECCELERATE / FRAME_RATE
                    if( animSpeed < 0.0 ) {
                        
                        animSpeed = 0.0
                        animState = EAnimationStates.ANIMATION_LOSE_WAIT_FOR_TRAIN_MOVE
                    }
                    else {
                        
                        animAngle = -Double ( animIndex ) * Double ( animIndex ) * animRotationDeccelerate / 2.0 + Double ( animIndex ) * animRotationSpeed
                    }
                    animIndex += 1
                    return ( -totalVelocity + animSpeed) / FRAME_RATE

                case EAnimationStates.ANIMATION_LOSE_WAIT_FOR_TRAIN_MOVE:
                    return ( -totalVelocity + animSpeed ) / FRAME_RATE
    
                case EAnimationStates.ANIMATION_LOSE_WAIT:
                    return (-totalVelocity ) / FRAME_RATE

                default: break
            }
            return 0.0
        }//animState != EAnimationStates.ANIMATION_NONE
    
        if( jumpIndex != 0 ) {
    
            jumpIndex += 1
            jumpHeight = jumpStartHeight + jumpMaxHeight * sin( Double( jumpIndex ) / jumpTime * Double.pi / FRAME_RATE )
            yPosition = jumpHeight
            if( yPosition  <= yRoofPosition + CAR_POSY) {
                
                yPosition = yRoofPosition + CAR_POSY
                jumpIndex = 0
            }
            //size = CGSize(width: BITMAP_MAN_WIDTH, height: BITMAP_MAN_HEIGHT)
            return jumpVelocity / FRAME_RATE
        }
        
        if( jump ) {
    
            jumpIndex = 1
            jumpMaxHeight = MAN_JUMP_MAX_HEIGHT
            jumpStartHeight = yRoofPosition + CAR_POSY
            if (nextYRoofPosition>yRoofPosition) {
                jumpMaxHeight += nextYRoofPosition - yRoofPosition
            }
            print("jum max height %d", jumpMaxHeight)
            jumpHeight = jumpStartHeight + jumpMaxHeight * sin( 1.0 / jumpTime * Double.pi / FRAME_RATE )
            yPosition = jumpHeight
            if( left ) {
                
                jumpVelocity = MAN_VELOCITY
            }
            if( right ) {
                
                jumpVelocity -= MAN_VELOCITY
            }
            if( !left && !right ) {

                jumpVelocity = 0.0
            }
            return jumpVelocity / FRAME_RATE
        }
        
        if( down ) {
    
            //NSLog(@" fr =%f-%f  tl=%f",self.Frame.origin.x,self.Frame.size.width,pixmap_laying.totalSize.width);
            if( laying ) {
    
                return 0.0
            }
            laying = true
            size = CGSize(width: BITMAP_MAN_LAYING_WIDTH, height: BITMAP_MAN_LAYING_HEIGHT)
            xPosition =  ( SCREEN_WIDTH - BITMAP_MAN_LAYING_WIDTH ) / 2.0
            if( goingToLeft ) {
    
                //self.Frame = CGRectMake(self.Frame.origin.x, self.Frame.origin.y , pixmap_laying.totalSize.width, pixmap_laying.totalSize.height);
            }
            else {
    
                //self.Frame = CGRectMake(self.Frame.origin.x + self.Frame.size.width - pixmap_laying.totalSize.width, self.Frame.origin.y , pixmap_laying.totalSize.width, pixmap_laying.totalSize.height);
            }
            return 0.0
        }
        else {
            
            //NSLog(@" fr =%f-%f  tl=%f",self.Frame.origin.x,self.Frame.size.width,pixmap_laying.totalSize.width);
            if ( laying ) {
    
                size = CGSize(width: BITMAP_MAN_WIDTH, height: BITMAP_MAN_HEIGHT)
                laying = false
                xPosition =  ( SCREEN_WIDTH - BITMAP_MAN_WIDTH ) / 2.0
                
            }
        
            if( left ) {
                if (!goingToLeft){
                    walkStepLength = 0
                }
                walkStepLength += MAN_VELOCITY / FRAME_RATE
                if( walkStepLength > MAN_STEP_SIZE ) {
                    
                    walkStepLength -= MAN_STEP_SIZE
                    if( walkIndexIncrease ) {
                        
                        walkIndex += 1
                        if( walkIndex == BITMAP_MAN_COUNT ) {
        
                            walkIndex -= 2
                            walkIndexIncrease = false
                        }
                    }
                    else {
        
                        walkIndex -= 1
                        if( walkIndex == -1 ) {
        
                            walkIndex = 1
                            walkIndexIncrease = true
                        }
                    }
                }
                goingToLeft = true
                return MAN_VELOCITY / FRAME_RATE
            }
            
            if( right ) {
                if (goingToLeft){
                    walkStepLength = 0
                }
                
                walkStepLength -= MAN_VELOCITY / FRAME_RATE
                if( walkStepLength < -MAN_STEP_SIZE ) {
            
                    walkStepLength += MAN_STEP_SIZE
                    if( walkIndexIncrease ) {
                        
                        walkIndex += 1
                        if( walkIndex == BITMAP_MAN_COUNT ) {
            
                            walkIndex -= 2
                            walkIndexIncrease = false
                        }
                    }
                    else {
            
                        walkIndex -= 1
                        if( walkIndex == -1 ) {
            
                            walkIndex = 1
                            walkIndexIncrease = true
                        }
                    }
                }
                goingToLeft = false
                return -MAN_VELOCITY / FRAME_RATE
            }
                
            return 0.0;
        }
    }

}




