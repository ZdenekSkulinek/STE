//
//  Car.swift
//  ste
//
//  Created by Zdeněk Skulínek on 31.07.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import CoreGraphics
import OpenGLES

class LocoView: GraphicObjectBase
{
    var textureItem:TextureItem
    var model:Loco
    var hasDoors: Bool
    
    init(model mdl:Loco){
        
        textureItem = TextureManager.defaultTextureManager().createTextureItem(imageName: mdl.getBitmapName())!
        model = mdl
        hasDoors = true
        super.init()
    }
    
    func setHasDoors( hasDoors:Bool) {
        
        self.hasDoors = hasDoors
    }
    
    override func draw(){
        
        switch ( model.getAnimState()) {
            
            
        case EAnimationStates.ANIMATION_WIN_OPENING_LOCO_DOORS,
             EAnimationStates.ANIMATION_WIN_OPEN_WAIT:
            
            textureItem.drawAtPoint(point: model.getRect().origin)
            
            if ( !hasDoors ) {
                break;
            }
            
            var doorrect = model.getDoorRect()
            
            let vertices2:[GLfloat]=[
                GLfloat( doorrect.origin.x ) , GLfloat( doorrect.origin.y+doorrect.size.height ),                 // position v0
                GLfloat( doorrect.size.width+doorrect.origin.x ), GLfloat( doorrect.origin.y+doorrect.size.height ),  // position v1
                GLfloat( doorrect.origin.x ), GLfloat( doorrect.origin.y ),                                    // position v2
                GLfloat( doorrect.size.width+doorrect.origin.x ), GLfloat( doorrect.origin.y )                     // position v3
            ]
            glDisable(GLenum(GL_TEXTURE_2D));
            // nastaveni mazaci barvy na cernou
            glVertexPointer(2, GLenum(GL_FLOAT), 0, vertices2);
            glEnableClientState(GLenum(GL_VERTEX_ARRAY));
            glColor4f(0.0, 0.0, 0.0, 1);
            glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, 4);
            glColor4f(1.0, 1.0, 1.0, 1.0);
            glDisableClientState(GLenum(GL_VERTEX_ARRAY));
            glEnable(GLenum(GL_TEXTURE_2D));
            
            var locorect = model.getRect()
            locorect.size.height = textureItem.totalSize.height
            let stretchRatio = ( Double ( doorrect.size.width ) - model.getAnimOffset() ) / Double ( doorrect.size.width )
            let locooffset = Double( doorrect.origin.x - locorect.origin.x ) * ( 1.0 - stretchRatio )
            locorect.origin.x += CGFloat( locooffset )
            locorect.size.width *= CGFloat ( stretchRatio )
            doorrect.size.width -= CGFloat( model.getAnimOffset() )       
            
            textureItem.drawAtRect(rect: locorect, innerRect: doorrect )
            break
            
            
        default:
            textureItem.drawAtPoint(point: model.getRect().origin)
            break
        }

        
        
    }
}
