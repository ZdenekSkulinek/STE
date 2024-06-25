//
//  LintelView.swift
//  ste
//
//  Created by Zdeněk Skulínek on 13.09.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import CoreGraphics

class LintelView: GraphicObjectBase
{
    var textureItem:TextureItem
    var warningItem:TextureItem
    var model:Lintel
    
    init(model mdl:Lintel){
        
        textureItem = TextureManager.defaultTextureManager().createTextureItem(imageName: "lintel.png")!
        warningItem = TextureManager.defaultTextureManager().createTextureItem(imageName: "warning.png")!
        model = mdl
        super.init()
    }
    
    override func draw(){
        
        var rect = model.getRect()
        rect.origin.y = CGFloat( CAR_POSY )
        textureItem.drawAtRect(rect: model.getRect(), innerRect: rect)

        
        if ( model.isWarningShown() ) {
            
            warningItem.drawAtPoint(point: CGPoint(x: 650.0, y: 865.0) )
        }
    }
}
