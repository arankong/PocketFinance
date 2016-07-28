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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawGraph()
        stockPriceGraphView.xAxis.labelPosition = .Bottom
        // Do any additional setup after loading the view.
    }

    internal func drawGraph() {
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
            stockPriceGraphView!.descriptionText = "365 Days"
        }
        
        setChart(months, values: price)
    }

}
