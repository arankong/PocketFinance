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
    
    //var numStock = 2
    
    // MARK: Properties
    @IBOutlet weak var textStockSymbol: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var tableStockPrice: UITableView!
    @IBOutlet weak var segStockSim: UISegmentedControl!
    
    var arrayStock = [stockInfo]()
    var arraySimulation = [simulation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        textStockSymbol.delegate = self
        tableStockPrice.delegate = self
        tableStockPrice.dataSource = self
        
        segStockSim.selectedSegmentIndex = 0
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func actionSegCtrl(sender: UISegmentedControl) {
        if segStockSim.selectedSegmentIndex == 0{
            print("1")
            tableStockPrice.reloadData()
            tableStockPrice.rowHeight = 30
            
        } else {
            print("2")
            tableStockPrice.reloadData()
            tableStockPrice.rowHeight = 62
            
        }
        //tableStockPrice.reloadData()
    
    }

    @IBAction func btnAddStock(sender: UIButton) {
        if textStockSymbol.text != "" {
            let newTicker = textStockSymbol.text! as String
            let newStock = stockInfo(ticker: newTicker) as stockInfo

            arrayStock.append(newStock)

            textStockSymbol.text = ""
            tableStockPrice.reloadData()
            saveStocks()

        }
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textStockSymbol: UITextField) -> Bool {
        // Hide the keyboard.
        textStockSymbol.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.btnAddStock(btnAdd)
    }
    
    
    // MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            
        if segStockSim.selectedSegmentIndex == 0{
            return arrayStock.count
        } else{
            return arraySimulation.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if segStockSim.selectedSegmentIndex == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! StockTableViewCell
        
            let row = indexPath.row
        
            cell.labelTicker.text = arrayStock[row].ticker
            cell.labelPrice.text = String(arrayStock[row].price)
            cell.labelChange.text = arrayStock[row].change
            return cell
            
        } else{
            let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier2, forIndexPath: indexPath) as! SimTableViewCell
            
            let row = indexPath.row
            
            let curSim : simulation = arraySimulation[row]
            cell.labelSimName.text = curSim.name
            cell.labelBalance.text = "Current Balance: $ " + String(round(100*curSim.getCurPortVal())/100)
            
            //cell.labelPrice.text = String(arraySimulation[row].price)
            //cell.labelChange.text = arraySimulation[row].change
            return cell
        }

    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if segStockSim.selectedSegmentIndex == 0 {
            if editingStyle == .Delete {
                // Delete the row from the data source
                arrayStock.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            } else if editingStyle == .Insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
            saveStocks()
        }
        
        if segStockSim.selectedSegmentIndex == 1 {
            if editingStyle == .Delete {
                // Delete the row from the data source
                arraySimulation.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            } else if editingStyle == .Insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
            saveSims()
        }
    }
    
    // MARK: NSCoding
    func saveStocks() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(arrayStock, toFile: stockInfo.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save stocks...")
        }
    }
    
    func loadStocks() -> [stockInfo]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(stockInfo.ArchiveURL.path!) as? [stockInfo]
    }
    
    func saveSims() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(arraySimulation, toFile: simulation.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save simulations...")
        }
    }
    
    func loadSims() -> [simulation]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(simulation.ArchiveURL.path!) as? [simulation]
    }
    
    // MARK: Navigation
    @IBAction func unwindToSimList(sender: UIStoryboardSegue) {
        print("navigation")
        let sourceViewController = sender.sourceViewController as? NewSimViewController, sim = sourceViewController!.simInstance
        // Add a new simulation
        arraySimulation.append(sim!)
        saveSims()
        
        segStockSim.selectedSegmentIndex = 1
        self.actionSegCtrl(segStockSim)

    }
}

