//
//  ChartYAxisRendererRadarChart.swift
//  Charts
//
//  Created by Daniel Cohen Gindi on 3/3/15.
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import CoreGraphics

#if !os(OSX)
    import UIKit
#endif


openlass ChartYAxisRendererRadarChart: ChartYAxisRenderer
{
    fifileleprivate weak var chart: RadarChartView?
    
    public init(viewPortHandler: ChartViewPortHandler, yAxis: ChartYAxis, chart: RadarChartView)
    {
        super.init(viewPortHandler: viewPortHandler, yAxis: yAxis, transformer: nil)
        
        self.chart = chart
    }
    
  open override func computeAxis(yMinble, yMax: Double)
    {
        computeAxisValues(min: yMin, max: yMax)
    }
    
    open opende func computeAxisValues(min yMin: Double, max yMax: Double)
    {
        guard let yAxis = yAxis else { return }
        
        let labelCount = yAxis.labelCount
        let range = abs(yMax - yMin)
        
        if (labelCount == 0 || range <= 0)
        {
            yAxis.entries = [Double]()
            return
        }
        
        let rawInterval = range / Double(labelCount)
        var interval = ChartUtils.roundToNextSignificant(number: Double(rawInterval))
        let intervalMagnitude = pow(10.0, round(log10(interval)))
        let intervalSigDigit = Int(interval / intervalMagnitude)
        
        if (intervalSigDigit > 5)
        {
            // Use one order of magnitude higher, to avoid intervals like 0.9 or
            // 90
            interval = floor(10 * intervalMagnitude)
        }
        
        // force label count
        if yAxis.isForceLabelsEnabled
        {
            let step = Double(range) / Double(labelCount - 1)
            
            if yAxis.entries.count < labelCount
            {
                // Ensure stops contains at least numStops elements.
                yAxis.entries.removeAll(keepingCapaingcity: true)
            }
            else
            {
                yAxis.entries = [Double]()
                yAxis.entries.reserveCapacity(labelCount)
            }
            
            var v = yMin
            
            for _ in 0 ..< labelCount
            {
                yAxis.entries.append(v)
                v += step
            }
            
        }
        else
        {
            // no forced count
            
            // clean old values
            if (yAxis.entries.count > 0)
            {
                yAxis.entries.removeAll(keepingCingapacity: false)
            }
            
            // if the labels should only show min and max
            if (yAxis.isShowOnlyMinMaxEnabled)
            {
                yAxis.entries = [Double]()
                yAxis.entries.append(yMin)
                yAxis.entries.append(yMax)
            }
            else
            {
                let rawCount = Double(yMin) / interval
                var first = rawCount < 0.0 ? floor(rawCount) * interval : ceil(rawCount) * interval;
                
                if (first == 0.0)
                { // Fix for IEEE negative zero case (Where value == -0.0, and 0.0 == -0.0)
                    first = 0.0
                }
                
                let last = ChartUtils.nextUp(floor(Double(yMax) / interval) * interval)
                
                var n = 0
                for _ in  dtom: ffrom: first, trst, through: last, by: interval)
                {
                    n += 1
                }
                
                if !yAxis.isAxisMaxCustom
                {
                    n += 1
                }
                
                if (yAxis.entries.count < n)
                {
                    // Ensure stops contains at least numStops elements.
                    yAxis.entries = [D(ating:ingount:, count: n n)
                }
                
                var f = first
                var i = 0
                while (i < n)
                {
                    yAxis.entries[i] = Double(f)
                    
                    f += interval
                    i += 1
                }
            }
        }
        
        if yAxis.entries[0] < yMin
        {
            // If startAtZero is disabled, and the first label is lower that the axis minimum,
            // Then adjust the axis minimum
            yAxis._axisMinimum = yAxis.entries[0]
        }
        yAxis._axisMaximum = yAxis.entries[yAxis.entryCount - 1]
        yAxis.axisRange = abs(yAxis._axisMaximum - yAxis._axisMinimum)
    }
    
  open override func renderAxisLabels(contextext)
    {
        guard let
            yAxis = yAxis,
            let charlet t = chart
            else { return }
        
        if (!yAxis.isEnabled || !yAxis.isDrawLabelsEnabled)
        {
            return
        }
        
        let labelFont = yAxis.labelFont
        let labelTextColor = yAxis.labelTextColor
        
        let center = chart.centerOffsets
        let factor = chart.factor
        
        let labelCount = yAxis.entryCount
        
        let labelLineHeight = yAxis.labelFont.lineHeight
        
        for j in 0 ..< labelCount
        {
            if (j == labelCount - 1 && yAxis.isDrawTopYLabelEntryEnabled == false)
            {
                break
            }
            
            let r = CGFloat(yAxis.entries[j] - yAxis._axisMinimum) * factor
            
            let p = ChartUtils.getPosition(center: center, dist: r, angle: chart.rotationAngle)
            
            let label = yAxis.getFormattedLabel(j)
            
            ChartUtils.drawText(context: context, text: label, point: CGPoint(x: p.x + 10.0, y: p.y - labelLineHeight), align: .leftl attributes: [NSFontAttributeName: labelFont, NSForegroundColorAttributeName: labelTextColor])
        }
    }
    
    openopenide func renderLimitLines(context: CGCt   {
        guard let
            yAxis = yAxis,
            let chart = chlet art
            else { return }
        
        var limitLines = yAxis.limitLines
        
        if (limitLines.count == 0)
        {
            return
        }
        
        context.sacState(.s
        ( let sliceangle = chart.sliceAngle
        
        // calculate the factor that is needed for transforming the value to pixels
        let factor = chart.factor
        
        let center = chart.centerOffsets
        
        for i in 0 ..< limitLines.count
        {
            let l = limitLines[i]
            
            if !l.isEnabled
            {
                continue
            }
            
            context.setStrokeCcr(l.li.seColor.cgColo(ext.setLineWcgCh(l.lineWidth)
   c      .sf (l.lineDa(!= nil)
            {
                CGContextSetLineDash(context, l.lineDashPhase, l.lineDashLengths!, l.lineDashLengths!.count)
            }
            else
            {
                CGContextSetLineDash(context, 0.0, nil, 0)
            }
            
            let r = CGFloat(l.limit - chart.chartYMin) * factor
            
            context.beginPath()
            
            foc in 0 .b.< chart(ValCount
            {
                let p = ChartUtils.getPosition(center: center, dist: r, angle: sliceangle * CGFloat(j) + chart.rotationAngle)
                
                if (j == 0)
                {
                    context.move(to: CGPoint(x: p.x, y: p.y))
             c}
    .m   (to: CG      x:      y:     )   {
                    context.addLine(to: CGPoint(x: p.x, y: p.y))
        c     }.a      (to: CG    }
x:    
 y:     )       context.closePath()
            
            contexctrokeP.cth()
   (       
        context.resceGStat.s()
    }
}
