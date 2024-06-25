//
//  TextureManager.swift
//  ste
//
//  Created by Zdeněk Skulínek on 30.07.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation

class TextureManager
{
    var textureItems: [String:TextureItem] //dict of TextureItem key bitmapName;
    
    static var instance:TextureManager? = nil
    
    init() {
        textureItems = Dictionary<String,TextureItem>()
    }
    
    class func defaultTextureManager()->TextureManager {
        
        if (instance==nil) {
            instance = TextureManager()
        }
        return instance!
    }
    
    static func deleteTextureManager(){
        
        instance = nil
    }
    
    func createTextureItem(imageName imgname:String)->TextureItem? {
    
        var item:TextureItem? = textureItems[imgname]
        if (item == nil ) {
            
            item = TextureItem(imageName: imgname)
            textureItems[imgname] = item
        }
        else {
            
            item?.clients+=1
        }
        return item
    }
    
    func releaseTextureItem(imageName imgname:String) {
        
        let item:TextureItem? = textureItems[imgname]
        assert(item != nil, "remove non inserted image")
        item?.clients-=1
        if ( item?.clients == 0) {
            
            textureItems[imgname] = nil
        }
    }
}
