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
    
    var simulationName = ""
//    {
//        didSet {
//            simulationNameLabel?.text = simulationName
//        }
//    }
    var strategy = ""
//    {
//        didSet {
//            strategyLabel?.text = strategy
//        }
//    }
    var startBalance = ""
//    {
//        didSet {
//            startBalanceLabel?.text = startBalance
//        }
//    }
    var startDate = ""
//    {
//        didSet {
//            startDateLabel?.text = startDate
//        }
//    }
    var endDate = ""
//    {
//        didSet {
//            endDateLabel?.text = endDate
//        }
//    }
    var stock = ""
//    {
//        didSet {
//            stockLabel?.text = stock
//        }
//    }
    var riskFreeRate = ""
//    {
//        didSet {
//            riskFreeRateLabel?.text = riskFreeRate
//        }
//    }
    
    var results = [Double]()
    var index = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        simulationNameLabel.text = simulationName
        strategyLabel.text = strategy
        startBalanceLabel.text = startBalance
        startDateLabel.text = startDate
        endDateLabel.text = endDate
        stockLabel.text = stock
        riskFreeRateLabel.text = riskFreeRate
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
