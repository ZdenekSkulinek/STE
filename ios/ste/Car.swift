//
//  GreenPassengerCar.swift
//  ste
//
//  Created by Zdeněk Skulínek on 31.07.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import CoreGraphics

let CAR_POSY = RAIL_HEIGHT

protocol Car :  ModelObjectBase
{
    
    init(position:Double)
    
    func getLength() -> Double
    func getHeight() -> Double
    func getPosition() -> Double
    func getFrontChasis() -> Double
    func getRearChasis() -> Double
    func getFrontSpace() -> Double
    func getRearSpace() -> Double
    func getSolidRect()->CGRect
    
    func move( offset:Double)
}
