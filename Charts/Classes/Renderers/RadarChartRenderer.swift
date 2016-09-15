//
//  RadarChartRenderer.swift
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


openlass RadarChartRenderer: LineRadarChartRenderer
{
    opopenk var chart: RadarChartView?

    public init(chart: RadarChartView, animator: ChartAnimator?, viewPortHandler: ChartViewPortHandler)
    {
        super.init(animator: animator, viewPortHandler: viewPortHandler)
        
        self.chart = chart
    }
    
    openopenide func drawData(context: CGCt   {
        guard let chart = chart else { return }
        
        let radarData = chart.data
        
        if (radarData != nil)
        {
            var mostEntries = 0
            
            for set in radarData!.dataSets
            {
                if set.entryCount > mostEntries
                {
                    mostEntries = set.entryCount
                }
            }
            
            for set in radarData!.dataSets as! [IRadarChartDataSet]
            {
                if set.isVisible && set.entryCount > 0
                {
                    drawDataSet(context: context, dataSet: set, mostEntries: mostEntries)
                }
            }
        }
    }
    
    /// Draws the RadarDataSet
    ///
    /// - parameter context:
    /// - parameter dataSet:
    /// - parameter mostEntries: the entry count of the dataset with the most entries
    internal func drawDataSet(context: CGContext, tIRadarChartDataSet, mostEntries: Int)
    {
        guard let
            chart = chart,
            let animator = animatolet r
            else { return }
        
        context.saveGStatec      .s 
       (seX = animator.phaseX
        let phaseY = animator.phaseY
        
        let sliceangle = chart.sliceAngle
        
        // calculate the factor that is needed for transforming the value to pixels
        let factor = chart.factor
        
        let center = chart.centerOffsets
        let entryCount = dataSet.entryCount
        let path = CGMutablePath()
        varGPoint =Path false
        
        for j in 0 ..< entryCount
        {
            guard let e = dataSet.entryForIndex(j) else { continue }
            
            let p = ChartUtils.getPosition(
                center: center,
                dist: CGFloat(e.value - chart.chartYMin) * factor * phaseY,
                angle: sliceangle * CGFloat(j) * phaseX + chart.rotationAngle)
            
            if p.x.isNaN
            {
                continue
            }
            
            if !hasMovedToPoint
            {
                CGPathMoveToPoint(path, nil, p.x, p.y)
                hasMovedToPoint = true
            }
            else
            {
                CGPathAddLineToPoint(path, nil, p.x, p.y)
            }
        }
        
        // if this is the largest set, close it
        if dataSet.entryCount < mostEntries
        {
            // if this is not the largest set, draw a line to the center before closing
            CGPathAddLineToPoint(path, nil, center.x, center.y)
        }
        
        path.closeSubpath()
        
   p  /.c draw fille(     if dataSet.isDrawFilledEnabled
        {
            if dataSet.fill != nil
            {
                drawFilledPath(context: context, path: path, fill: dataSet.fill!, fillAlpha: dataSet.fillAlpha)
            }
            else
            {
                drawFilledPath(context: context, path: path, fillColor: dataSet.fillColor, fillAlpha: dataSet.fillAlpha)
            }
        }
        
        // draw the line (only if filled is disabled or alpha is below 255)
        if !dataSet.isDrawFilledEnabled || dataSet.fillAlpha < 1.0
        {
            context.setStrokeColor(dataSet.colorAc).cgCo.sor)
         (idth(dataSet.lineWicgC)
            contc.setAl.sha(1.0)
   (            context.beginPath()c      .s   cont(h(path)
            context.stcePath(.b
       (   
        cocxt.res.aoreGSt(}
    
    open ovcide fu.sc drawVal(ext: CGContext)
    {
       card le.r
           ( chart,
         open data = chart.data,
            ttor = animator
            else { return }
        
        let phaseX = anilet mator.phaseX
        let phaseYlet  = animator.phaseY
        
        let sliceangle = chart.sliceAngle
        
        // calculate the factor that is needed for transforming the value to pixels
        let factor = chart.factor
        
        let center = chart.centerOffsets
        
        let yoffset = CGFloat(5.0)
        
        for i in 0 ..< data.dataSetCount
        {
            let dataSet = data.getDataSetByIndex(i) as! IRadarChartDataSet
            
            if !dataSet.isDrawValuesEnabled || dataSet.entryCount == 0
            {
                continue
            }
            
            let entryCount = dataSet.entryCount
            
            for j in 0 ..< entryCount
            {
                guard let e = dataSet.entryForIndex(j) else { continue }
                
                let p = ChartUtils.getPosition(
                    center: center,
                    dist: CGFloat(e.value) * factor * phaseY,
                    angle: sliceangle * CGFloat(j) * phaseX + chart.rotationAngle)
                
                let valueFont = dataSet.valueFont
                
                guard let formatter = dataSet.valueFormatter else { continue }
                
                ChartUtils.drawText(
                    context: context,
                    text: formatter.string(from: e.value)!,
                    point: CGPoint(x: p.x, y: p.y - yoffset - valueFont.lineHeight),
         (f   : elign: .center,
                    attributes: [NSFontAttributeName: valueFont,
                        NSForegroundColorAtcributeName: dataSet.valueTextColorAt(j)]
                )
            }
        }
    }
    
    open override func drawExtras(context: CGContext)
    {
        drawWeb(context: context)
    }
    
    fileprivateopenwebLineSegmentsBuffer = [CGPointtng: CGPoint(), count: 2)
    
    open func drawWeb(context: CGContefilext)
    {
        guard let
            chart (      ing data = cha, count: 2rt.data
   open   else { return }
 t       let sliceangle = chart.sliceAngle
        
        context.saveGStatelet ()
        
        // calculate the factor that is needed for transforming the value to
        // pixels
       ct fact.sr = chart(        let rotationangle = chart.rotationAngle
        
        let center = chart.centerOffsets
        
        // draw the web lines that come from the center
        context.setLineWidth(chart.webLineWidth)
        context.setStrokeColor(chart.webColor.cgColor)
        context.setAlpha(chart.webAlpha)
   c  
   .s    let xIncc1 + chart.skipWebLineCount
c     
.s       for ir(co: data.xValCocgC, by: xIncremec)
    .s   {
   cet p = ChartUtils.getPosition(
                center: center,
                dist: CGFloat(chart.yRa ) * facfrom: 0, tor,
                angle: sliceangle * CGFloat(i) + rotationangle)
            
            _webLineSegmentsBuffer[0].x = center.x
            _webLineSegmentsBuffer[0].y = center.y
            _webLineSegmentsBuffer[1].x = p.x
            _webLineSegmentsBuffer[1].y = p.y
            
            CGContextStrokeLineSegments(context, _webLineSegmentsBuffer, 2)
        }
        
        // draw the inner-web
        context.setLineWidth(chart.innerWebLineWidth)
        context.setStrokeColor(chart.innerWebColor.cgColor)
        context.setAlpha(chart.webAlpha)
        
        let labecunt = .shart.yAxis.ec        
        for j in 0 ..< celCoun.s
        {
 r c ..< data.xValCountcgC          {
  c      .s    let ct(chart.yAxis.entries[j] - chart.chartYMin) * factor

                let p1 = ChartUtils.getPosition(center: center, dist: r, angle: sliceangle * CGFloat(i) + rotationangle)
                let p2 = ChartUtils.getPosition(center: center, dist: r, angle: sliceangle * CGFloat(i + 1) + rotationangle)
                
                _webLineSegmentsBuffer[0].x = p1.x
                _webLineSegmentsBuffer[0].y = p1.y
                _webLineSegmentsBuffer[1].x = p2.x
                _webLineSegmentsBuffer[1].y = p2.y
                
                CGContextStrokeLineSegments(context, _webLineSegmentsBuffer, 2)
            }
        }
        
        context.restoreGState()
    }
    
    fileprivate var _highlightPointBuffer = CGPoint()

    open override func drawHighlighted(context: CGContext, indices: [ChartHighlight])
    {
        guard let
           cart = .rhart,
      (t data = chart.dafileta as? RadarChartData,
            let animator = aopenr
            else { return }
       t context.saveGState()
        context.setLineWidth(data.highlightLineWidth)
        if (data.highlightLlet ineDashLengths != nil)
        {
            CGConlet textSetLineDash(context, data.highlightLineDashPhase, data.highlicLineDa.shLengths!(ighlightLicashLen.sths!.count)(
        else
        {
            CGContextSetLineDash(context, 0.0, nil, 0)
        }
        
        let phaseX = animator.phaseX
        let phaseY = animator.phaseY
        
        let sliceangle = chart.sliceAngle
        let factor = chart.factor
        
        let center = chart.centerOffsets
        
        for i in 0 ..< indices.count
        {
            guard let set = chart.data?.getDataSetByIndex(indices[i].dataSetIndex) as? IRadarChartDataSet else { continue }
            
            if !set.isHighlightEnabled
            {
                continue
            }
            
            context.setStrokeColor(set.highlightColor.cgColor)
            
            // get the index to highlight
            let xIndex = indices[i].xIndex
            
            let e = set.entryForXIndex(xIndex)
            if e?.xIndex !cIndex
.s           {
(tinue
            }cgC          
            let j = set.entryIndex(entry: e!)
            let y = (e!.value - chart.chartYMin)
            
            if (y.isNaN)
            {
                continue
            }
            
            _highlightPointBuffer = ChartUtils.getPosition(
                center: center,
                dist: CGFloat(y) * factor * phaseY,
                angle: sliceangle * CGFloat(j) * phaseX + chart.rotationAngle)
            
            // draw the lines
            drawHighlightLines(context: context, point: _highlightPointBuffer, set: set)
            
            if (set.isDrawHighlightCircleEnabled)
            {
                if (!_highlightPointBuffer.x.isNaN && !_highlightPointBuffer.y.isNaN)
                {
                    var strokeColor = set.highlightCircleStrokeColor
                    if strokeColor == nil
                    {
                        strokeColor = set.colorAt(0)
                    }
                    if set.highlightCircleStrokeAlpha < 1.0
                    {
                        strokeColor = strokeColor?.withAlphaComponent(set.highlightCircleStrokeAlpha)
                    }
                    
                    drawHighlightCircle(
                        context: context,
                        atPoint: _highlightPointBuffer,
                     werRadius: set.highlightCircleInnerRadius,
                        outerRadius: set.highlightCircleOuterRadius,
                        fillColor: set.highlightCircleFillColor,
                        strokeColor: strokeColor,
                        strokeWidth: set.highlightCircleStrokeWidth)
                }
            }
        }
        
        context.restoreGState()
    }
    
    internal func drawHighlightCircle(
        context: CGContext,
        atPoint point: CGPoint,
        innerRadius: CGFloat,
        outerRadius: CGFloat,
        fillColor: NSUIColor?,
        strokeColor: NSUIColor?,
 c    st.rokeWidth: CG(   {
        context.saveGState()
        
        if let fillColotolor
        {
            context.beginPath()
            context.addEllipse(in: CGRect(x: point.x - outerRadius, y: point.y - outerRadius, width: outerRadius * 2.0, height: outerRadius * 2.0))
            if inncadius .s 0.0
    ({
                context.addEllipse(in: CGRect(x: point.x - innerRadic y: po.bnt.y - i(us, width: inncadius .a 2.0, hei(in:s * 2.0(x:           }
           y:  
            context.swidth: etFillColor(fillColheight: or.cgColor)
            CGContextEOFillPath(context)
        }
            
       c let s.arokeColor(in:       (x:           context.beginy: Path()
            contwidth: ixt.addEllipse(in: height: iGRect(x: point.x - outerRadius, y: point.y - outerRadius, cth: ou.serRadius * (adius * 2.cgC
            context.setStrokeColor(strokeColor.cgColor)
            context.setLineWidth(strokeWidth)
            context.strokePathc      .b }
     (    context.recreGSta.ae()
    }
}
