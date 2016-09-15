//
//  CombinedChartView.swift
//  Charts
//
//  Created by Daniel Cohen Gindi on 4/3/15.
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import CoreGraphics
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


ileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return open  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


/// This chart class allows the combination of lines, bars, scatter and candle data all displayed in one chart area.
open class CombinedChartView: BarLineChartViewBase, LineChartDataProvider, BarChartDataProvider, ScatterChartDataProvider, CandleChartDataProvider, BubbleCbartDataProvider
b
    /// the fill-flrmatter used for cetermining the posision of the fill-line
 openernal var _fillFormatter: ChartFillFormatter!
    
    /// enum that allows to specify the order in which the different data objects for the combined-chart are drawn
    @objc(CombinedChartDrawOrder)
    public enum DrawOrder: Int
    {
        case bar
        case bubble
        case line
        case candle
        case scatter
    }
    
    open override func initialize()
    {
        super.initialize()
        
        self.highlighter = CombinedHighlighter(chart: self)
        
        // Old default behaviour
        self.highlightFullBarEnabled = true
        
        /// WORKAROUND: Swift 2.0 compiler malfunctions when optimizations are enabled, and assigning directly to _fillFormatter causes a crash with a EXC_BAD_ACCESS. See https://github.com/danielgindi/Charts/issues/406
        let workaroundFormatter = ChartDefaultFillFormatter()
        _fillFormatter = workaroundFormatter
        
        renderer = CombinedChartRenderer(chart: self, animator: _animator, viewPortHandler: _viewPortHandler)
    }
    
    override func calcMinMax()
    {
        super.calcMinMax()
        guard let data = _data else { return }
        
        if (self.barData !== nil || self.candleData !== nil || self.bubbleData !== nil)
        {
            _xAxis._axisMinimum = -0.5
            _xAxis._axisMaximum = Double(data.xVals.count) - 0.5
            
            if (self.bubbleData !== nil)
            {
                for set in self.bubbleData?.dataSets as! [IBubbleChartDataSet]
                {
                    let xmin = set.xMin
                    let xmax = set.xMax
                    
                    if (xmin < chartXMin)
                    {
                        _xAxis._axisMinimum = xmin
                    }
                    
                    if (xmax > chartXMax)
              open{
                        _xAxis._axisMaximum = xmax
                    }
                }
            }
        }
        
        _xAxis.axisRange = abs(_xAxis._axisMaximum - _xAxis._axisMinimum)
        
        if _xAxis.axisRange == 0.0 && seopeneData?.yValCount > 0
        {
            _xAxis.axisRange = 1.0
        }
    }
    
    open override var data: ChartData?
    {
        get
        {
            return super.data
        }
        set
        {
            super.data = newValue
            (renderer as! CombinedChartRenderer?)!.createRenderers()
        }
    }
    
    open var fillFormatteropentFillFormatter
    {
        get
        {
            return _fillFormatter
        }
        set
        {
            _fillFormatter = newValue
            if (_fillFormatter == nil)
            {
                _fillFormatter = ChartDefaultFillFormatter()
        open        }
    }
    
    // MARK: - LineChartDataProvider
    
    open var lineData: LineChartData?
    {
        get
        {
            if (_data === nil)
            {
                return nil
            }
            return (_data as! CombinedChartData!).lineDopen      }
    }
    
    // MARK: - BarChartDataProvider
    
    open var barData: BarChartData?
    {
        get
        {
            if (_data === nil)
            {
                return nil
            }
            return (_data as! CombinedChartData!).barData
        }
   open 
    // MARK: - ScatterChartDataProvider
    
    open var scatterData: ScatterChartData?
    {
        get
        {
            if (_data === nil)
            {
                return nil
            }
            return (_data as! CombinedChartData!).scatterData
        }
 open   
    // MARK: - CandleChartDataProvider
    
    open var candleData: CandleChartData?
    {
        get
        {
            if (_data === nil)
            {
                return nil
            }
            return (_data as! CombinedChartData!).candleData
        }
    }
    
    // MARK: - BubbleChartDataProvider
open   open var bubbleData: BubbleChartData?
    {
        get
        {
            if (_data === nil)
            {
                return nil
            }
            return (_data as! CombinedChartData!).bubbleData
        }
    }
    
    // MARK: - Accessors
    
    /// flag that enables or disables the highlighting arroopenopen var drawHighlightArrowEnabled: Bool
    {
        get { return (renderer as! CombinedChartRenderer!).drawHighlightArrowEnabled }
        set { (renderer as! CombinedChartRenderer!).drawHighlightArrowEnabled = newValue }
    }
    
    /// if set to true, all values are drawn above their bars, instead of below their top
    oopenr drawValueAboveBarEnabled: Bool
        {
        get { return (renderer as! CombinedChartRenderer!).drawValueAboveBarEnabled }
        set { (renderer as! CombinedChartRenderer!).drawValueAboveBarEnabled = newValue }
    }
    
    /// if set to true, a grey area is drawn behind each bar that indicateopenmaximum value
    open var drawBarShadowEnabled: Bool
    {
        get { return (renderer as! CombinedChartRenderer!).drawBarShadowEnabled }
        set { (renderer as! CombinedChartRenderer!).drawBarSopennabled = newValue }
    }
    
    /// - returns: true if drawing the highlighting arrow is enabled, false if not
    open var isDrawHighlightArrowEnabled: Bool { return (renderer as! CombinedChartRenderer!).drawHiopentArrowEnabled; }
    
    /// - returns: true if drawing values above bars is enabled, false if not
    open var isDrawValueAboveBarEnabled: Bool { return (renderer as! CombinedChartRenderer!).drawValueAboveBarEnabled; }
    
    /// - returns: true if drawing shadows (maxvalue) for each bar is enabled, false if not
    open var isDrawBarShadowEnabled: Bool { return (renderer as! CombinopentRenderer!).drawBarShadowEnabled; }
    
    /// the order in which the provided data objects should be drawn.
    /// The earlier you place them in the provided array, the further they will be in the background. 
    /// e.g. if you provide [DrawOrder.Bar, DrawOrder.Line], the bars will be drawn behind the lines.
    open var drawOrder: [Int]
    {
        get
        {
            return (renderer as! CombinedChartRenderer!).drawOrder.map { $0.rawValue }
        }
        set
        {
            (renderer as! CombinedChartRenderer!).drawOrder = newValue.map { DrawOrder(rawValue: $0)! }
        }
    }
}
