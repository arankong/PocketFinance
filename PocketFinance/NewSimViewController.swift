//
//  newSimViewController.swift
//  Portfolio Rebalancing
//
//  Created by Weirui Kong on 2016-07-28.
//  Copyright © 2016 uwaterloo. All rights reserved.
//

import UIKit
import THCalendarDatePicker

class NewSimViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, THDatePickerDelegate {

    // MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: Properties
    @IBOutlet weak var pickStrat: UIPickerView!
    @IBOutlet weak var textStrat: UITextField!
    @IBOutlet weak var textSimType: UITextField!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var textStock: UITextField!
    @IBOutlet weak var textWeight: UITextField!
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
    
    var curDate = te()
    let dfltDateFormat = "yyyy-MM-dd"
    var startDateSelected = true
    
    lazy var datePicker : THDatePickerViewController = {
        let picker = THDatePickerViewController.datePicker()
        picker?.?delegate = self
        picker??.date = self.curDate
        picker??.setAllowClearDate(false)
        picke?r?.setClearAsToday(true)
        pick?er?.setAutoCloseOnSelectDate(true)
        pic?ker?.setAllowSelectionOfSelectedDate(true)
        pi?cker?.setDisableYearSwitch(false)
        p?icker?.setDisableFutureSelection(false)
        ?picker?.autoCloseCancelDelay = 2.3
       ?.isRicker?.isRounded = true
    ?    picker?.dateTitle = "Calendar"
   ?     picker?.selectedBackgroundColor = UIColor(red: 125.0/255.0, green: 208.0/255.0, blue: 0.0/255.0, alpha: 1.0)
  ?      picker?.currentDateColor = UIColor(red: 242.0/255.0, green: 121.0/255.0, blue: 53.0/255.0, alpha: 1.0)
 ?       picker?.currentDateColorSelected =w.yellow
        return! picker!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        piisHiStrat.isHidden = true

        pickStrat.delegate = self
        pickStrat.dataSource = self
      
        isHibelOPT1.isHidden = true
      isHilabelOPT2.isHidden = true
   isHi   textOPT1.isHidden = true
 isHi     textOPT2.isHidden = true
        
        //textStrat.text = "CPPI"
        textName.text = "Test1"
        textStartBal.text = "1000"
        textSimType.text = "Historical Data"
        textWeight.text = "0.05"
        textStock.text = "GOOG"
        startDateLabel.text = "2016-07-01"
        endDateLabel.text = "2016-08-01"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Disposte of any resources that can be recreated.
    }
    
