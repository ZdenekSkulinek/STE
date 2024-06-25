//
//  BuyViewController.swift
//  ste
//
//  Created by Zdeněk Skulínek on 30.01.17.
//  Copyright © 2017 Zdeněk Skulínek. All rights reserved.
//

import UIKit

class BuyViewController: UIViewController {
    
    @IBOutlet var invulnerabilityDescriptionLabel: UILabel?
    @IBOutlet var xLivesDescriptionLabel: UILabel?
    @IBOutlet var extraTimeDescriptionLabel: UILabel?
    @IBOutlet var invulnerabilityPriceLabel: UILabel?
    @IBOutlet var xLivesPriceLabel: UILabel?
    @IBOutlet var extraTimePriceLabel: UILabel?
    @IBOutlet var totalPriceLabel: UILabel?
    @IBOutlet var invulnerabilitySteeper: UIStepper?
    @IBOutlet var xLivesSteeper: UIStepper?
    @IBOutlet var extraTimeSteeper: UIStepper?
    @IBOutlet var coverView: UIView?
    @IBOutlet var activityIndicator: UIActivityIndicatorView?
    @IBOutlet var buyButton: UIButton?
    @IBOutlet var xlives: UILabel?
    
    var products:IAPProducts
    //var timer:Timer?
    var productsDownloaded: Bool = false;
    
    required init?(coder aDecoder: NSCoder) {
        self.products = IAPProducts()
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateView()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reload()
    }
    
    func reload() {
        
        if (!products.canMakePayments()) {
            self.xLivesSteeper?.value = 0.0
            self.xLivesSteeper?.isEnabled = false
            self.invulnerabilitySteeper?.value = 0.0
            self.invulnerabilitySteeper?.isEnabled = false
            self.extraTimeSteeper?.value = 0.0
            self.extraTimeSteeper?.isEnabled = false
        }
        else {
            self.xLivesSteeper?.isEnabled = true
            self.invulnerabilitySteeper?.isEnabled = true
            self.extraTimeSteeper?.isEnabled = true
        }
        products.requestProducts{success in
            if success {
                self.buyButton?.setTitle("$ Buy", for: UIControlState.normal)
                self.buyButton?.setTitle("$ Buy", for: UIControlState.highlighted)
                self.buyButton?.setTitle("$ Buy", for: UIControlState.selected)
                self.buyButton?.setTitle("$ Buy", for: UIControlState.application)
                self.buyButton?.setTitle("$ Buy", for: UIControlState.focused)
                self.buyButton?.setTitle("$ Buy", for: UIControlState.reserved)
                self.productsDownloaded = true;
            }            
            self.coverView?.isHidden = true
            self.activityIndicator?.stopAnimating()
            self.updateView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @objc public func updateView() {
        
        self.products.updateData(xLivesSteeperValue: Int((xLivesSteeper?.value)!), invulnerabilitySteeperValue: Int((invulnerabilitySteeper?.value)!), timeSteeperValue: Int((extraTimeSteeper?.value)!))
        
        self.xLivesDescriptionLabel?.text = self.products.xLivesDescription()
        self.xLivesPriceLabel?.text = self.products.xLivesPrice()
        self.invulnerabilityDescriptionLabel?.text = self.products.invulnerabilityDescription()
        self.invulnerabilityPriceLabel?.text = self.products.invulnerabilityPrice()
        self.extraTimeDescriptionLabel?.text = self.products.timeDescription()
        self.extraTimePriceLabel?.text = self.products.timePrice()
        self.totalPriceLabel?.text = self.products.total()
        self.xlives?.text = String(self.products.xlives())
        
    }
    
    @IBAction func invulnerabilityStepperValueChanged(sender: UIStepper) {
            
        updateView()
    }
    
    
    @IBAction func xLivesStepperValueChanged(sender: UIStepper) {
        
        updateView()
    }
    
    
    @IBAction func extraTimeStepperValueChanged(sender: UIStepper) {
        
        updateView()
    }
    
    @IBAction func onBackTouched(sender: UIButton) {
        
        if((self.presentingViewController) != nil){
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onBuyTouched(sender: UIButton) {
        
        if (self.productsDownloaded == false) {
            self.reload()
            return
        }
        self.coverView?.isHidden = false
        self.activityIndicator?.startAnimating()
        self.buyButton?.titleLabel?.text = "$ Buy"
        products.buyProducts(xLives: Int((self.xLivesSteeper?.value)!), invulnerability: Int((self.invulnerabilitySteeper?.value)!), extraTime: Int((self.extraTimeSteeper?.value)!)) {success in
            if success {
                print("In-App purchase was successfull")
            }
            else {
                print("In-App purchase FAILED - \(String(describing: self.products.getLastError()))")
                if (self.products.getLastError() != nil) {
                    let alert = UIAlertController(title: "Error", message: self.products.getLastError(), preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                            
                        case .cancel:
                            print("cancel")
                            
                        case .destructive:
                            print("destructive")
                            
                            
                        }}))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            self.coverView?.isHidden = true
            self.activityIndicator?.stopAnimating()
            self.xLivesSteeper?.value = 0.0
            self.invulnerabilitySteeper?.value = 0.0
            self.extraTimeSteeper?.value = 0.0
            self.updateView()
        }
    }
}
