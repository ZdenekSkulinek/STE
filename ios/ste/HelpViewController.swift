//
//  HelpViewController.swift
//  ste
//
//  Created by Zdeněk Skulínek on 23.08.18.
//  Copyright © 2018 Zdeněk Skulínek. All rights reserved.
//

import Foundation
import UIKit

class HelpViewController: UIViewController {
    
    @IBOutlet var scrollView:UIScrollView?
    @IBOutlet var contentView:UIImageView?
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        scrollView?.contentSize = CGSize(width: 1880/2, height: 2659/2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackTouched(sender: UIButton) {
        
        if((self.presentingViewController) != nil){
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}
