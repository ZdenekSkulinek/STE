//
//  LivesView.swift
//  ste
//
//  Created by Zdeněk Skulínek on 08.02.17.
//  Copyright © 2017 Zdeněk Skulínek. All rights reserved.
//

let SCREEN_LIVES_POSX  = SCREEN_WIDTH - SCREEN_LIVES_WIDTH
let SCREEN_LIVES_POSY =  SCREEN_HEIGHT - SCREEN_LIVES_HEIGHT
let SCREEN_LIVES_HEIGHT = 108.0
let SCREEN_LIVES_WIDTH = 58.0

import Foundation
import CoreGraphics
import OpenGLES

class LivesView: GraphicObjectBase {

    var lives:Int
    var texture:TextureItem
    var numPixmaps:[TextureItem]
    
    init(lives:Int) {
        
        self.lives = lives
        if (lives == INT_MAX) {
            texture = TextureManager.defaultTextureManager().createTextureItem(imageName: "man_v.png" )!
        }
        else {
            texture = TextureManager.defaultTextureManager().createTextureItem(imageName: "man_0.png" )!
        }
        
        numPixmaps = []
        for i in 0..<10 {
            
            numPixmaps.append(TextureManager.defaultTextureManager().createTextureItem(imageName: "char_"+String(i)+".png" )!)
        }
    }
    
    override func draw() {
        
        var drawedLives = lives
        if (lives == Int(INT_MAX)) {
            drawedLives = 1
        }
        else if(lives <= 5){
            drawedLives -= 1
        }
        else {
            drawedLives = 1
            let livesString = String( format: "%3i", lives - 1)
            for i in 0..<3 {
                
                let charAtIndex = livesString[livesString.index(livesString.startIndex, offsetBy: i)]
                let index:Int = charAtIndex.asciiValue -  Character("0").asciiValue
                if( index>=0 && index<10 ){
                    
                    var p = CGPoint(x: SCREEN_LIVES_POSX - 3 * CHARWIDTH, y: SCREEN_HEIGHT - CHARHEIGHT)
                    p.x += CGFloat( Double( i ) * ( CHARWIDTH + 2.0) )
                    let ti = numPixmaps[index]
                    ti.drawAtPoint(point: p )
                }
            }
            
        }
        for i in 0..<drawedLives {
            
            let rect = CGRect(x: SCREEN_LIVES_POSX - Double(i) * SCREEN_LIVES_WIDTH, y: SCREEN_LIVES_POSY, width: SCREEN_LIVES_WIDTH, height: SCREEN_LIVES_HEIGHT)
            texture.drawAtRect(rect: rect, innerRect: rect)
        }
    }
}

