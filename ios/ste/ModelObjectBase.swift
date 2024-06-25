//
//  ModelObjectBase.swift
//  ste
//
//  Created by Zdeněk Skulínek on 31.07.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import CoreGraphics

protocol  ModelObjectBase {
    
    func getRect()->CGRect
    func getBitmapName()->String
    
}
