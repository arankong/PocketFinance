//
//  SimulationDetailViewController.swift
//  PocketFinance
//
//  Created by Weirui Kong on 2016-08-23.
//  Copyright © 2016 uwaterloo. All rights reserved.
//

import UIKit
import Charts
class SimulationDetailViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var simulationDetailGraphView: LineChartView!
    @IBOutlet weak var simulationNameLabel: UILabel!
    @IBOutlet weak var strategyLabel: UILabel!
    @IBOutlet weak var startBalanceLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var riskFreeRateLabel: UILabel!
    @IBOutlet weak var floorOrOptionStrike: UILabel!
    @IBOutlet weak var floorOrStrikeLabel: UILabel!
    @IBOutlet weak var multiplierOrNone: UILabel!
    @IBOutlet weak var moltiplierOrNoneLabel: UILabel!
    
    struct SimulationInfo {
        var name = ""
        var strategy = ""
        var startBalance = ""
        var startDate = ""
        var endDate = ""
        var stock = ""
        var riskFreeRate = ""
        var floor = ""
        var multiplier = ""
        var strike = ""
        var result = [Double]()
        var index = [String]()
    }
    
    let graphColorArray = [UIColor.blueColor().colorWithAlphaComponent(0.5), UIColor.greenColor().colorWithAlphaComponent(0.5), UIColor.yellowColor().colorWithAlphaComponent(0.5), UIColor.cyanColor().colorWithAlphaComponent(0.5), UIColor.redColor().colorWithAlphaComponent(0.5), UIColor.orangeColor().colorWithAlphaComponent(0.5), UIColor.purpleColor().colorWithAlphaComponent(0.5), UIColor.darkGrayColor().colorWithAlphaComponent(0.5), UIColor.brownColor().colorWithAlphaComponent(0.5), UIColor.magentaColor().colorWithAlphaComponent(0.5)]
    var colorNumber = 0
    
    var simulationInfoArray = [SimulationInfo]()
    var simulationInfo = SimulationInfo()
    
    func appendSimulationInfo(simulationInfo: SimulationInfo) {
        simulationInfoArray.append(simulationInfo)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        simulationDetailGraphView.delegate = self
        simulationNameLabel.text = simulationInfo.name
        if simulationInfo.strategy == "Covered Call Writing" {
            strategyLabel.text = "CCW"
        } else {
            strategyLabel.text = simulationInfo.strategy
        }
        startBalanceLabel.text = simulationInfo.startBalance
        startDateLabel.text = simulationInfo.startDate
        endDateLabel.text = simulationInfo.endDate
        stockLabel.text = simulationInfo.stock
        riskFreeRateLabel.text = simulationInfo.riskFreeRate
        switch simulationInfo.strategy {
            case "CPPI":
                floorOrStrikeLabel.text = simulationInfo.floor
                moltiplierOrNoneLabel.text = simulationInfo.multiplier
            default:
                floorOrOptionStrike.text = "Strike"
                floorOrStrikeLabel.text = simulationInfo.strike
                multiplierOrNone.hidden = true
                moltiplierOrNoneLabel.hidden = true
        }
        drawDetailGraph()
        simulationDetailGraphView.xAxis.labelPosition = .Bottom
    }
    
    internal func drawDetailGraph() {
        var lineChartData: LineChartData!
        colorNumber = 0
        for simulationInfo in simulationInfoArray {
            var dataEntries = [ChartDataEntry]()
            for i in 0..<simulationInfo.result.count {
                let dataEntry = ChartDataEntry(value: simulationInfo.result[i], xIndex: i)
                dataEntries.append(dataEntry)
            }
            let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: simulationInfo.name)
            lineChartDataSet.circleRadius = 0.07
            lineChartDataSet.setColor(graphColorArray[colorNumber%10])
            if colorNumber == 0 {
                lineChartData = LineChartData(xVals: simulationInfo.index, dataSet: lineChartDataSet)
            } else {
                lineChartData.addDataSet(lineChartDataSet)
            }
            colorNumber += 1
        }
        simulationDetailGraphView!.data = lineChartData
        simulationDetailGraphView!.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        simulationDetailGraphView!.descriptionText = ""
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        let selectedSimulation = simulationInfoArray[highlight.dataSetIndex]
        simulationNameLabel.text = selectedSimulation.name
        if selectedSimulation.strategy == "Covered Call Writing" {
            strategyLabel.text = "CCW"
        } else {
            strategyLabel.text = selectedSimulation.strategy
        }
        startBalanceLabel.text = selectedSimulation.startBalance
        startDateLabel.text = selectedSimulation.startDate
        endDateLabel.text = selectedSimulation.endDate
        stockLabel.text = selectedSimulation.stock
        riskFreeRateLabel.text = selectedSimulation.riskFreeRate
        switch selectedSimulation.strategy {
        case "CPPI":
            floorOrStrikeLabel.text = selectedSimulation.floor
            moltiplierOrNoneLabel.text = selectedSimulation.multiplier
        default:
            floorOrOptionStrike.text = "Strike"
            floorOrStrikeLabel.text = selectedSimulation.strike
            multiplierOrNone.hidden = true
            moltiplierOrNoneLabel.hidden = true
        }
    }
    
    
    @IBAction func saveChart(sender: UIBarButtonItem) {
        let saveAlert = UIAlertController(title: "Save Image", message: "Save the image to camera roll", preferredStyle: UIAlertControllerStyle.Alert)
        
        saveAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        saveAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            self.simulationDetailGraphView.saveToCameraRoll()
        }))
        
        presentViewController(saveAlert, animated: true, completion: nil)
    }
    
}
