//
//  ViewController.swift
//  Tipster
//
//  Created by Oranuch on 12/19/15.
//  Copyright © 2015 Oranuch. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    @IBOutlet weak var billField:UITextField!
    @IBOutlet weak var tipLabel:UILabel!
    @IBOutlet weak var totalLabel:UILabel!
    @IBOutlet weak var tipControl:UISegmentedControl!
    @IBOutlet weak var tipIncludedLabel: UILabel!
    @IBOutlet weak var tipIncludedSwitch: UISwitch!

    @IBOutlet weak var personLabel: UILabel!
    
    @IBOutlet weak var splitStepper: UIStepper!
   
    @IBOutlet weak var numPeopleSplit: UILabel!
    @IBOutlet weak var eachPersonLabel: UILabel!
    @IBOutlet weak var eachPersonAmount: UILabel!
    @IBOutlet weak var settingBarButtonItem: UIBarButtonItem!
   
    //    let defaultsServicePercentDict = ["Good":0.18, "Great":0.20, "Excellent":0.22]
    let tipPercentages = [0.18, 0.2, 0.22]
    var splitValue = 1
    var total = 0.0
    var tip = 0.0
    var splitAmount = 0.0
    var shakeFlag = true
    var tipIncludedFlag = false
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // The cursor is ready at Bill Field when the app is open
        billField.becomeFirstResponder()
        settingSwitch(false)

        if(defaults.integerForKey("savedTimeStamp") > 0){
            restoreSession()
        } else {
            tipLabel.text = "$0.00"
            totalLabel.text = "$0.00"
            personLabel.text = "\u{f007}"
            eachPersonLabel.text = "Each Person"
            numPeopleSplit.text = "x 1"
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        shakeFlag = defaults.boolForKey("shakeFlag")
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        storeSession()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onSwitch(sender: AnyObject) {
        
    }

    // When select the different item of segment control
    @IBAction func onEditingChanged(sender: AnyObject) {
        calculateTip()
        updateLabel()
    }
    
    // Tap to hide keyboard
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true) // dismiss keyboard
    }
    
    // Calculate the amount splitting for each person
    @IBAction func splitNumber(sender: AnyObject) {
        splitValue = Int(splitStepper.value)
        numPeopleSplit.text = "x " + String(splitValue)
        splitAmount = total/Double(splitValue)
        eachPersonAmount.text = String(format: "$%.2f" , splitAmount)
        
    }
    
    func updateLabel(){
        tipLabel.text = formatCurrencyByType("USD" , amount: tip)
        totalLabel.text = formatCurrencyByType("USD", amount: total)
        eachPersonAmount.text = formatCurrencyByType("USD", amount: splitAmount)
    }
    
    func calculateTip(){
        // Array of TipPercentages
        let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        let billAmount = Double(billField.text!) ?? 0
        if(tipIncludedFlag == true){
            tip = 0.0
        } else {
            tip = billAmount * tipPercentage
        }
        total = billAmount + tip
        splitAmount = total/(Double(splitValue))
    }
    
    @IBAction func onSwitched(sender: AnyObject) {
        if(tipIncludedSwitch.on){
            settingSwitch(true)
        } else {
            settingSwitch(false)
        }
        calculateTip()
        updateLabel()
    }
    func settingSwitch(state: Bool){
        if(state == true){

            tipIncludedFlag = true
            tipIncludedSwitch.setOn(true, animated: true)
            tipIncludedLabel.text = "Tip included"
        } else{
            tipIncludedFlag = false
            tipIncludedSwitch.setOn(false, animated: false)
            tipIncludedLabel.text = "Tip Not included"
        }

    }
    
    
    func storeSession(){
        defaults.setInteger(Int(NSDate().timeIntervalSince1970), forKey: "savedTimeStamp")
        defaults.setValue(billField.text, forKey: "savedAmount")
        defaults.setValue(tipLabel.text, forKey: "savedTip")
        defaults.setValue(totalLabel.text,forKey: "savedTotal")
        defaults.setInteger(tipControl.selectedSegmentIndex, forKey: "selected_segment")
        defaults.setValue(numPeopleSplit.text, forKey: "savedSplit")
        defaults.setValue(eachPersonAmount.text, forKey: "savedEachAmount")
        
        defaults.synchronize()
        
    }
    
    func restoreSession(){
        // restore the session if the data is saved within 10 minutes
        let savedTimeStamp = defaults.integerForKey("savedTimeStamp") ?? 0;
        let currentTimeStamp = Int(NSDate().timeIntervalSince1970);
        if(currentTimeStamp - savedTimeStamp < 600) {
            billField.text = defaults.stringForKey("savedAmount")
            tipLabel.text = defaults.stringForKey("savedTip")
            totalLabel.text = defaults.stringForKey("savedTotal")
            tipControl.selectedSegmentIndex = defaults.integerForKey("selected_segment")
            numPeopleSplit.text = defaults.stringForKey("savedSplit")
            eachPersonAmount.text = defaults.stringForKey("savedEachAmount")
        }
    }
    
    // Shake to clear
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if(shakeFlag && motion == .MotionShake) {
            clear()
        }
    }
    
    func formatCurrencyByType(currencyType: String = "USD", amount: Double) -> String {
        //format using the selected currency
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.currencyCode = currencyType
        return formatter.stringFromNumber(amount)!
    }
    
    func clear(){
        tip = 0.0
        total = 0.0
        splitAmount = 0.0
        billField.text = ""
        numPeopleSplit.text = "x 1"
        updateLabel()
    }
    

}


