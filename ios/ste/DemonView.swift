//
//  DemonView.swift
//  ste
//
//  Created by Zdeněk Skulínek on 24.09.17.
//  Copyright © 2017 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import CoreGraphics
import OpenGLES

class DemonView : GraphicObjectBase
{
    var model: Demon
    var pixmaps:[TextureItem]
    var pixmap_dead:TextureItem
    var bulletItem : TextureItem
    
   
    init(model mdl:Demon) {        
        pixmaps = []
        pixmaps.append(TextureManager.defaultTextureManager().createTextureItem(imageName: "demon_0.png" )!)
        pixmaps.append(TextureManager.defaultTextureManager().createTextureItem(imageName: "demon_1.png" )!)
        pixmaps.append(TextureManager.defaultTextureManager().createTextureItem(imageName: "demon_2.png" )!)
        pixmaps.append(TextureManager.defaultTextureManager().createTextureItem(imageName: "demon_3.png" )!)
        pixmap_dead = TextureManager.defaultTextureManager().createTextureItem(imageName: "demon_d.png" )!
        bulletItem = TextureManager.defaultTextureManager().createTextureItem(imageName: "bullet.png")!
        model = mdl
        super.init()
        model.view = self
    }
    
    override func draw() {
        
        
        switch (model.getAnimState()) {
            case EDemonStates.DEMON_STATE_WAIT,
                 EDemonStates.DEMON_STATE_GO,
                 EDemonStates.DEMON_STATE_CHARGE:
            
                    let ti:TextureItem = pixmaps[ model.getWalkIndex() ];
                    var rect = model.getRect()
                    if( !model.isGoingToLeft() )
                    {
                        rect.size.width = -rect.size.width
                    }
                    ti.drawAtRect(rect: rect, innerRect: rect)
                    break
            
            case EDemonStates.DEMON_STATE_DEATH:

                    let ti:TextureItem = pixmap_dead;
                    let rect = model.getRect()
                    ti.drawAtRect(rect: rect, innerRect: rect)
                    break
            default :
                break
            
        }
        
        if (model.getBullet()==nil){
            return
        }
        var rect:CGRect! = model.getBullet()?.getRect()
        if (model.getBullet()?.isGoingToLeft())! {
            rect = CGRect(x: rect.origin.x, y: rect.origin.y, width: -rect.size.width, height: rect.size.height)
        }
        bulletItem.drawAtRect(rect: rect!, innerRect: rect!)

    }
    
}