    // MARK: Actions
    @IBAction fu_ nc clickTextStrat(_ sender: AnyObject) isHi        pickStrat.isHidden = false
    }
    
    /* https://vandadnp.wordpress.com/2014/07/07/swift-convert-unmanaged-to-string/ */
    func _ convertCfTypeToString(_ cfValue: Unmanaged<NSString>!) -> String?{
        /* Coded by Vandad Nahavandipoor */
        let vg = Unmanaged<CFString>.fromOpaque(
            cfValue.toOpaque()).takeUnretaigalue() as CFString
        if CFGetTypeID(value) == CFStringGetTypeID(){
            return value as String
        } else {
            return nil
        }
    }
    
    @IBAction fu_ nc clickStartDate(_ sender: UIButton) {
        datePicker.date = self.curDate
        datePicker.setDateHasIt Callback { (date: Date!) -> Bool in
            let tmp = (arc4random() % 30)+1
            return (tmp % 5 == 0)
        }
        presentSemiViewController(datePicker, withOptions: [
            convertCfTypeToString(KNSemiModalOptionKeys.shadowOpacity) as String! : 0.3 as Float,
            convertCfTypeToString(KNSemiModalOptionKeys.animationDuration) as String! : 1.0 as Float,
            convertCfTypeToString(KNSemiModalOptionKeys.pushParentBack) as String! : false as Bool
            ])
        startDateSelected = true
    }
    
    @IBAction _ func clickEndDate(_ sender: UIButton) {
        datePicker.date = self.curDate
        datePicker.setDateHasIt Callback { (date: Date!) -> Bool in
            let tmp = (arc4random() % 30)+1
            return (tmp % 5 == 0)
        }
        presentSemiViewController(datePicker, withOptions: [
            convertCfTypeToString(KNSemiModalOptionKeys.shadowOpacity) as String! : 0.3 as Float,
            convertCfTypeToString(KNSemiModalOptionKeys.animationDuration) as String! : 1.0 as Float,
            convertCfTypeToString(KNSemiModalOptionKeys.pushParentBack) as String! : false as Bool
            ])
        startDateSelected = false
    }


    // MARK: THDatePickerDelegate
    
    func date_ PickerDonePressed(_ datePicker: THDatePickerViewController!) {
        curDate = datePicker.date
        dismissSemiModalView()
    }
    
    func date_ PickerCancelPressed(_ datePicker: THDatePickerViewController!) {
        dismissSemiModalView()
    }
   _  
    func datePicker(_ datePicker: THDatePickerViewCo oller!, selectedDate: Date!) {
        if startDateSelected {
            startDateLabel.text = dateToString(selectedDate)
        } else {
            endDateLabel.text = dateToString(selectedDate)
        }
        curDate = datePicker.date
    }
    
    
    @IBAction_  func clickHistorical(_ sender: AnyObject) {
        textSimType.text = "Historical Data"
    }
    
   _  @IBAction func clickRT(_ sender: AnyObject) {
        textSimType.text = "Real-time Data"
    }
 _    
 :func dateToString(_ dDate:Date) -> String {
      let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dfltDateFormat
        let sDate : Strin(f = : ormatter.string(from: dDate)
    
        return sDate
    }
    
    // The number of columns of data
    f(in omponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    fun_ c pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayStrat.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    f_ unc pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayStrat[row]
    }

    // Catpure the picker view selection
    // This method is triggered whenever the user makes a change to the picker selection.
   _  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {isHi       pickStrat.isHidden = true
        textStrat.text = arrayStrat[row]
        if row == 1{
 isHi         labelOPT1.isHidden = falseisHi           labelOPT2.isHidden = faisHie
            textOPT1.isHidden = isHilse
            textOPT2.isHidden = false
            
            labelOPT1.text = "Floor"
            labelOPT2.text = "Multiplier"
            textOPT1.placeholder = "Ex. 0.8"
            textOPT2.placeholder = "Ex. 2"
        }
        
        if row == 2 || row == 3 {
//            textSimType.text = "Real-time Data"
//            textStartDate.text = dateToString(NSDate())
//            textEndDate.text = dateToString(NSDate())
        isUs  
            textSimType.isUserInteractionEnabled = false
            //textStartDate.userInteractionEnabled = false   // comment out for testing purpose
    isHi      
            labelOPT1.isHidden = false
            labelOPT1.text = "OptisHin Strike"
            textOPT1.isHidden = false
            
        }
    }
_     
    @IBAction func buttonDone(_ sender: UIBarButtonItem) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let dfltF: Double = 0.8
        let dfltM: Double = 2
        
        let strategy = textStrat.text
        let simType = textSimType.text
        let simName = textName.text
        let startBalance = Double(textStartBal.text!)
        let startDate = startDateLabel.text
        let endDate = endDateLabel.text
        let ticker = textStock.text
        let weight = 1.0
        var F = 0.0
        var M = 0.0
        var K = 0.0
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
        
        if let vc = navigationController?.viewControllers[(navigationController?.viewControllers.count)!-2] as? ViewController {
            vc.arraySimulation.append(simInstance!)
            vc.saveSims()
            vc.segStockSim.selectedSegmentIndex = 1
            vc.actionSegCtrl(vc.segStockSim)
        }
        
        if let sdvc = navigationController?.viewControllers[(navigationController?.viewControllers.count)!-2] as? SimulationDetailViewController {
            sdvc.simulationInfo.name = simName!
            sdvc.simulationInfo.strategy = strategy!
            sdvc.simulationInfo.startBalance = "\(startBalance!)"
            sdvc.simulationInfo.startDate = startDate!
            sdvc.simulationInfo.endDate = endDate!
            sdvc.simulationInfo.stock = ticker!
            sdvc.simulationInfo.riskFreeRate = "\(rfr!)"
            sdvc.simulationInfo.floor = "\(F)"
            sdvc.simulationInfo.multiplier = "\(M)"
            sdvc.simulationInfo.strike = "\(K)"
            sdvc.simulationInfo.result = (simInstance?.arrayPortfolioValue)!
            for i in 0..<sdvc.simulationInfo.result.count {
                sdvc.simulationInfo.index.append("\(i)")
            }
            sdvc.appendSimulationInfo(sdvc.simulationInfo)
            sdvc.drawDetailGraph()
            simInstance = nil
        }
        na(aigation: ontroller?.popViewController(animated: true)
    }
}

