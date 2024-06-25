//
//  Constants.swift
//  ste
//
//  Created by Zdeněk Skulínek on 20.07.16.
//  Copyright © 2016 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import CoreGraphics

let FRAME_RATE = 30.0

let ACM_TOLERANCE_ANGLE  = 20.0*Double.pi/180.0
let ACM_RECOGNIZING_ANGLE = 10.0*Double.pi/180.0
let ACM_JUMP_TRESHOLD = 1.3

let MAX_TEXTURE_SIZE = CGFloat( 1024.0 )
let MAX_TEXTURE_SIZE_INMEMORY = CGFloat( 16.0 )

let SCREEN_HEIGHT = 1080.0
var SCREEN_WIDTH = 1920.0

var STARTING_POS = 100.0 //pixels from end of the train
let TRAIN_WINNING_DECELERATE = 180.0 //pixels/sec/sec

let IMMORTALITY = false
let INITIALLEVEL = 1
