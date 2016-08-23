//
//  newSimViewController.swift
//  Portfolio Rebalancing
//
//  Created by Weirui Kong on 2016-07-28.
//  Copyright © 2016 uwaterloo. All rights reserved.
//

import UIKit

class NewSimViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    // MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: Properties
    @IBOutlet weak var pickStrat: UIPickerView!
    @IBOutlet weak var textStrat: UITextField!
    @IBOutlet weak var textSimType: UITextField!
    
    @IBOutlet weak var pickDate: UIDatePicker!
    @IBOutlet weak var textStartDate: UITextField!
    @IBOutlet weak var textEndDate: UITextField!
    @IBOutlet weak var textStock: UITextField!
    @IBOutlet weak var textWeight: UITextField!
    @IBOutlet weak var btnDone: UIBarButtonItem!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textStartBal: UITextField!
    
    // Optional User Data
    @IBOutlet weak var labelOPT1: UILabel!
    @IBOutlet weak var labelOPT2: UILabel!
    @IBOutlet weak var textOPT1: UITextField!
    @IBOutlet weak var textOPT2: UITextField!
    //This value is passed to View Control in `prepareForSegue(_:sender:)`
    var simInstance: Simulation?
    
    var arrayStrat: [String] = ["","CPPI","Covered Call Writing","Stop Loss"]
    
    var dDate =  NSDate()
    let dfltDateFormat = "yyyy-MM-dd"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickStrat.hidden = true
        pickDate.hidden = true
        pickDate.datePickerMode = .Date

        pickStrat.delegate = self
        pickStrat.dataSource = self
      
        labelOPT1.hidden = true
        labelOPT2.hidden = true
        textOPT1.hidden = true
        textOPT2.hidden = true
        
        //textStrat.text = "CPPI"
        textName.text = "Test1"
        textStartBal.text = "1000"
        textSimType.text = "Historical Data"
        textWeight.text = "0.05"
        textStock.text = "GOOG"
        textStartDate.text = "2016-07-01"
        textEndDate.text = "2016-08-01"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Disposte of any resources that can be recreated.
    }
    
    // MARK: Actions
    @IBAction func clickTextStrat(sender: AnyObject) {
        pickStrat.hidden = false
    }
    
    @IBAction func clickStartDate(sender: AnyObject) {
        pickDate.hidden = false
    }

    @IBAction func doneStartDate(sender: AnyObject) {
        pickDate.hidden = true
        textStartDate.text = dateToString(dDate)
    }
    
    @IBAction func clickEndDate(sender: AnyObject) {
        pickDate.hidden = false
    }
    
    @IBAction func doneEndDate(sender: AnyObject) {
        pickDate.hidden = true
        textEndDate.text = dateToString(dDate)
    }
    
    @IBAction func pickDate(sender: AnyObject) {
        dDate = pickDate.date
    }
    
    @IBAction func clickHistorical(sender: AnyObject) {
        textSimType.text = "Historical Data"
    }
    
    @IBAction func clickRT(sender: AnyObject) {
        textSimType.text = "Real-time Data"
    }
    
    func dateToString(dDate:NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dfltDateFormat
        let sDate : String = dateFormatter.stringFromDate(dDate)
    
        return sDate
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayStrat.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayStrat[row]
    }

    // Catpure the picker view selection
    // This method is triggered whenever the user makes a change to the picker selection.
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickStrat.hidden = true
        textStrat.text = arrayStrat[row]
        if row == 1{
            labelOPT1.hidden = false
            labelOPT2.hidden = false
            textOPT1.hidden = false
            textOPT2.hidden = false
            
            labelOPT1.text = "Floor"
            labelOPT2.text = "Multiplier"
            textOPT1.placeholder = "Ex. 0.8"
            textOPT2.placeholder = "Ex. 2"
        }
        
        if row == 2 || row == 3 {
//            textSimType.text = "Real-time Data"
//            textStartDate.text = dateToString(NSDate())
//            textEndDate.text = dateToString(NSDate())
            
            textSimType.userInteractionEnabled = false
            //textStartDate.userInteractionEnabled = false   // comment out for testing purpose
            textEndDate.userInteractionEnabled = false
            
            labelOPT1.hidden = false
            labelOPT1.text = "Option Strike"
            textOPT1.hidden = false
            
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let dfltF:Double = 0.8
        let dfltM:Double = 2
        
        if btnDone === sender {
            
            let strategy = textStrat.text
            let simType = textSimType.text
            let simName = textName.text
            let startBalance = Double(textStartBal.text!)
            let startDate = textStartDate.text
            let endDate = textEndDate.text
            let ticker = textStock.text
            let weight = 1.0
            let F : Double
            let M : Double
            let K : Double
            
            //temp
            let rfr = Double(textWeight.text!)
            
            // Run simulations
            if strategy == "CPPI" {
                F = (textOPT1.text == "") ? dfltF * startBalance! : Double(textOPT1.text!)! * startBalance!
                M = (textOPT2.text == "") ? dfltM : Double(textOPT2.text!)!

                simInstance = Simulation(name: simName!, strategy: strategy!, type: simType!, startBalance: startBalance!, startDate: startDate!, endDate: endDate!, ticker: ticker!, weight: weight, rfr: rfr!, F: F, M: M, K:nil, arrayPortfolioValue : nil)
                simInstance!.runCPPI()
                
            } else if strategy == "Covered Call Writing" || strategy == "Stop Loss" {
                K = Double(textOPT1.text!)!
                
                simInstance = Simulation(name: simName!, strategy: strategy!, type: simType!, startBalance: startBalance!, startDate: startDate!, endDate: endDate!, ticker: ticker!, weight: weight, rfr: rfr!, F: nil, M: nil, K:K, arrayPortfolioValue : nil)
                if strategy == "Covered Call Writing" {
                    simInstance!.runCoveredCall()
                } else {
                    simInstance!.runStopLoss()
                }
            }
        }
    }

}

