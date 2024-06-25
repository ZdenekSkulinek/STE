//
//  DraggableView.swift
//  ste
//
//  Created by Zdeněk Skulínek on 24.03.18.
//  Copyright © 2018 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import UIKit


class DraggableView : UIView
{
    var value:Int = -1
    @IBOutlet weak var titleLabel: UILabel!
    var delegate: DraggableDelegate? = nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setValue(value:Int, delegate:DraggableDelegate?) {
        self.value = value
        self.titleLabel.text = String(value)
        self.delegate = delegate
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        
        if (touches.first == nil) {
            return
        }
        let touch:UITouch! = touches.first!
        let location = touch.location(in: self.superview)
        let oldLocation = touch.previousLocation(in: self.superview)
        self.frame = self.frame.offsetBy(dx: location.x-oldLocation.x, dy:location.y-oldLocation.y)
        self.delegate?.onTouchMoved(sender: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.onTouchBegin(sender: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.onTouchEnded(sender: self)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.onTouchCancelled(sender: self)
    }
}
