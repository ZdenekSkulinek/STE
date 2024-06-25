//
//  Loco.swift
//  ste
//
//  Created by Zdeněk Skulínek on 31.07.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import CoreGraphics



protocol Loco :  ModelObjectBase
{
    
    init()
    
    func getLength() -> Double
    func getHeight() -> Double
    func getPosition() -> Double
    func getFrontChasis() -> Double
    func getRearChasis() -> Double
    func getRearSpace() -> Double
    func getEndOfGamePosition() -> Double
    func getSolidRect()->CGRect

    func getDoorRect()->CGRect
    func getAnimState()->EAnimationStates
    func getAnimOffset()->Double
    
    func setAnimState( state:EAnimationStates )
    func setAnimOffset( offset: Double )
    
    func move( offset:Double)
}
