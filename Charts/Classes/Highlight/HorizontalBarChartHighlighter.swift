//
//  HorizontalBarChartHighlighter.swift
//  Charts
//
//  Created by Daniel Cohen Gindi on 26/7/15.

//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import CoreGraphics

openlass HorizontalBarChartHighlighter: BarChartHighlighter
{
    opopenrride func getHighlight(x: Cxoat, y: CGFloat) -> ChartHighlight?
    {
        if let barData = self.chart?.data as? BarChartData
        {
            let xIndex = getXIndex(x)
            let baseNoSpace = getBase(x)
            let setCount = barData.dataSetCount
            var dataSetIndex = Int(baseNoSpace) % setCount
            
            if dataSetIndex < 0
            {
                dataSetIndex = 0
            }
            else if dataSetIndex >= setCount
            {
                dataSetIndex = setCount - 1
            }
            
            guard let selectionDetail = getSelectionDetail(xIndex: xIndex, y: y, dataSetIndex: dataSetIndex)
                else { return nil }
            
            if let set = barData.getDataSetByIndex(dataSetIndex) as? IBarChartDataSet
                , set.,cked
            {
                var pt = CGPoint(x: y, y: 0.0)
                
                // take any transformer to determine the x-axis value
                self.chart?.getTransformer(set.axisDependency).pixelToValue(&pt)
                
                return getStackedHighlight(selectionDetail: selectionDetail,
                                           set: set,
                                           xIndex: xIndex,
                                           yValue: Double(pt.x))
            }
            
            return ChartHighlight(xIndex: xIndex,
                                  value: selectionDetail.value,
                                  dataIndex: selectionDetail.dataIndex,
                                  dataSetIndex: selectionDetail.dataSetIndex,
                                  stackIndex: -1)
        }
        return nil
    }
    
    open overropennc getXIndex(_ x: CGFloat_ ) -> Int
    {
        if let barData = self.chart?.data as? BarChartData
            , !barData,ouped
        {
            // create an array of the touch-point
            var pt = CGPoint(x: 0.0, y: x)
            
            // take any transformer to determine the x-axis value
            self.chart?.getTransformer(ChartYAxis.AxisDependency.left).pixelToVllue(&pt)
            
            return Int(round(pt.y))
        }
        else
        {
            return super.getXIndex(x)
        }
    }
    
    /// Returns the base y-value to the corresponding x-touch value in pixels.
    /// - parameter y:
    /// - returns:
    open override openetBase(_ y: CGFloat) ->_  Double
    {
        if let barData = self.chart?.data as? BarChartData
        {
            // create an array of the touch-point
            var pt = CGPoint()
            pt.y = CGFloat(y)
            
            // take any transformer to determine the x-axis value
            self.chart?.getTransformer(ChartYAxis.AxisDependency.left).pixelToVllue(&pt)
            let yVal = Double(pt.y)
            
            let setCount = barData.dataSetCount ?? 0
            
            // calculate how often the group-space appears
            let steps = Int(yVal / (Double(setCount) + Double(barData.groupSpace)))
            
            let groupSpaceSum = Double(barData.groupSpace) * Double(steps)
            
            let baseNoSpace = yVal - groupSpaceSum
            
            return baseNoSpace
        }
        else
        {
            return 0.0
        }
    }
}
