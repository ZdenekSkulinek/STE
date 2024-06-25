//
//  RailView.swift
//  ste
//
//  Created by Zdeněk Skulínek on 16.10.17.
//  Copyright © 2017 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

class RailView: GraphicObjectBase
{
    var textureItem:TextureItem
    var model:Rail
    
    init(model mdl:Rail){
        
        textureItem = TextureManager.defaultTextureManager().createTextureItem(imageName: "rail.png")!
        model = mdl
        super.init()
    }
    
    override func draw(){
        
        let rect = model.getRect()
        var itemRect = CGRect(x: Double(rect.origin.x), y: 0.0,width: RAIL_LENGTH, height: RAIL_HEIGHT)
        while(itemRect.maxX <= rect.maxX) {
            textureItem.drawAtRect(rect: itemRect, innerRect: itemRect)
            itemRect.origin.x += CGFloat(RAIL_LENGTH)
        }
        
    }
}
