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
    let defaults = NSUserDefaults.standardUserDefaults()
    var shakeFlag = true

    @IBOutlet weak var alrightLabel: UILabel!
    @IBOutlet weak var alrightSlider: UISlider!
    @IBOutlet weak var goodLabel: UILabel!
    @IBOutlet weak var goodSlider: UISlider!
    
    @IBOutlet weak var impressiveLabel: UILabel!
    @IBOutlet weak var impressiveSlider: UISlider!
    
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
        
        // Set Tag for Sliders
        alrightSlider.tag = 1
        goodSlider.tag = 2
        impressiveSlider.tag = 3
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /* ======================== Picker ======================== */
    // Have not been implemented yet
    
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
    

    
    /* ==================== Slider ======================= */

    @IBAction func OnSliderValueChanged(sender: AnyObject) {
        updateValueOnSlide(sender as! UISlider)
    }
    
    // Detect which slider is being used and update the proper label
    func updateValueOnSlide(slider: UISlider){
        if slider.tag == 1{
            let alright = Int(round(alrightSlider.value))
            alrightLabel.text = String(alright) + " %"
            defaults.setInteger(alright, forKey: "alright")
        } else if slider.tag == 2 {
            let good = Int(round(goodSlider.value))
            goodLabel.text = String(good) + " %"
            defaults.setInteger(good, forKey: "good")
        } else if slider.tag == 3 {
            let impressive = Int(round(impressiveSlider.value))
            impressiveLabel.text = String(impressive) + "%"
            defaults.setInteger(impressive, forKey: "impressive")
        }
    }
    
    /* ==================== Switch ======================= */
    
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


}
