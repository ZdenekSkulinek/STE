//
//  StartViewController.swift
//  ste
//
//  Created by Zdeněk Skulínek on 23.01.17.
//  Copyright © 2017 Zdeněk Skulínek. All rights reserved.
//

import UIKit

let MAX_LEVEL:Int = 20

class StartViewController: UIViewController {

    
    var lives:Int = 2
    var points:Int = 0
    var level:Int = 0
    var extraTimeRatio:Double = 1.0
    var datasource : HOF = HOF()
    
    @IBOutlet var startLabel:UILabel?
    @IBOutlet var congratulationsLabel:UILabel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
    
    func getLives() ->Int {
        
        var lives:Int = self.lives
        let storedInvulnerability:Int? = KeychainService.loadInvulnerability()
        
        if ((self.level == 0) || (lives == Int(INT_MAX))) {
            lives = 3
        }
        if ( storedInvulnerability != nil && storedInvulnerability! > 0 ){
            
            lives = Int(INT_MAX)
            KeychainService.saveInvulnerability(value: storedInvulnerability! - 1)
        }
        return lives
    }
    
    func getExtraTime() ->Double {
        
        var timeRatio:Double = 1.0
        let storedExtraTime:Int? = KeychainService.loadExtraTime()
        
        if ( storedExtraTime != nil && storedExtraTime! > 0 ) {
            
            timeRatio = 1.2
            KeychainService.saveExtraTime(value: storedExtraTime! - 1)
        }
        return timeRatio
    }
    
    @IBAction func onHelpTouched(sender:UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "sidHelpViewController") as! HelpViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func onPlayTouched(sender:UIButton) {
        
        lives = getLives()
        
        if (level == 0 ) {
            
            level = INITIALLEVEL
        }
        
        extraTimeRatio = getExtraTime()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "sidExpressViewController") as! ExpressViewController
        var xExtraLives:Int? = KeychainService.loadXLives()
        if (self.lives == Int(INT_MAX) || xExtraLives == nil || xExtraLives! <= 0) {
            xExtraLives = 0
        }
        if (xExtraLives! <= 0) {
            xExtraLives = 0
        }
        controller.setup(ilevel: level, ilives: lives + xExtraLives!, iTimeRatio: extraTimeRatio )
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func onBuyTouched(sender:UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var controller: ParentalGateViewController? = nil
        controller = storyboard.instantiateViewController(withIdentifier: "sidParentalGateViewController") as? ParentalGateViewController
        self.present(controller!, animated: true, completion: nil)
    }
    
    @IBAction func onHOFTouched(sender:UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "sidHOFViewController") as! HOFViewController
        controller.setup(model: datasource)
        self.present(controller, animated: true, completion: nil)
    }

    func onParentalGateExit( success:Bool)
    {
        if (success)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var controller: BuyViewController? = nil
            controller = storyboard.instantiateViewController(withIdentifier: "sidBuyViewController") as? BuyViewController
            self.present(controller!, animated: true, completion: nil)
        }
        
    }

    func onExpressExit( points:Int , win:Bool){
        
        self.points += points
        self.view.backgroundColor = UIColor.black
        self.congratulationsLabel?.isHidden = true
        
        let storedLives:Int? = KeychainService.loadXLives()
        var livesLogged = self.lives
        if ( storedLives != nil ) {
            livesLogged += storedLives!
        }
    
        if(win) {

            if( self.level == MAX_LEVEL ) {
                
                self.level = 0
                self.points = 0
                self.lives = 2
                startLabel?.text = "Play\nGame"
                self.view.backgroundColor = UIColor.red
                self.congratulationsLabel?.isHidden = false
                
            }
            else {
                self.level += 1
                startLabel?.text = String.init(format: "Play\nLevel %i", arguments: [self.level] )
                return
            }
            
        }
        else{
            if (self.lives == Int(INT_MAX)) {
                startLabel?.text = String.init(format: "Play\nLevel %i", arguments: [self.level] )
                return
            }
            
            self.lives -= 1
    
            if( self.lives > 0 ) {

                startLabel?.text = String.init(format: "Play\nLevel %i", arguments: [self.level] )
                return
            }
            let storedLives:Int? = KeychainService.loadXLives()
            if ( storedLives != nil && storedLives! > 0 ) {
                self.lives += 1
                KeychainService.saveXLives(value: storedLives! - 1)
                return;
            }
        }
        
        let order = datasource.query(points: self.points)

        if( order != -1 ) {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "sidAddViewController") as! AddViewController
            controller.setup( order: order, points: self.points)
            self.present(controller, animated: true, completion: nil)
        }
        else {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "sidHOFViewController") as! HOFViewController
            controller.setup(model: datasource)
            self.present(controller, animated: true, completion: nil)
            self.level = 0
            self.points = 0
            self.lives = getLives()
        }
        
        startLabel?.text = "Play\nGame"
    }
    

    func onAddExit( playerName:String ) {
    
        datasource.addPlayer(name: playerName, points: self.points, level: self.level)
        datasource.save()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "sidHOFViewController") as! HOFViewController
        controller.setup(model: datasource)
        self.present(controller, animated: true, completion: nil)
        self.level = 0
        self.points = 0
        self.lives = getLives()
    }

}
