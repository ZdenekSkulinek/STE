
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

class CarView: GraphicObjectBase
{
    var textureItem:TextureItem
    var model:ModelObjectBase
    
    init(model mdl:ModelObjectBase){
        
        textureItem = TextureManager.defaultTextureManager().createTextureItem(imageName: mdl.getBitmapName())!
        model = mdl
        super.init()
    }
    
    override func draw(){
        
        textureItem.drawAtPoint(point: model.getRect().origin)
    }
    
    
}
