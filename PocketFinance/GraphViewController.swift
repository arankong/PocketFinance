//
//  GraphViewController.swift
//  PocketFinance
//
//  Created by Weirui Kong on 2016-07-28.
//  Copyright © 2016 uwaterloo. All rights reserved.
//

import UIKit
import Charts

class GraphViewController: UIViewController {

    @IBOutlet weak var stockPriceGraphView: LineChartView!
    @IBOutlet weak var simulationResultGraphView: LineChartView!
    
    var prices = [Double]()
    var dates = [String]()
    var results = [Double]()
    var index = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawPriceGraph()
        drawSimGraph()
        stockPriceGraphView.xAxis.labelPosition = .Bottom
        simulationResultGraphView.xAxis.labelPosition = .Bottom

        // Do any additional setup after loading the view.
    }

    internal func drawPriceGraph() {
        let months: [String]! = dates
        let price = self.prices
//        price = price.reverse()
        
        func setChart(dataPoints: [String], values: [Double]) {
            var dataEntries: [ChartDataEntry] = []
            for i in 0..<dataPoints.count {
                let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
                dataEntries.append(dataEntry)
            }
            
            let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Prices")
            lineChartDataSet.circleRadius = 0.07    //2.0
            lineChartDataSet.setColor(UIColor.blueColor().colorWithAlphaComponent(0.5))
            let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
            stockPriceGraphView!.data = lineChartData
            stockPriceGraphView!.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
            stockPriceGraphView!.descriptionText = ""
        }
        
        setChart(months, values: price)
    }
    
    internal func drawSimGraph() {
        let result = self.results
        let index = self.index
        
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
            simulationResultGraphView!.data = lineChartData
            simulationResultGraphView!.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
            simulationResultGraphView!.descriptionText = ""
        }
        
        setChart(index, values: result)
    }


}
