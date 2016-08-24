//
//  SimulationDetailViewController.swift
//  PocketFinance
//
//  Created by Weirui Kong on 2016-08-23.
//  Copyright © 2016 uwaterloo. All rights reserved.
//

import UIKit
import Charts
class SimulationDetailViewController: UIViewController {
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
    
    
    var simulationInfo = (name: "", strategy: "", startBalance: "", startDate: "", endDate: "", stock: "", riskFreeRate: "", floor: "", multiplier: "", strike: "")
    var results = [Double]()
    var index = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let result = self.results
        let index = self.index
        if result.count != 0 {
            func setChart(dataPoints: [String], values: [Double]) {
                var dataEntries: [ChartDataEntry] = []
                for i in 0..<dataPoints.count {
                    let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
                    dataEntries.append(dataEntry)
                }
                
                let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Balance")
                lineChartDataSet.circleRadius = 0.07    //2.0
                lineChartDataSet.setColor(UIColor.blueColor().colorWithAlphaComponent(0.5))
                let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
                simulationDetailGraphView!.data = lineChartData
                simulationDetailGraphView!.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
                simulationDetailGraphView!.descriptionText = ""
            }
            
            setChart(index, values: result)
        }
        
    }
}
