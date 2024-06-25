//
//  BulletView.swift
//  ste
//
//  Created by Zdeněk Skulínek on 08.02.17.
//  Copyright © 2017 Zdeněk Skulínek. All rights reserved.
//

import UIKit
import CoreGraphics

class BulletView: GraphicObjectBase
{
    var textureItem:TextureItem
    var model:Bullet
    
    init(model mdl:Bullet){
        
        textureItem = TextureManager.defaultTextureManager().createTextureItem(imageName: "bullet.png")!
        model = mdl
        super.init()
        model.view = self
    }
    
    override func draw(){
        
        var rect = model.getRect()
        if (model.isGoingToLeft()) {
            rect.size.width = -rect.width
        }
        textureItem.drawAtRect(rect: rect, innerRect: rect)
        
    }
}
