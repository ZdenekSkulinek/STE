//
//  HOFViewController.swift
//  ste
//
//  Created by Zdeněk Skulínek on 23.01.17.
//  Copyright © 2017 Zdeněk Skulínek. All rights reserved.
//

import UIKit

class HOFViewController: UIViewController {
    
    var model:HOF? = nil
    @IBOutlet var table:UITableView?
    
    func setup( model:HOF ) {
        
        self.model = model
        table?.dataSource = model
    }
    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.table?.dataSource = model
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onBackTouched( sender:UIButton) {
        
        if((self.presentingViewController) != nil){
            self.dismiss(animated: true, completion: nil)
        }
    }

}
