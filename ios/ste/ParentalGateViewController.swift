//
//  ParentalGateViewController.swift
//  ste
//
//  Created by Zdeněk Skulínek on 24.03.18.
//  Copyright © 2018 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import UIKit


struct ExampleItem {
    let Equation1:String
    let Equation2:String
    let Result1:Int
    let Result2:Int
    let Options:[Int]
}

class ParentalGateViewController: UIViewController, DraggableDelegate {
    
    @IBOutlet var drop1:DropableView?
    @IBOutlet var drop2:DropableView?
    @IBOutlet var drop3:DropableView?
    @IBOutlet var drop4:DropableView?
    @IBOutlet var drop5:DropableView?
    @IBOutlet var drop6:DropableView?
    @IBOutlet var drop7:DropableView?
    @IBOutlet var drop8:DropableView?
    @IBOutlet var dropE1:DropableView?
    @IBOutlet var dropE2:DropableView?
    @IBOutlet var drag1:DraggableView?
    @IBOutlet var drag2:DraggableView?
    @IBOutlet var drag3:DraggableView?
    @IBOutlet var drag4:DraggableView?
    @IBOutlet var drag5:DraggableView?
    @IBOutlet var drag6:DraggableView?
    @IBOutlet var drag7:DraggableView?
    @IBOutlet var drag8:DraggableView?
    @IBOutlet var equation1:UILabel?
    @IBOutlet var equation2:UILabel?
    @IBOutlet var wholeView:UIView?

    var drops:[DropableView] = []
    var activeDraggers:[DraggableView] = []
    var dragNib:UINib
    var exampleIndex:Int = 0
    
    fileprivate static let exampleTable : [ExampleItem] = [
        ExampleItem(Equation1: "5 \u{00d7} 8 =", Equation2: "3 \u{00d7} 11 =", Result1: 40, Result2: 33, Options: [13,31,33,40,50,58,80,311]),
        ExampleItem(Equation1: "9 \u{00d7} 9 =", Equation2: "2 \u{00d7} 4 =",  Result1: 81, Result2: 8,  Options: [6,8,18,24,40,81,90,99]),
        ExampleItem(Equation1: "7 \u{00d7} 4 =", Equation2: "19 \u{00d7} 3 =", Result1: 28, Result2: 57, Options: [4,7,19,28,33,57,74,193]),
        ExampleItem(Equation1: "4 \u{00d7} 21 =", Equation2: "99 \u{00f7} 3 =",Result1: 84, Result2: 33, Options: [9,33,40,80,84,297,421,993]),
        ExampleItem(Equation1: "3 \u{00d7} 24 =", Equation2: "8 \u{00d7} 7 =", Result1: 72, Result2: 56, Options: [48,56,64,70,72,80,87,324]),
        ExampleItem(Equation1: "11 \u{00d7} 7 =", Equation2: "13 \u{00d7} 5 =", Result1: 77, Result2: 65, Options: [52,65,77,117,130,135,177,777]),
        ExampleItem(Equation1: "14 \u{00d7} 5 =", Equation2: "3 \u{00d7} 7 =", Result1: 70, Result2: 21, Options: [7,20,21,28,37,70,140,145]),
        ExampleItem(Equation1: "2 \u{00d7} 19 =", Equation2: "9 \u{00d7} 12 =", Result1: 38, Result2: 108, Options: [19,20,38,90,108,120,219,912]),
        ExampleItem(Equation1: "81 \u{00f7} 9 =", Equation2: "3 \u{00d7} 5 =", Result1: 9, Result2: 15, Options: [3,5,9,15,27,30,35,81]),
        ExampleItem(Equation1: "5 \u{00d7} 5 =", Equation2: "13 \u{00d7} 3 =", Result1: 25, Result2: 39, Options: [5,13,15,25,26,39,55,133])
    ]

