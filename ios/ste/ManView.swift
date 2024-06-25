//
//  ManView.swift
//  ste
//
//  Created by Zdeněk Skulínek on 27.08.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import CoreGraphics
import OpenGLES

class ManView : GraphicObjectBase
{
    var model: Man
    var pixmaps:[TextureItem]
    var pixmap_laying:TextureItem
    var pixmap_falling:TextureItem
    
    
    init(model mdl:Man) {
        pixmaps = []
        pixmaps.append(TextureManager.defaultTextureManager().createTextureItem(imageName: "man_0.png" )!)
        pixmaps.append(TextureManager.defaultTextureManager().createTextureItem(imageName: "man_1.png" )!)
        pixmaps.append(TextureManager.defaultTextureManager().createTextureItem(imageName: "man_2.png" )!)
        pixmaps.append(TextureManager.defaultTextureManager().createTextureItem(imageName: "man_3.png" )!)
        pixmap_laying = TextureManager.defaultTextureManager().createTextureItem(imageName: "man_l.png" )!
        pixmap_falling = TextureManager.defaultTextureManager().createTextureItem(imageName: "man_f.png" )!
        model = mdl
    }
    
    override func draw() {
    
        switch ( model.getAnimState() ) {
            
        case EAnimationStates.ANIMATION_NONE,
            EAnimationStates.ANIMATION_WIN_WAIT_FOR_TRAIN_MOVE:
    
            var ti:TextureItem
            if( model.isLaying() ) {
                ti = pixmap_laying
            }
            else {
    
                ti = pixmaps[model.getWalkIndex() ];
            }
            var rect = model.getRect()
            if( !model.isGoingToLeft() )
            {
                rect.size.width = -rect.size.width
            }
            ti.drawAtRect(rect: rect, innerRect: rect)
            break;
            
        case EAnimationStates.ANIMATION_WIN_WAIT_FOR_STEP_INSIDE:
            if( model.getJumpIndex() != 0 ) {
                
                let ti:TextureItem  = pixmaps[0]
                let rect = model.getRect()
                ti.drawAtRect(rect: rect, innerRect: rect)
            }
            else {
    
                let ti:TextureItem  = pixmaps[0]
                var rect = model.getRect()
                if ( model.getGoDownOnWin() ) {
                    rect.origin.y = CGFloat( model.getYRoofPosition() )
                }
                else {
                    rect.origin.x = CGFloat( (1920-115)/2 )
                }
                ti.drawAtRect(rect: model.getRect(), innerRect: rect)
            }
            break
        case EAnimationStates.ANIMATION_WIN_OPENING_LOCO_DOORS,
             EAnimationStates.ANIMATION_WIN_OPEN_WAIT:
        
            
                let ti:TextureItem = pixmaps[3]
                var rect = model.getRect()
                let horizontaloffset:CGFloat = rect.size.width - CGFloat( model.getAnimOffset() )
                rect.origin.x += horizontaloffset
                
                
                if ( model.getGoDownOnWin() ) {
                    rect.size.width -= horizontaloffset
                    ti.drawAtRect(rect: model.getRect(), innerRect: rect)
                }
                else {
                   ti.drawAtRect(rect: rect, innerRect: model.getRect())
                }
                break
            
        case EAnimationStates.ANIMATION_LOSE_FALL_DOWN,
             EAnimationStates.ANIMATION_LOSE_WAIT_FOR_TRAIN_MOVE,
             EAnimationStates.ANIMATION_LOSE_ROTATE_DOWN,
             EAnimationStates.ANIMATION_LOSE_WAIT:
            
                glPushMatrix();
                let rect = model.getRect()
                glTranslatef( ( GLfloat( rect.origin.x ) + GLfloat( pixmap_falling.totalSize.width ) / GLfloat(2.0) ) ,
                              ( GLfloat( rect.origin.y ) + GLfloat( pixmap_falling.totalSize.height) / GLfloat(2.0) ) ,
                    GLfloat(0.0))
                glRotatef(GLfloat( model.getAnimAngle() ),0.0,0.0,1.0)
                let newItemRect = CGRect(origin: CGPoint(x: -rect.size.width / 2.0, y: -rect.size.height / 2.0 ), size: rect.size)
                pixmap_falling.drawAtRect(rect: newItemRect, innerRect: newItemRect)
                glPopMatrix();
                break
            
        default: break
        }
    }
    
}
