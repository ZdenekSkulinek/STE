//
//  AddViewController.swift
//  ste
//
//  Created by Zdeněk Skulínek on 23.01.17.
//  Copyright © 2017 Zdeněk Skulínek. All rights reserved.
//

import UIKit

class AddViewController: UIViewController , UITextFieldDelegate{
    
    @IBOutlet var orderLabel:UILabel?
    @IBOutlet var pointsLabel:UILabel?
    @IBOutlet var nameTextfield:UITextField?
    

    var order:Int
    var points:Int


    func setup( order:Int, points:Int) {
        

        self.order = order
        self.points = points
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        
        order = 0
        points = 0
        super.init(coder: aDecoder)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        switch ( order )
            {
                case 0: self.orderLabel?.text = String.init(format: "You are The Best Player.")
                        break
                case 1: self.orderLabel?.text = String.init(format: "You are The Second Best Player.")
                        break
                case 2: self.orderLabel?.text = String.init(format: "You are The Third Best Player.")
                        break
                default:self.orderLabel?.text = String.init(format: "You are The %ith Test Player.",order+1)
            }
                    
        self.pointsLabel?.text = String.init(format: "Your score is %i points.",points)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onSubmitTouched( sender:UIButton) {
        
        if((self.presentingViewController) != nil){
            let parent: StartViewController = self.presentingViewController as! StartViewController
            self.dismiss(animated: true, completion:
                {
                    parent.onAddExit(playerName: (self.nameTextfield?.text)! )
            })
            
        }
    }
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        for char in string {
            
            if ( char == ";" ) {
                
                return false
            }
        }
        return true
    }
    

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        self.view.frame=CGRect(x:self.view.frame.origin.x, y:-self.view.frame.size.height / 2.0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        self.view.frame=CGRect(x:self.view.frame.origin.x, y: 0.0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        nameTextfield?.resignFirstResponder()
        return true
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.frame=CGRect(x:self.view.frame.origin.x, y: 0.0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        nameTextfield?.resignFirstResponder()
        return true
    }


}
