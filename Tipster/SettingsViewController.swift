//
//  SettingsViewController.swift
//  Tipster
//
//  Created by Oranuch on 12/21/15.
//  Copyright © 2015 Oranuch. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate
 {
    @IBOutlet weak var shakeSwitch: UISwitch!
    @IBOutlet weak var switchField: UITextField!
    @IBOutlet weak var percentPicker: UIPickerView!
    @IBOutlet weak var alrightTextField: UITextField!
    @IBOutlet weak var goodTextField: UITextField!
    @IBOutlet weak var impressiveTextField: UITextField!
    let defaults = NSUserDefaults.standardUserDefaults()
    var shakeFlag = true

    
    let percentDicts = ["15%":0.15, "18%":0.18, "20%":0.20, "25%":0.25, "30%":0.3]
    //let percentKeys = ["15%","18%","20%","25%","30%"]
    var currentPercentage = 0
    var currentTextField = UITextField()
    var percentKeys:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shakeFlag = defaults.boolForKey("shakeFlag")
        settingShakeSwitch(shakeFlag)
        percentPicker.hidden = true
        
        //Sort(asc) percentDicts by key
        percentKeys = percentDicts.keys.sort{$0<$1}
    }

    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return percentDicts.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return percentKeys[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        currentTextField.text = percentKeys[row]
        percentPicker.hidden = true;
        //save the index of the selected row
        currentPercentage = row
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        percentPicker.hidden = false
        //identify the current active text field
        currentTextField = textField
        return false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
//        defaults.setDouble(Double(alrightField.text!)!, forKey: "alright")
//        defaults.setDouble(Double(goodField.text!)!, forKey: "good")
//        defaults.setDouble(Double(impressiveField.text!)!, forKey: "impressive")
        defaults.synchronize()
    }
    
    // Switch to turn on shake to clear function
    @IBAction func onShakeSwitched(sender: AnyObject) {
        if(shakeSwitch.on){
            settingShakeSwitch(true)
        } else {
            settingShakeSwitch(false)
        }
    }

    // Function to set the proper label and graphic for shake switch
    func settingShakeSwitch(state: Bool){
        if(state == true){
            shakeFlag = true
            shakeSwitch.setOn(true, animated: true)
            switchField.text = "ON"
        } else {
            shakeFlag = false
            shakeSwitch.setOn(false, animated: false)
            switchField.text = "OFF"
        }
        defaults.setBool(shakeFlag, forKey: "shakeFlag")
        defaults.synchronize()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
