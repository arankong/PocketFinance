//
//  GraphViewController.swift
//  PocketFinance
//
//  Created by Weirui Kong on 2016-07-28.
//  Copyright © 2016 uwaterloo. All rights reserved.
//

import UIKit
import Charts

class GraphViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var stockPriceGraphView: LineChartView!
    @IBOutlet weak var simulationResultGraphView: LineChartView!
    
    var prices = [Double]()
    var dates = [String]()
    var results = [Double]()
    var index = [String]()
    var simulationInfo = (name: "", strategy: "", startBalance: "", startDate: "", endDate: "", stock: "", riskFreeRate: "", floor: "", multiplier: "", strike: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawPriceGraph()
        drawSimGraph()
        stockPriceGraphView.delegate = self
        simulationResultGraphView.delegate = self
        stockPriceGraphView.xAxis.labelPosition = .Bottom
        simulationResultGraphView.xAxis.labelPosition = .Bottom
        stockPriceGraphView.noDataText = "No stock graph available"
        simulationResultGraphView.noDataText = "No simulation result available"
        // Do any additional setup after loading the view.
    }

    internal func drawPriceGraph() {
        let months: [String]! = dates
        let price = self.prices
        
        var dataEntries = [ChartDataEntry]()
        for i in 0..<months.count {
            let dataEntry = ChartDataEntry(value: price[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
            
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Prices")
            
        lineChartDataSet.circleRadius = 0.07    //2.0
        lineChartDataSet.setColor(UIColor.blueColor().colorWithAlphaComponent(0.5))
        let lineChartData = LineChartData(xVals: months, dataSet: lineChartDataSet)
        stockPriceGraphView!.data = lineChartData
        stockPriceGraphView!.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        stockPriceGraphView!.descriptionText = ""
        
    }
    
    internal func drawSimGraph() {
        let result = self.results
        let index = self.index
        if result.count != 0 {
        var dataEntries = [ChartDataEntry]()
        for i in 0..<result.count {
            let dataEntry = ChartDataEntry(value: result[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Balance")
        lineChartDataSet.circleRadius = 0.07    //2.0
        lineChartDataSet.setColor(UIColor.blueColor().colorWithAlphaComponent(0.5))
        let lineChartData = LineChartData(xVals: index, dataSet: lineChartDataSet)
        simulationResultGraphView!.data = lineChartData
        simulationResultGraphView!.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        simulationResultGraphView!.descriptionText = ""
            
        }
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        print("\(entry.value) in \(dates[entry.xIndex])")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let sdvc = segue.destinationViewController as? SimulationDetailViewController {
            if let identifer = segue.identifier {
                switch identifer {
                case "Show Detail":
                    sdvc.simulationInfo.name = simulationInfo.name
                    sdvc.simulationInfo.strategy = simulationInfo.strategy
                    sdvc.simulationInfo.startBalance = simulationInfo.startBalance
                    sdvc.simulationInfo.startDate = simulationInfo.startDate
                    sdvc.simulationInfo.endDate = simulationInfo.endDate
                    sdvc.simulationInfo.stock = simulationInfo.stock
                    sdvc.simulationInfo.riskFreeRate = simulationInfo.riskFreeRate
                    sdvc.simulationInfo.floor = simulationInfo.floor
                    sdvc.simulationInfo.multiplier = simulationInfo.multiplier
                    sdvc.simulationInfo.strike = simulationInfo.strike
                    sdvc.simulationInfo.result = results
                    sdvc.simulationInfo.index = index
                    sdvc.appendSimulationInfo(sdvc.simulationInfo)
                default: break
                }
            }
        }
    }

}
