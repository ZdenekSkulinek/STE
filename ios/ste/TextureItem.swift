//
//  TextureItem.swift
//  ste
//
//  Created by Zdeněk Skulínek on 27.07.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import CoreGraphics
import OpenGLES
import UIKit

class TextureItem
{
    var clients:Int
    var textureDatas: [NSData]
    var textureNames: [GLuint]
    var textureSize:CGSize
    var totalSize:CGSize
    var textureCoords: [GLfloat]
    var vertices: [GLfloat]
    init (imageName: String) {
        
        textureDatas = []
        clients = 0
        textureCoords = []
        vertices = []
        textureNames = []
        textureCoords = [GLfloat](repeating: GLfloat( 0.0),count: 8  )
        vertices = [GLfloat](repeating: GLfloat( 0.0),count: 8  )
        textureSize = CGSize(width: 0, height: 0)
        totalSize = CGSize(width: 0, height: 0)
        
        clients = 1;
        let img2: UIImage? = UIImage(named: imageName)
        if (img2 == nil) {
            
            return
        }
        let img: UIImage! = img2
        
        assert( !(img.size.height > MAX_TEXTURE_SIZE && img.size.width > MAX_TEXTURE_SIZE ), "bitmap is too large")
        
        let colorSpacerf:CGColorSpace  = CGColorSpaceCreateDeviceRGB()
            
        totalSize = CGSize( width: img.size.width , height: img.size.height )
        textureSize = CGSize( width: alignToPowerTwo(x: img!.size.width) , height: alignToPowerTwo( x: img!.size.height ) )
            
        if( img.size.width > img.size.height) {
                
            textureSize.width =  textureSize.width > MAX_TEXTURE_SIZE ? MAX_TEXTURE_SIZE : textureSize.width;
                
            var offset : CGFloat = CGFloat( 0.0 )
            
            while(offset<=img.size.width) {
                    
                var restOfWidth:CGFloat = img.size.width-offset
                if(restOfWidth > textureSize.width) {
                        
                    restOfWidth=textureSize.width;
                }
                let arrayLength:Int = Int( textureSize.width * textureSize.height * CGFloat( 4 ) )
                let bytes = [UInt8](repeating: UInt8(0),count: arrayLength)
                let imageBitmapData:NSMutableData = NSMutableData(bytes: bytes, length: arrayLength)

                let contextRef:CGContext?  = CGContext(data: imageBitmapData.mutableBytes, width: Int(textureSize.width), height: Int(textureSize.height), bitsPerComponent: 8 , bytesPerRow: Int ( textureSize.width*CGFloat( 4 ) ), space: colorSpacerf,  bitmapInfo: CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue )
                    
                let cgImage:CGImage?  = img.cgImage!.cropping(to: CGRect(x: offset, y: 0, width:  restOfWidth,height:  img.size.height))

                
                contextRef!.draw(cgImage!, in: CGRect( x: 0 ,y: 0,width: restOfWidth ,height: img.size.height) )
                offset += textureSize.width;
                textureDatas.append(imageBitmapData)
                
                if ( textureSize.width > MAX_TEXTURE_SIZE_INMEMORY || textureSize.height > MAX_TEXTURE_SIZE_INMEMORY) {
                
                    textureNames.append(GLuint(UINT32_MAX))
                }
                else {
                 
                    var texname:GLuint = GLuint(0)
                    
                    glGenTextures(1, &texname)
                    checkGL(text: "gentexture 1" , item: texname, imageName: imageName )
                    glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_NEAREST);
                    checkGL(text: "texparametri 1" , item: texname, imageName: imageName )
                    textureNames.append(texname)
                    glBindTexture(GLenum(GL_TEXTURE_2D), texname);
                    checkGL(text: "bindtexture 1" , item: texname, imageName: imageName )
                    glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA,     // nahrani rastrovych dat do textury
                        GLsizei(textureSize.width), GLsizei(textureSize.height),
                        0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), imageBitmapData.mutableBytes)
                    checkGL(text: "teximage 1" , item: texname, imageName: imageName )
                }

                
            }
        }
        else {
            textureSize.height =  textureSize.height > MAX_TEXTURE_SIZE ? MAX_TEXTURE_SIZE : textureSize.height
            var offset : CGFloat = img.size.height
            
            while( offset > 0 ) {
                
                var restOfHeight:CGFloat = textureSize.height
                if( offset < textureSize.height) {
                    
                    restOfHeight=offset
                }
                let arrayLength:Int = Int( textureSize.width * textureSize.height * CGFloat( 4 ) )
                let bytes = [UInt8](repeating: UInt8(0),count: arrayLength)
                let imageBitmapData:NSMutableData = NSMutableData(bytes: bytes, length: arrayLength)
                
                let contextRef:CGContext?  = CGContext(data: imageBitmapData.mutableBytes, width: Int(textureSize.width), height: Int(textureSize.height), bitsPerComponent: 8 , bytesPerRow: Int ( textureSize.width*CGFloat( 4 ) ), space: colorSpacerf,  bitmapInfo: CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue )
                let soffset:CGFloat = (offset-textureSize.height) >= CGFloat(0) ? (offset-textureSize.height) : CGFloat(0)
                let cgImage:CGImage?  = img.cgImage!.cropping(to: CGRect(x: 0, y: soffset , width:  img.size.width,height:  restOfHeight))
                
                contextRef!.draw(cgImage!,in: CGRect( x: 0 ,y: 0,width: img.size.width ,height: restOfHeight) )
                offset -= textureSize.height;
                textureDatas.append(imageBitmapData)
                
                if ( textureSize.width > MAX_TEXTURE_SIZE_INMEMORY || textureSize.height > MAX_TEXTURE_SIZE_INMEMORY) {
                    
                    textureNames.append(GLuint(UINT32_MAX))
                }
                else {
                    var texname:GLuint = GLuint(0)
                    
                    glGenTextures(1, &texname)
                    checkGL(text: "gentexture 2" , item: texname, imageName: imageName )
                    glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_NEAREST)
                    checkGL(text: "texparametri 2" , item: texname, imageName: imageName )
                    textureNames.append(texname)
                    glBindTexture(GLenum(GL_TEXTURE_2D), texname);
                    checkGL(text: "bindtexture 2" , item: texname, imageName: imageName )
                    glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA,     // nahrani rastrovych dat do textury
                        GLsizei(textureSize.width), GLsizei(textureSize.height),
                        0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), imageBitmapData.mutableBytes)
                    checkGL(text: "teximage 2" , item: texname, imageName: imageName )
                }
                
                
            }
            
        }
    }
    
    
    func checkGL(text:String, item:GLuint , imageName:String) {
        
        let err:GLenum = glGetError()
        if ( err != 0 ) {
            
            print("OpenGL error : ", err, " - ",text," (",self,"):(", item, "):(",imageName ,")")
        }
    }
    
    func alignToPowerTwo( x:CGFloat )-> CGFloat 	{
    
        if( x == 0.0 ) {
            return 0.0
        }
    
        var d:Int = Int(abs(x))
        var n:Int = 1
    
        while( d != 0 ) {
            
            d>>=1
            n<<=1
        }
        
        return CGFloat(n)
    }
    
    func draw( textureName:GLuint ){
    
        glVertexPointer(2, GLenum(GL_FLOAT), 0, &vertices)
        glEnableClientState(GLenum(GL_VERTEX_ARRAY))
        glTexCoordPointer(2, GLenum(GL_FLOAT),0, &textureCoords)
        glEnableClientState(GLenum(GL_TEXTURE_COORD_ARRAY))
        glBindTexture(GLenum(GL_TEXTURE_2D), textureName)
        checkGL(text: "bindtexture 3" , item: textureName, imageName: "" )
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, 4);
        checkGL(text: "drawarrays 3" , item: textureName, imageName: "" )
        glDisableClientState(GLenum(GL_VERTEX_ARRAY));
        glDisableClientState(GLenum(GL_TEXTURE_COORD_ARRAY));
    }
    
    func draw( texturedata:NSData){
        
        glVertexPointer(2, GLenum(GL_FLOAT), 0, &vertices)
        glEnableClientState(GLenum(GL_VERTEX_ARRAY));
        glTexCoordPointer(2, GLenum(GL_FLOAT),0, &textureCoords);
        glEnableClientState(GLenum(GL_TEXTURE_COORD_ARRAY));
        glBindTexture( GLenum(GL_TEXTURE_2D), GLuint( 0 ) );
        checkGL(text: "bindtexture 4" , item: 0xFFFFFFFF, imageName: "" )
        glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA,     // nahrani rastrovych dat do textury
            GLsizei(textureSize.width), GLsizei(textureSize.height),
            0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), texturedata.bytes)
        checkGL(text: "teximage 4" , item: 0xFFFFFFFF, imageName: "" )
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, 4);
        checkGL(text: "drawarrays 4" , item: 0xFFFFFFFF, imageName: "" )
        glDisableClientState(GLenum(GL_VERTEX_ARRAY));
        glDisableClientState(GLenum(GL_TEXTURE_COORD_ARRAY));
    
    }
    
    func drawAtPoint(point:CGPoint) {
        
        var newPoint:CGPoint = point
        var newCoords:CGPoint = CGPoint(x: 0.0 , y: 0.0 )
        
        for i in 0..<textureDatas.count
        {
            if (!(( Double( newPoint.x ) > SCREEN_WIDTH || (newPoint.x + self.textureSize.width)<0.0) ||
                ( Double( newPoint.y ) > SCREEN_HEIGHT || (newPoint.y + self.textureSize.height)<0.0)))
            {
                setTextureCoords(coords: newCoords, point: newPoint)
                if ( textureNames[i] == GLuint(UINT32_MAX)) {
                    draw( texturedata: textureDatas[i] )
                }
                else {
                    draw( textureName: textureNames[i] )
                }
            }
            
            if ( totalSize.width > totalSize.height) {
                
                newPoint = CGPoint(x: newPoint.x + textureSize.width , y: newPoint.y );
                newCoords = CGPoint(x: newCoords.x + textureSize.width , y: newCoords.y );
            }
            else {
                
                newPoint = CGPoint(x: newPoint.x , y: newPoint.y + textureSize.height );
                newCoords = CGPoint(x: newCoords.x, y: newCoords.y + textureSize.height );
            }
            
            
        }
    }
    
    func setTextureCoords(coords:CGPoint, point:CGPoint){
        
        let textureSize_h:CGFloat = CGFloat( textureSize.height )
        let textureSize_w:CGFloat = CGFloat( textureSize.width )
        
        vertices[0] = GLfloat( point.x )
        vertices[1] = GLfloat( point.y + (((-coords.y + totalSize.height) > textureSize_h) ? textureSize_h : totalSize.height - coords.y) )
        //pravy horni
        vertices[2] = GLfloat( point.x + (((-coords.x + totalSize.width) > textureSize_w) ? textureSize_w : totalSize.width - coords.x) )
        vertices[3] = vertices[1]
        //levy dolni
        vertices[4] = GLfloat( point.x )
        vertices[5] = GLfloat( point.y )
        //prevy dolni
        vertices[6] = vertices[2];
        vertices[7] = GLfloat( point.y )
        
        textureCoords[0] = GLfloat( 0.0 )//levy horni
        textureCoords[1] = GLfloat( CGFloat( 1.0 ) - ( (totalSize.height-coords.y)>textureSize_h ? textureSize_h : totalSize.height - coords.y) / textureSize_h )
        //pravy horni
        textureCoords[2] = GLfloat( ( (totalSize.width-coords.x)>textureSize_w ? textureSize_w : totalSize.width - coords.x) / textureSize_w )
        textureCoords[3] = textureCoords[1]
        //levy dolni
        textureCoords[4] = GLfloat( 0.0 )
        textureCoords[5] = GLfloat( 1.0 )
        //prvy dolni
        textureCoords[6] = textureCoords[2]
        textureCoords[7] = GLfloat( 1.0 )

    }
    
    func drawAtRect( rect:CGRect, innerRect:CGRect ) {
        
        var rectN = rect
        if ( rectN.size.width < CGFloat( 0.0 ) ) {
            
            rectN.size.width = -rectN.size.width
        }
        var innerRectN = innerRect
        if ( innerRectN.size.width < CGFloat( 0.0 ) ) {
            
            innerRectN.size.width = -innerRectN.size.width
        }
        
        let effectiveTextureSize:CGSize = CGSize(width: textureSize.width * rectN.size.width / totalSize.width, height: textureSize.height * rectN.size.height / totalSize.height)
        var newPoint:CGPoint = rect.origin
        var newCoords:CGPoint = CGPoint(x: 0.0 , y: 0.0 )
        
        for i in 0..<textureDatas.count
        {
            let drawedRect:CGRect = CGRect(origin: newPoint, size:
                CGSize(width: effectiveTextureSize.width ,
                       height: effectiveTextureSize.height  ) )
            .intersection(CGRect(origin: newPoint, size:totalSize))
            let intersectRect = drawedRect.intersection(innerRectN)
            if (!( ( Double( newPoint.x ) > SCREEN_WIDTH || (newPoint.x + effectiveTextureSize.width)<0.0) ||
                ( Double( newPoint.y ) > SCREEN_HEIGHT || (newPoint.y + effectiveTextureSize.height)<0.0) ||
                intersectRect.isNull))
            {
                
                setTextureCoordsRect(coords: newCoords, rect: drawedRect, visibleRect: intersectRect, totalCustomSize: rectN.size )
                if( rect.size.width < 0.0 )
                {
                    let tmp = textureCoords[0]
                    textureCoords[0] = textureCoords[2]
                    textureCoords[4] = textureCoords[6]
                    textureCoords[2] = tmp
                    textureCoords[6] = tmp
                }
                if ( textureNames[i] == GLuint(UINT32_MAX)) {
                    draw( texturedata: textureDatas[i] )
                }
                else {
                    draw( textureName: textureNames[i] )
                }
            }
            
            if ( totalSize.width > totalSize.height) {
                
                newPoint = CGPoint(x: newPoint.x + effectiveTextureSize.width , y: newPoint.y );
                newCoords = CGPoint(x: newCoords.x + effectiveTextureSize.width  , y: newCoords.y );
            }
            else {
                
                newPoint = CGPoint(x: newPoint.x , y: newPoint.y + effectiveTextureSize.height  );
                newCoords = CGPoint(x: newCoords.x, y: newCoords.y + effectiveTextureSize.height );
            }
            
            
        }
    }
    
    func setTextureCoordsRect(coords:CGPoint, rect:CGRect, visibleRect:CGRect, totalCustomSize:CGSize){
        
        let point = rect.origin
        let visiblePoint = visibleRect.origin
        let rightDownSize:CGSize = CGSize(width: visibleRect.size.width + visiblePoint.x - point.x, height: visibleRect.size.height + visiblePoint.y - point.y)
        let textureSize_w:CGFloat = CGFloat( textureSize.width * totalCustomSize.width / totalSize.width )
        let textureSize_h:CGFloat = CGFloat( textureSize.height * totalCustomSize.height / totalSize.height )
        
        vertices[0] = GLfloat( visiblePoint.x )//levy horni
        vertices[1] = GLfloat( point.y + ((( rightDownSize.height ) > textureSize_h) ? textureSize_h : rightDownSize.height) )
        //pravy horni
        vertices[2] = GLfloat( point.x + ((( rightDownSize.width ) > textureSize_w) ? textureSize_w : rightDownSize.width) )
        vertices[3] = vertices[1] //point.y + _totalSize.height>_textureSize ? _textureSize : _totalSize.height;
        //levy dolni
        vertices[4] = GLfloat( visiblePoint.x )
        vertices[5] = GLfloat( visiblePoint.y )
        //prevy dolni
        vertices[6] = vertices[2];//point.x + _totalSize.width>_textureSize ? _textureSize : _totalSize.width;
        vertices[7] = GLfloat( visiblePoint.y )
        
        textureCoords[0] = GLfloat( ( visiblePoint.x - point.x ) / textureSize_w )//levy horni
        textureCoords[1] = GLfloat( CGFloat( 1.0 ) - ( ( rightDownSize.height - coords.y)>textureSize_h ? textureSize_h : rightDownSize.height  - coords.y) / textureSize_h )
        
        //textureCoords[1] = GLfloat(0.0)
        //pravy horni
        textureCoords[2] = GLfloat( ( (rightDownSize.width )>textureSize_w ? textureSize_w : rightDownSize.width ) / textureSize_w )
        textureCoords[3] = textureCoords[1]
        //levy dolni
        textureCoords[4] = textureCoords[0]
        textureCoords[5] = GLfloat( 1.0 - (visiblePoint.y - point.y/*rect.size.height - rightDownSize.height*/ ) / textureSize_h )
        //prvy dolni
        textureCoords[6] = textureCoords[2]
        textureCoords[7] = textureCoords[5]
        
        
    }
    
    
    
    
}
