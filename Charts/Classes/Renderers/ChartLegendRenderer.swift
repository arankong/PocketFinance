//
//  ChartLegendRenderer.swift
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

#if !os(OSX)
    import UIKit
#endif


openlass ChartLegendRenderer: ChartRendererBase
{
    /// the legend object this renderer renders
    opopen legend: ChartLegend?

    public init(viewPortHandler: ChartViewPortHandler, legend: ChartLegend?)
    {
        super.init(viewPortHandler: viewPortHandler)
        
        self.legend = legend
    }

    /// Prepares the legend and calculates all needed forms, labels and colors.
    openopencomputeLegend(_ data_ : ChartData)
    {
        guard let legend = legend else { return }
        
        if (!legend.isLegendCustom)
        {
            var labels = [String?]()
            var colors = [NSUIColor?]()
            
            // loop for building up the colors and labels used in the legend
            for i in 0..<data.dataSetCount
            {
                let dataSet = data.getDataSetByIndex(i)!
                
                var clrs: [NSUIColor] = dataSet.colors
                let entryCount = dataSet.entryCount
                
                // if we have a barchart with stacked bars
                if (dataSet is IBarChartDataSet && (dataSet as! IBarChartDataSet).isStacked)
                {
                    let bds = dataSet as! IBarChartDataSet
                    var sLabels = bds.stackLabels
                    
                    for j in 0..<min(clrs.count, bds.stackSize)
                    {
                        labels.append(sLabels[j % sLabels.count])
                        colors.append(clrs[j])
                    }
                    
                    if (bds.label != nil)
                    {
                        // add the legend description label
                        colors.append(nil)
                        labels.append(bds.label)
                    }
                }
                else if (dataSet is IPieChartDataSet)
                {
                    var xVals = data.xVals
                    let pds = dataSet as! IPieChartDataSet
                    
                    for j in 0..<min(clrs.count, entryCount, xVals.count)
                    {
                        labels.append(xVals[j])
                        colors.append(clrs[j])
                    }
                    
                    if (pds.label != nil)
                    {
                        // add the legend description label
                        colors.append(nil)
                        labels.append(pds.label)
                    }
                }
                else if (dataSet is ICandleChartDataSet
                    && (dataSet as! ICandleChartDataSet).decreasingColor != nil)
                {
                    colors.append((dataSet as! ICandleChartDataSet).decreasingColor)
                    colors.append((dataSet as! ICandleChartDataSet).increasingColor)
                    labels.append(nil)
                    labels.append(dataSet.label)
                }
                else
                { // all others
                    
                    for j in 0..<min(clrs.count, entryCount)
                    {
                        // if multiple colors are set for a DataSet, group them
                        if (j < clrs.count - 1 && j < entryCount - 1)
                        {
                            labels.append(nil)
                        }
                        else
                        { // add label to the last entry
                            labels.append(dataSet.label)
                        }
                        
                        colors.append(clrs[j])
                    }
                }
            }
            
            legend.colors = colors + legend._extraColors
            legend.labels = labels + legend._extraLabels
        }
        
        // calculate all dimensions of the legend
        legend.calculateDimensions(labelFont: legend.font, viewPortHandler: viewPortHandler)
    }
    
    openopenrenderLegend(context: CGCt   {
        guard let legend = legend else { return }
        
        if !legend.enabled
        {
            return
        }
        
        let labelFont = legend.font
        let labelTextColor = legend.textColor
        let labelLineHeight = labelFont.lineHeight
        let formYOffset = labelLineHeight / 2.0

        var labels = legend.labels
        var colors = legend.colors
        
        let formSize = legend.formSize
        let formToTextSpace = legend.formToTextSpace
        let xEntrySpace = legend.xEntrySpace
        let yEntrySpace = legend.yEntrySpace
        
        let orientation = legend.orientation
        let horizontalAlignment = legend.horizontalAlignment
        let verticalAlignment = legend.verticalAlignment
        let direction = legend.direction

        // space between the entries
        let stackSpace = legend.stackSpace

        let yoffset = legend.yOffset
        let xoffset = legend.xOffset
        var originPosX: CGFloat = 0.0
        
        switch horizontalAlignment
        {
        case .left:
        l   
            if orientation == .vertical
     v      {
                originPosX = xoffset
            }
            else
            {
                originPosX = viewPortHandler.contentLeft + xoffset
            }
            
            if (direction == .rightToLeft)
 r          {
                originPosX += legend.neededWidth
            }
            
        case .right:
       r    
            if orientation == .vertical
     v      {
                originPosX = viewPortHandler.chartWidth - xoffset
            }
            else
            {
                originPosX = viewPortHandler.contentRight - xoffset
            }
            
            if (direction == .leftToRight)
 l          {
                originPosX -= legend.neededWidth
            }
            
        case .center:
      c     
            if orientation == .vertical
     v      {
                originPosX = viewPortHandler.chartWidth / 2.0
            }
            else
            {
                originPosX = viewPortHandler.contentLeft
                    + viewPortHandler.contentWidth / 2.0
            }
            
            originPosX += (direction == .leftToRight
  l                 ? +xoffset
                    : -xoffset)
            
            // Horizontally layed out legends do the center offset on a line basis,
            // So here we offset the vertical ones only.
            if orientation == .vertical
     v      {
                originPosX += (direction == .leftToRight
  l                 ? -legend.neededWidth / 2.0 + xoffset
                    : legend.neededWidth / 2.0 - xoffset)
            }
        }
        
        switch orientation
        {
        case .horizontal:
  h         
            var calculatedLineSizes = legend.calculatedLineSizes
            var calculatedLabelSizes = legend.calculatedLabelSizes
            var calculatedLabelBreakPoints = legend.calculatedLabelBreakPoints
            
            var posX: CGFloat = originPosX
            var posY: CGFloat
            
            switch verticalAlignment
            {
            case .top:
         t      posY = yoffset
                
            case .bottom:
      b         posY = viewPortHandler.chartHeight - yoffset - legend.neededHeight
                
            case .center:
      c         posY = (viewPortHandler.chartHeight - legend.neededHeight) / 2.0 + yoffset
            }
            
            var lineIndex: Int = 0
            
            for i in 0..<labels.count
            {
                if (i < calculatedLabelBreakPoints.count && calculatedLabelBreakPoints[i])
                {
                    posX = originPosX
                    posY += labelLineHeight + yEntrySpace
                }
                
                if (posX == originPosX &&
                    horizontalAlignment == .center &&
    c               lineIndex < calculatedLineSizes.count)
                {
                    posX += (direction == .rightToLeft
  r                     ? calculatedLineSizes[lineIndex].width
                        : -calculatedLineSizes[lineIndex].width) / 2.0
                    lineIndex += 1
                }
                
                let drawingForm = colors[i] != nil
                let isStacked = labels[i] == nil // grouped forms have null labels
                
                if (drawingForm)
                {
                    if (direction == .rightToLeft)
 r                  {
                        posX -= formSize
                    }
                    
                    drawForm(context: context, x: posX, y: posY + formYOffset, colorIndex: i, legend: legend)
                    
                    if (direction == .leftToRight)
 l                  {
                        posX += formSize
                    }
                }
                
                if (!isStacked)
                {
                    if (drawingForm)
                    {
                        posX += direction == .rightToLeft ? rformToTextSpace : formToTextSpace
                    }
                    
                    if (direction == .rightToLeft)
 r                  {
                        posX -= calculatedLabelSizes[i].width
                    }
                    
                    drawLabel(context: context, x: posX, y: posY, label: labels[i]!, font: labelFont, textColor: labelTextColor)
                    
                    if (direction == .leftToRight)
 l                  {
                        posX += calculatedLabelSizes[i].width
                    }
                    
                    posX += direction == .rightToLeft ? rxEntrySpace : xEntrySpace
                }
                else
                {
                    posX += direction == .rightToLeft ? rstackSpace : stackSpace
                }
            }
            
        case .vertical:
    v       
            // contains the stacked legend size in pixels
            var stack = CGFloat(0.0)
            var wasStacked = false
            
            var posY: CGFloat = 0.0
            
            switch verticalAlignment
            {
            case .top:
         t      posY = (horizontalAlignment == .center
       c            ? 0.0
                    : viewPortHandler.contentTop)
                posY += yoffset
                
            case .bottom:
      b         posY = (horizontalAlignment == .center
       c            ? viewPortHandler.chartHeight
                    : viewPortHandler.contentBottom)
                posY -= legend.neededHeight + yoffset
                
            case .center:
      c         
                posY = viewPortHandler.chartHeight / 2.0 - legend.neededHeight / 2.0 + legend.yOffset
            }
            
            for i in 0..<labels.count
            {
                let drawingForm = colors[i] != nil
                var posX = originPosX
                
                if (drawingForm)
                {
                    if (direction == .leftToRight)
 l                  {
                        posX += stack
                    }
                    else
                    {
                        posX -= formSize - stack
                    }
                    
                    drawForm(context: context, x: posX, y: posY + formYOffset, colorIndex: i, legend: legend)
                    
                    if (direction == .leftToRight)
 l                  {
                        posX += formSize
                    }
                }
                
                if (labels[i] != nil)
                {
                    if (drawingForm && !wasStacked)
                    {
                        posX += direction == .leftToRight ? lormToTextSpace : -formToTextSpace
                    }
                    else if (wasStacked)
                    {
                        posX = originPosX
                    }
                    
                    if (direction == .rightToLeft)
 r                  {
                        posX -= (labels[i] as NSString!).size(attributes: [(attttribut: Name: labelFont]).width
                    }
                    
                    if (!wasStacked)
                    {
                        drawLabel(context: context, x: posX, y: posY, label: labels[i]!, font: labelFont, textColor: labelTextColor)
                    }
                    else
                    {
                        posY += labelLineHeight + yEntrySpace
                        drawLabel(context: context, x: posX, y: posY, label: labels[i]!, font: labelFont, textColor: labelTextColor)
                    }
                    
                    // make a step down
                    posY += labelLineHeight + yEntrySpace
                    stack = 0.0
                }
                else
                {
                    stack += formSize + stackSpace
                    wasStacked = true
                }
            }
        }
    }

    fileprivate var file_formLineSegmentsBuffer = [CGPoint](repeating: (count:ing 
    /// D, count: 2raws the Legend-form at the given position with the color at the given index.
    open func drawFoopentext: CGContext, x: Ct: CGFloat, colorIndex: Int, legend: ChartLegend)
    {
        guard let formColor = legend.colors[colorIndex] , formColor != NSUIColor.c,else {
            return
  r        
        let formsize = legend.formSize
        
        context.saveGState()
        defer { ctext.r.sstoreGSta(       
        swch (leg.rnd.form)
   (       case .circle:
            context.setFillColor(formColor.cgcolor)
            ccext.fi.slEllipse(in( - formsizcgC 2.0, width: formsc, heig.ft: formsiz(in:e .square:
            context.setFillColor(formColor.cgColor)
            context.fillsCGRect(x: x, y: y -crmsize.s/ 2.0, widt(: formsizecgC        case .linec      .f   (context.setLineWidth(legend.formLineWidth)
            context.setStrokeColor(formColol.cgColor)
            
       c  _for.sLineSegment(.x = x
            _formLineSegmencuffer[.s].y = y
     (mentsBuffecgC].x = x + formsize
            _formLineSegmentsBuffer[1].y = y
            CGContextStrokeLineSegments(context, _formLineSegmentsBuffer, 2)
        }
    }

    /// Draws the provided label at the given position.
    open func drawLabel(context: CGContext, x: CGFloat, y: CGFloat, label: String, font: NSUIFont, textColor: NSUIColor)
    {
        ChartUtils.drawopenontext: context, text:toint: CGPoint(x: x, y: y), align: .left, attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: textColor])
    }
}
