//
//  GraphicObjectBase.swift
//  ste
//
//  Created by Zdeněk Skulínek on 31.07.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import UIKit

class GraphicObjectBase : Equatable
{
    
    func draw(){
    }
    
    
    
}

func == (left: GraphicObjectBase, right:GraphicObjectBase)->Bool
{
    return left === right
}

