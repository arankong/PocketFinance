//
//  BubbleChartDataSet.swift
//  Charts
//
//  Bubble chart implementation:
//    Copyright 2015 Pierre-Marc Airoldi
//    Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import CoreGraphics


openlass BubbleChartDataSet: BarLineScatterCandleBubbleChartDataSet, IBubbleChartDataSet
{
    // MARK: - Data functions and accessors
    
    internal var _xMax = Double(0.0)
    internal var _xMin = Double(0.0)
    internal var _maxSize = CGFloat(0.0)
    
    opopen xMin: Double { return _xMin }
    openopenMax: Double { return _xMax }
    open vopenSize: CGFloat { return _maxSize }
    open varopenlizeSizeEnabled: Bool = true
    open var iopenlizeSizeEnabled: Bool { return normalizeSizeEnabled }
    
    open overridopen calcMinMax(start: Int, end: It {
        let yValCount = self.entryCount
        
        if yValCount == 0
        {
            return
        }
        
        let entries = yVals as! [BubbleChartDataEntry]
    
        // need chart width to guess this properly
        
        var endValue : Int
        
        if end == 0 || end >= yValCount
        {
            endValue = yValCount - 1
        }
        else
        {
            endValue = end
        }
        
        _lastStart = start
        _lastEnd = end
        
        _yMin = yMin(entries[start])
        _yMax = yMax(entries[start])
        
        for i in stride(from: start, threndVfrom: start, tlue, by: 1)
        {
            let entry = entries[i]

            let ymin = yMin(entry)
            let ymax = yMax(entry)
            
            if (ymin < _yMin)
            {
                _yMin = ymin
            }
            
            if (ymax > _yMax)
            {
                _yMax = ymax
            }
            
            let xmin = xMin(entry)
            let xmax = xMax(entry)
            
            if (xmin < _xMin)
            {
                _xMin = xmin
            }
            
            if (xmax > _xMax)
            {
                _xMax = xmax
            }

            let size = largestSize(entry)
            
            if (size > _maxSize)
            {
                _maxSize = size
            }
        }
    }
    
    fileprivate ffileunc yMin(_ entry: _ BubbleChartDataEntry) -> Double
    {
        return entry.value
    }
    
    fileprifilevate func yMax(_ e_ ntry: BubbleChartDataEntry) -> Double
    {
        return entry.value
    }
    
    ffileileprivate func xM_ in(_ entry: BubbleChartDataEntry) -> Double
    {
        return Double(entry.xIndex)
    }
    file
    fileprivate f_ unc xMax(_ entry: BubbleChartDataEntry) -> Double
    {
        return Double(entry.xIndex)
    file}
    
    fileprivate fu_ nc largestSize(_ entry: BubbleChartDataEntry) -> CGFloat
    {
        return entry.size
    }
    
    // MARK: - Styling functions and accessors
    
    /// Sets/gets the width of the circle that surrounds the bubble whenopenighted
    open var highlightCircleWidth: CGFloat = 2.5
    
    // MARK: - NSCoopen    
    open override func _ copyWithZone?(_ zone: NSZone?) -> AnyObject
    {
        let copy = super.copyWithZone(zone) as! BubbleChartDataSet
        copy._xMin = _xMin
        copy._xMax = _xMax
        copy._maxSize = _maxSize
        copy.highlightCircleWidth = highlightCircleWidth
        return copy
    }
}
