//
//  RopeView.swift
//  ste
//
//  Created by Zdeněk Skulínek on 11.09.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import OpenGLES
import CoreGraphics

class RopeView: GraphicObjectBase
{

    var model:Rope
    var ropeVerices: [GLfloat]
    init(model mdl:Rope){
        
        
        ropeVerices = []
        
        let y1 = CONST_ROPE_A * cosh( 1.0 / CONST_ROPE_A )
        let y2 = CONST_ROPE_A
        let scale = SCREEN_ROPE_HEIGHT / ( y1 - y2 )
        let offset = -y2 * scale
        var j = 0
        let n = ( 2 * Int(SCREEN_ROPE_LENGTH ) / Int( SCREEN_ROPE_STEP ) + 2 )
        var x = -1.0
        while ( j<n ) {
        
            let dx = x * SCREEN_ROPE_LENGTH / 2.0 + SCREEN_ROPE_LENGTH / 2.0
            ropeVerices.append(GLfloat(dx))
            j += 1
            let dy = CONST_ROPE_A * cosh( x / CONST_ROPE_A ) * scale + offset
            ropeVerices.append(GLfloat(dy))
            j += 1
            x += 2.0 / SCREEN_ROPE_LENGTH * SCREEN_ROPE_STEP
        }
        
        model = mdl
        super.init()
    }
    
    override func draw(){
        
        let rect = model.getRect()
        
        if( rect.origin.x + rect.size.width < 0.0 ) {
            
            return
        }
        if( Double( rect.origin.x ) > SCREEN_WIDTH ) {
            
            return
        }
        
        
        glPushMatrix();

        glTranslatef( GLfloat(rect.origin.x), GLfloat(rect.origin.y), 0.0);
        glDisable(GLenum(GL_TEXTURE_2D))
        //glPushMatrix()
        
        //glColor4f(1.0, 0.0, 0.0, 1);           // nastaveni mazaci barvy na cernou
        glVertexPointer(2, GLenum(GL_FLOAT), 0, ropeVerices)
        glEnableClientState(GLenum(GL_VERTEX_ARRAY))
        glColor4f(0x52/255.0, 0x53/255.0, 0x6a/255.0, 1)
        glLineWidth(GLfloat(SCREEN_ROPE_WIDTH))
        glDrawArrays(GLenum(GL_LINE_STRIP), 0, Int32( SCREEN_ROPE_LENGTH ) / Int32( SCREEN_ROPE_STEP ) + Int32(1) )
        glColor4f(1.0, 1.0, 1.0, 1.0)
        glDisableClientState(GLenum(GL_VERTEX_ARRAY))
 
        glEnable(GLenum(GL_TEXTURE_2D))
        glPopMatrix();
 
    }
}
