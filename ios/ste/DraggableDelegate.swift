//
//  DraggableDelegate.swift
//  ste
//
//  Created by Zdeněk Skulínek on 24.03.18.
//  Copyright © 2018 Zdeněk Skulínek. All rights reserved.
//

import Foundation

protocol DraggableDelegate
{
    func onTouchBegin(sender:DraggableView)
    func onTouchMoved(sender:DraggableView)
    func onTouchEnded(sender:DraggableView)
    func onTouchCancelled(sender:DraggableView)
}
