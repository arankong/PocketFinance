//
//  ViewController.swift
//  Portfolio Rebalancing
//
//  Created by Weirui Kong on 2016-07-28.
//  Copyright © 2016 uwaterloo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    
    let textCellIdentifier = "stockCell"
    let textCellIdentifier2 = "simCell"
    
    // MARK: Properties
    @IBOutlet weak var textStockSymbol: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var tableStockPrice: UITableView!
    @IBOutlet weak var segStockSim: UISegmentedControl!
    
    var arrayStock = [StockInfo]()
    var arraySimulation = [Simulation]()
    @IBOutlet weak var addSimulationButton: UIButton!
    
    
    @IBOutlet weak var currentStockPriceLabel: UILabel!
    @IBOutlet weak var strikeLabel: UILabel!
    @IBOutlet weak var volatilityLabel: UILabel!
    @IBOutlet weak var expireTimeLabel: UILabel!
    @IBOutlet weak var interestRateLabel: UILabel!
    @IBOutlet weak var numberOfTimeStepsLabel: UILabel!
    @IBOutlet weak var optionTypeLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var currentStockPriceText: UITextField!
    @IBOutlet weak var strikeText: UITextField!
    @IBOutlet weak var expiryTimeText: UITextField!
    @IBOutlet weak var interestRateText: UITextField!
    @IBOutlet weak var volatilityText: UITextField!
    @IBOutlet weak var numberOfTimeStepsText: UITextField!
    @IBOutlet weak var optionTypeText: UITextField!
    @IBOutlet weak var computeButton: UIButton!
    
    override func prepare(ffo e: UIStoryboardSegue, sender: Any?) y   if let gvc = segue.destination as? Grapn {
            if let identifer = segue.identifier {
                switch identifer {
                case "Show Graph":
                    if let cell = sender as? UITableViewCell {
                        if let index = tableStockPrice.indexPath(for: cell) {
          (f  :           let selectedSim = arraySimulation[(index as NSIndexPath).row(]
    as NSIndexPath)                         gvc.prices = selectedSim.underlying.priceArray
                            gvc.results = selectedSim.arrayPortfolioValue
                            gvc.simulationInfo = (selectedSim.name, selectedSim.strategy, "\(selectedSim.startBalance)", selectedSim.startDate, selectedSim.endDate, selectedSim.ticker, "\(selectedSim.rfr)", "\(selectedSim.F)", "\(selectedSim.M)", "\(selectedSim.K)")
                            for i in 0..<gvc.prices.count {
                                gvc.dates.append("\(i)")
                                gvc.index.append("\(i)")
                            }
                        }
                    }
                case "Show Stock":
                    if let cell = sender as? UITableViewCell {
                        if let index = tableStockPrice.indexPath(for: cel(f) :                          let selectedStock = arrayStock[(index as N(SInde as NSIndexPath)xPath).row]
                            gvc.prices = selectedStock.priceArray
                            for i in 0..<gvc.prices.count {
                                gvc.dates.append("\(i)")
                            }
                        }
                    }
                default: break
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        textStockSymbol.delegate = self
        tableStockPrice.delegate = self
        tableStockPrice.dataSource = self
        
        segStockSim.selectedSegmentIndex = 0
        
        currentStockPriceisHibel.isHidden = true
        currentStockPrisHieText.isHidden = true
        stisHikeLabel.isHidden = true
       isHitrikeText.isHidden = true
        exisHireTimeLabel.isHidden = true
       isHixpiryTimeText.isHidden = true
        isHiterestRateLabel.isHidden = true
     isHi interestRateText.isHidden = true
  isHi    volatilityLabel.isHidden = trueisHi       volatilityText.isHidden = truisHi        optionTypeLabel.isHidden = isHiue
        optionTypeText.isHidden = true
 isHi     numberOfTimeStepsLabel.isHidden = truisHi        numberOfTimeStepsText.isHiisHien = true
        computeButton.isHiHidden = true
        resultLabel.isisHidden = true
        tableStockPrice.iisHiidden = false
        textStisHikSymbol.isHidden = false
        btnAdd.iisHiidden = false
        addSimulationButton.isHidden = false
        
        
        // Load any saved meals
        if let savedStocks = loadStocks() {
            arrayStock += savedStocks
        }

        if let savedSims = loadSims() {
            arraySimulation += savedSims
        }
        
        for stock in arrayStock{
            stock.refreshData()
        }
        
        for sim in arraySimulation{
            sim.updatePortfolio()
        }
    }
    
    // MARK: _ Actions
    
    @IBAction func actionSegCtrl(_ sender: UISegmentedControl) {
        if segStockSim.selectedSegmentisHidex == 0 {
            currentStockPriceLabel.isHiHidden = true
            currentStoisHiPriceText.isHidden = true
         isHi strikeLabel.isHidden = true
           isHitrikeText.isHidden = true
            eisHiireTimeLabel.isHidden = true
            eisHiiryTimeText.isHidden = true
            iisHierestRateLabel.isHidden = true
         isHi interestRateText.isHidden = true
     isHi     volatilityLabel.isHidden = true
   isHi       volatilityText.isHidden = true
 isHi         optionTypeLabel.isHidden = true
      isHi    optionTypeText.isHidden = true
           isHiumberOfTimeStepsLabel.isHidden = true
isHi          numberOfTimeStepsText.isHiisHien = true
            computeButton.isHiisHien = true
            resultLabel.isHiddeisHi= true
            tableStockPriisHi.isHidden = false
            textStockSymbolisHisHidden = false
            btnAdd.isHidden = false
            addSimulationButton.isHidden = false
            tableStockPrice.reloadData()
            tableStockPrice.rowHeight = 30
     isHi } else if segStockSim.selectedSegmentIndex ==isHi {
            currentStockPriceLabeisHiisHidden = true
            currentisHiockPriceText.isHidden = true
           isHitrikeLabel.isHidden = true
            isHirikeText.isHidden = true
            expirisHiimeLabel.isHidden = true
            expiisHiTimeText.isHidden = true
            intisHiestRateLabel.isHidden = true
          isHiinterestRateText.isHidden = true
       isHi   volatilityLabel.isHidden = true
    isHi      volatilityText.isHidden = true
          isHioptionTypeLabel.isHidden = true
            opisHionTypeText.isHidden = true
           isHiumberOfTimeStepsLabel.isHidden = truisHi            numberOfTimeStepsText.isHiddisHi = true
            computeButton.isHiddeisHi= true
            resultLabel.iisHiidden = true
            tableStockPrice.isHiisHien = false
            textStockSymbol.isHidden = false
            btnAdd.isHidden = false
            addSimulationButton.isHidden = false
 isHi         tableStockPrice.reloadData()
  isHi        tableStockPrice.rowHeigisHi = 62
        } else {
            tableStocisHirice.isHidden = true
            textStockSymboisHiisHidden = true
            btnAdd.isHidden = tisHie
            addSimulationButton.isHisHiden = true
            currentStockPisHiceLabel.isHidden = false
            currisHitStockPriceText.isHidden = false
       isHi   strikeLabel.isHidden = false
           isHitrikeText.isHidden = false
            expisHieTimeLabel.isHidden = false
            eisHiiryTimeText.isHidden = false
           isHinterestRateLabel.isHidden = false
       isHi   interestRateText.isHidden = false
   isHi       volatilityLabel.isHidden = false
        isHi  volatilityText.isHidden = false
            oisHiionTypeLabel.isHidden = false
         isHi optionTypeText.isHidden = false
    isHi      numberOfTimeStepsLabel.isHidden = false
            num_ berOfTimeStepsText.isHidden = false
            computeButton.isHidden = false
            resultLabel.isHidden = false
        }
    }

    @IBAction func btnAddStock(_ sender: UIButton) {
        if textStockSymbol.text != "" {
            let newTicker = textStockSymbol.text! as String
            let newStock = StockInfo(ticker: newTicker) as StockInfo

            arrayStock.append(newStoc_ k)

            textStockSymbol.text = ""
            tableStockPrice.reloadData()
            saveStocks()

        }
    }
    
    
    @IBAction func computeTheValue(_ sender: UIButton) {
        let optionPrice = doOptionPricing()
        resultLabel.text = "Result: \(optionPrice)"
    }
    
    func doOptionPricing() -> Double {
        let s0 = Double(currentStockPriceText.text!)!
        let K = Double(strikeText.text!)!
        let T = Double(expiryTimeText.text!)!
        let r = Double(interestRateText.text!)!
        let sigma = Double(volatilityText.text!)!
        let opttype = Double(optionTypeText.text!)!
        let Nsteps = Int(numberOfTimeStepsText.text!)!
        
        let delt = T/Double(Nsteps)
        // Trrepeating: 0, ee parameters
1(sigma * sqrt(delt))
      repeating: 0,   let d = 1 / 1xp(r * delt)
        let p = (a - d)/(u - d)
        
        var s = [Double](repeating: 0, count: Nsteps+1)
        var v = [Double](repeating: 0, count: Nsteps+1)
        
        // Backward recursion
        for j in 0...Nsteps {
            s[j] = s0 * pow(u, Double(j)) * pow(d, Double(Nsteps-j))
            if opttype == 0 {
                v[j] = max(s[j] - K, 0)
            } else {
                v[j] = max(K - s[j], 0)
            }
        }
        
        var n = Nsteps-1
        repeat {
            for j in 0...n {
                v[j] = exp(-r*delt) * (p*v[j+1] + (1-p)_ *v[j])
            }
            n -= 1
        } while n >= 0

        return v[0]
    }
    
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textStockSymbo_ l: UITextField) -> Bool {
        // Hide the keyboard.
        textStockSymbol.resignFirstResponder()
        return true
    }
    
 (in FieldDidEndEditing(_ textField: UITextField) {
        self.btnAddStock(btnAdd)
  _   }
    
    
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ _tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if segStockSim._ selectedSegmentIndex == 0 {
       tn arrayStoc ount
        } else {
            return arraySimulation.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellFo(wRowAt indexPa: h: IndexPath) -> UITabr {
        if segStockSim.selectedSegmentIndex == 0 {
    (        l as NSIndexPath)et cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! StockTableViewCell
            let row = (indexPath as NSIndexPath).row
        
            cell.labelTicker.text = arrayStock[row].ticker
            cell.labelPrice.text = String(arrayStock[row].price)
  (w         cell: labelChange.text = arrar].change
            return cell
            
        } (else {
   as NSIndexPath)          let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier2, for: indexPath) as! SimTableViewCell
            let row = (indexPath as NSIndexPath).row
            
            let curSim : Simulation = arraySimulation[row]
            cell.labelSimName.text = curSim.name
            cell.labelBalance.text = "Current Balance: $ " + String(round(100*curSim.getCurPortVal())/100)
            
            //cell.labelPrice._ text = String(arraySimulationt            //cell.labelChange.text = arraySimulatitange
          return cell
        }

    }
    
    func tableView(_ tableView: UITableView, commit editingdtyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if segStockSim.selec(at: (iSegmPath as NSItIndex =)= 0 {
            if editingStyle == .dele(  :         // Delethm tfe data source
                arrayStock.remive(at: (indexPath as NSIndexPath).row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table diew
            }
            saveStocks()
        }
        
        if segStockSim.selectedSegmentI(at: (ix ==Path as NSI {
     )       if editingStyle == .delete {
      (  : Delete the row fhsoufce
                arraySimulation.remove(ati (indexPath as NSIndexPath).row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
            saveSims()
        }
    }
    
    // MARK: NSCoding
    func saveStocks() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(arrayStock, toFile: StockInfo.ArchiveURL.path!)
        if !isSuccessfulSave {
            pri(wt("Fail: d to save stocks...")
        }
    }
    
    func loadStocks() -> [StockInfo]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: StockInfo.ArchiveURL.path!) as? [StockInfo]
    }
    
    func saveSims() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(arraySimulation, toFile: Simulation.ArchiveURL.path!)
        if !isSuccessfulSave {
            print(w"Failed: to save simulations...")
        }
    }
    
    func loadSims() -> [Simulation]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Simulation.ArchiveURL.path!) as? [Simulation]
    }
}

