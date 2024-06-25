//
//  DropableView.swift
//  ste
//
//  Created by Zdeněk Skulínek on 24.03.18.
//  Copyright © 2018 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import UIKit


class DropableView : UIImageView
{
    @IBOutlet var dragItem:DraggableView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setDraggableItem(item:DraggableView?) {
        self.dragItem = item
    }
    
    func getDraggrableItem() ->DraggableView? {
        return self.dragItem
    }
}
