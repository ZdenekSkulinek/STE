//
//  TimeView.swift
//  ste
//
//  Created by Zdeněk Skulínek on 11.09.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation

import CoreGraphics

extension Character {
    var asciiValue: Int {
        get {
            let s = String(self).unicodeScalars
            return Int(s[s.startIndex].value)
        }
    }
}

class TimeView: GraphicObjectBase
{
    var pixmaps:[TextureItem]
    var model:Time
    
    init(model mdl:Time){
        
        pixmaps = []
        for i in 0..<10 {
            
            pixmaps.append(TextureManager.defaultTextureManager().createTextureItem(imageName: "char_"+String(i)+".png" )!)
        }
        
        model = mdl
        super.init()
    }
    
    override func draw(){
        
        let timeString = String( format: "%3.0f" , model.getTime() )
        
        for i in 0..<3 {
        
            let charAtIndex = timeString[timeString.index(timeString.startIndex, offsetBy: i)]
            let index:Int = charAtIndex.asciiValue -  Character("0").asciiValue
            if( index>=0 && index<10 ){
                
                var p = model.getRect().origin
                p.x += CGFloat( Double( i ) * ( CHARWIDTH + 2.0) )
                let ti = pixmaps[index]
                ti.drawAtPoint(point: p )
            }
        }
        
        
    }
}