    required init?(coder aDecoder: NSCoder) {
        dragNib = UINib.init(nibName: "DraggableView", bundle: nil)
        super.init(coder: aDecoder)
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.drops = [drop1!, drop2!, drop3!, drop4!, drop5!, drop6!, drop7!, drop8!, dropE1!, dropE2!]
        self.drag1 = self.dragNib.instantiate(withOwner: wholeView).first as! DraggableView?
        self.wholeView?.addSubview(self.drag1!)
        self.drag2 = self.dragNib.instantiate(withOwner: wholeView).first as! DraggableView?
        self.wholeView?.addSubview(self.drag2!)
        self.drag3 = self.dragNib.instantiate(withOwner: wholeView).first as! DraggableView?
        self.wholeView?.addSubview(self.drag3!)
        self.drag4 = self.dragNib.instantiate(withOwner: wholeView).first as! DraggableView?
        self.wholeView?.addSubview(self.drag4!)
        self.drag5 = self.dragNib.instantiate(withOwner: wholeView).first as! DraggableView?
        self.wholeView?.addSubview(self.drag5!)
        self.drag6 = self.dragNib.instantiate(withOwner: wholeView).first as! DraggableView?
        self.wholeView?.addSubview(self.drag6!)
        self.drag7 = self.dragNib.instantiate(withOwner: wholeView).first as! DraggableView?
        self.wholeView?.addSubview(self.drag7!)
        self.drag8 = self.dragNib.instantiate(withOwner: wholeView).first as! DraggableView?
        self.wholeView?.addSubview(self.drag8!)
        self.exampleIndex = Int(arc4random_uniform(UInt32(ParentalGateViewController.exampleTable.count)))
        let example = ParentalGateViewController.exampleTable[exampleIndex]
        self.equation1?.text = example.Equation1
        self.equation2?.text = example.Equation2
        self.drag1?.setValue(value: example.Options[0], delegate: self)
        self.drag2?.setValue(value: example.Options[1], delegate: self)
        self.drag3?.setValue(value: example.Options[2], delegate: self)
        self.drag4?.setValue(value: example.Options[3], delegate: self)
        self.drag5?.setValue(value: example.Options[4], delegate: self)
        self.drag6?.setValue(value: example.Options[5], delegate: self)
        self.drag7?.setValue(value: example.Options[6], delegate: self)
        self.drag8?.setValue(value: example.Options[7], delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.drag1?.frame = (self.drop1?.frame)!
        self.drag2?.frame = (self.drop2?.frame)!
        self.drag3?.frame = (self.drop3?.frame)!
        self.drag4?.frame = (self.drop4?.frame)!
        self.drag5?.frame = (self.drop5?.frame)!
        self.drag6?.frame = (self.drop6?.frame)!
        self.drag7?.frame = (self.drop7?.frame)!
        self.drag8?.frame = (self.drop8?.frame)!
    }
    
    @IBAction func onBackTouched(sender: UIButton) {
        
        if((self.presentingViewController) != nil){
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onGoTouched(sender: UIButton) {
        
        if(
            (self.dropE1?.dragItem != nil) &&
            (self.dropE1?.dragItem?.value == ParentalGateViewController.exampleTable[exampleIndex].Result1) &&
            (self.dropE2?.dragItem != nil) &&
            (self.dropE2?.dragItem?.value == ParentalGateViewController.exampleTable[exampleIndex].Result2)) {
            
            
            if((self.presentingViewController) != nil){
                let parent: StartViewController = self.presentingViewController as! StartViewController
                self.dismiss(animated: true, completion:
                    {
                        parent.onParentalGateExit(success: true)
                })
                
            }
        }
        else {
            let alert = UIAlertController(title: "Ask Parents", message: "Ask your parents for help with equation.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                if((self.presentingViewController) != nil){
                    let parent: StartViewController = self.presentingViewController as! StartViewController
                    self.dismiss(animated: true, completion:
                        {
                            parent.onParentalGateExit(success: false)
                    })
                    
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func updateDropViews()
    {
        for view in drops {
            view.isHighlighted = false
        }
        
        for drag in activeDraggers {
            for drop in drops {
                if (((drop.dragItem == nil) || (drop.dragItem == drag)) && (drag.frame.intersects(drop.frame))) {
                    drop.isHighlighted = true
                    break
                }
            }
        }
    }
    
    func onTouchBegin(sender:DraggableView)
    {
        activeDraggers.append(sender)
        self.updateDropViews()
    }
    
    func onTouchMoved(sender:DraggableView)
    {
        self.updateDropViews()
    }
    
    func onTouchEnded(sender:DraggableView)
    {
        var targetDrop:DropableView? = nil
        var originDrop:DropableView? = nil
        for drop in drops {
            if ((drop.dragItem == nil) && (sender.frame.intersects(drop.frame))) {
                targetDrop = drop
                break
            }
        }
        for drop in drops {
            if (drop.dragItem == sender) {
                originDrop = drop
                break
            }
        }
        if (targetDrop != nil) {
            sender.frame = (targetDrop?.frame)!
            targetDrop?.dragItem = sender
            originDrop?.dragItem = nil
        }
        else {
            sender.frame = (originDrop?.frame)!
        }
        self.updateDropViews()
        if let index = activeDraggers.index(of: sender) {
            activeDraggers.remove(at: index)
        }
    }
    
    func onTouchCancelled(sender:DraggableView)
    {
        var originDrop:DropableView? = nil
        for drop in drops {
            if (drop.dragItem == sender) {
                originDrop = drop
                break
            }
        }
        sender.frame = (originDrop?.frame)!
        self.updateDropViews()
        if let index = activeDraggers.index(of: sender) {
            activeDraggers.remove(at: index)
        }
    }
    
}

