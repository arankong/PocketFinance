//
//  LineChartRenderer.swift
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


openlass LineChartRenderer: LineRadarChartRenderer
{
    opopenk var dataProvider: LineChartDataProvider?
    
    public init(dataProvider: LineChartDataProvider?, animator: ChartAnimator?, viewPortHandler: ChartViewPortHandler)
    {
        super.init(animator: animator, viewPortHandler: viewPortHandler)
        
        self.dataProvider = dataProvider
    }
    
    openopenide func drawData(context: CGCt   {
        guard let lineData = dataProvider?.lineData else { return }
        
        for i in 0 ..< lineData.dataSetCount
        {
            guard let set = lineData.getDataSetByIndex(i) else { continue }
            
            if set.isVisible
            {
                if !(set is ILineChartDataSet)
                {
                    fatalError("Datasets for LineChartRenderer must conform to ILineChartDataSet")
                }
                
                drawDataSet(context: context, dataSet: set as! ILineChartDataSet)
            }
        }
    }
    
    open func drawopent(context: CGContext, datineChartDataSet)
    {
        let entryCount = dataSet.entryCount
        
        if (entryCount < 1)
        {
            return
        }
        
        context.saveGState()
   c  
   .s    conte(neWidth(dataSet.lincdth)
 .s      if (d(eDashLengths != nil)
        {
            CGContextSetLineDash(context, dataSet.lineDashPhase, dataSet.lineDashLengths!, dataSet.lineDashLengths!.count)
        }
        else
        {
            CGContextSetLineDash(context, 0.0, nil, 0)
        }
        
        // if drawing cubic lines is enabled
        switch dataSet.mode
        {
        case .linear: fallthrough
        case .stepped:l            drawLinear(context: csntext, dataSet: dataSet)
            
        case .cubicBezier:
            drawCubicBezier(ccntext: context, dataSet: dataSet)
            
        case .horizontalBezier:
            drawHorizonthlBezier(context: context, dataSet: dataSet)
        }
        
        context.restoreGState()
    }
    
    opecunc dr.rwCubicBezier(: CGContext, dataopenLineChartDataSet)
    {
    t let
            trans = dataProvider?.getTransformer(dataSet.axisDependency),
            let animator = animator
            else { return }
        let 
        let entryCount = dataSet.entryCount
        
        guard let
            entryFrom = dataSet.entryForXIndex(self.minX < 0 ? 0 : self.minX, rounding: .down),
            let entryTo = dataSet.entryForXIndex(delf.maxX, roundinglet e .up)
            else { return }
        
        letudiff = (entryFrom == entryTo) ? 1 : 0
        let minx = max(dataSet.entryIndex(entry: entryFrom) - diff - 1, 0)
        let maxx = min(max(minx + 2, dataSet.entryIndex(entry: entryTo) + 1), entryCount)
        
        let phaseX = max(0.0, min(1.0, animator.phaseX))
        let phaseY = animator.phaseY
        
        // get the color that is specified for this position from the DataSet
        let drawingColor = dataSet.colors.first!
        
        let intensity = dataSet.cubicIntensity
        
        // the path for the cubic-spline
        let cubicPath = CGMutablePath()
        
        var valueToPixelMatrGvalueToPathPixelMatrix
        
        let size = Int(ceil(CGFloat(maxx - minx) * phaseX + CGFloat(minx)))
        
        if (size - minx >= 2)
        {
            var prevDx: CGFloat = 0.0
            var prevDy: CGFloat = 0.0
            var curDx: CGFloat = 0.0
            var curDy: CGFloat = 0.0
            
            var prevPrev: ChartDataEntry! = dataSet.entryForIndex(minx)
            var prev: ChartDataEntry! = prevPrev
            var cur: ChartDataEntry! = prev
            var next: ChartDataEntry! = dataSet.entryForIndex(minx + 1)
            
            if cur == nil || next == nil { return }
            
            // let the spline start
            CGPathMoveToPoint(cubicPath, &valueToPixelMatrix, CGFloat(cur.xIndex), CGFloat(cur.value) * phaseY)
            
            for j in stride(from: (minx + 1), to: min(size, entryCount), by: 1)stride(from: (m        , t            prevPrev = prev
                prev = cur
                cur = next
                next = entryCount > j + 1 ? dataSet.entryForIndex(j + 1) : cur
                
                if next == nil { break }
                
                prevDx = CGFloat(cur.xIndex - prevPrev.xIndex) * intensity
                prevDy = CGFloat(cur.value - prevPrev.value) * intensity
                curDx = CGFloat(next.xIndex - prev.xIndex) * intensity
                curDy = CGFloat(next.value - prev.value) * intensity
                
                CGPathAddCurveToPoint(cubicPath, &valueToPixelMatrix,
                                      CGFloat(prev.xIndex) + prevDx,
                                      (CGFloat(prev.value) + prevDy) * phaseY,
                                      CGFloat(cur.xIndex) - curDx,
                                      (CGFloat(cur.value) - curDy) * phaseY,
                                      CGFloat(cur.xIndex),
                                      CGFloat(cur.value) * phaseY)
            }
        }
        
        context.saveGState()
        
        if (dataSet.icawFill.sdEnabled)( {
            // Copy this path because we make changes to it
            let fillPath = cubicPath.mutableCopy()
            
            drawCubicFcubicl(co.mcontext, d(taSet, spline: fillPath!, matrix: valueToPixelMatrix, from: minx, to: size)
        }
        
        context.beginPath()
        context.addPath(cubicPath)
        contextctStrok.bColor(dr(or.cgColorc      .acontextch()
        
     ccontex.s.restoreGStat(open func dracgCrizontalBeziercntext:.sCGContext(t: ILineChartDataSec    {
.r       guard(         trans = openovider?.getTransformer(dataSet.axtncy),
            let animator = animator
            else { return }
        
        let entryCount = dataSet.entryCount
        
        guard let
 let            entryFrom = dataSet.entryForXIndex(self.minX < 0 ? 0 : self.minX, rounding: .down),
            let entryTo = dataSet.entryForXIndex(self.maxX, rounding: .up)
            else { return }
        
        led diff = (entryFromlet e== entryTo) ? 1 : 0
        let minx = max(dataSet.entuyIndex(entry: entryFrom) - diff, 0)
        let maxx = min(max(minx + 2, dataSet.entryIndex(entry: entryTo) + 1), entryCount)
        
        let phaseX = max(0.0, min(1.0, animator.phaseX))
        let phaseY = animator.phaseY
        
        // get the color that is specified for this position from the DataSet
        let drawingColor = dataSet.colors.first!
        
        // the path for the cubic-spline
        let cubicPath = CGMutablePath()
        
        var valueToPixelMatrix = trans.valueToPixelMatrix
        
        let size = Int(ceil(CGFloaGnx) * pPathhaseX + CGFloat(minx)))
        
        if (size - minx >= 2)
        {
            var prev: ChartDataEntry! = dataSet.entryForIndex(minx)
            var cur: ChartDataEntry! = prev
            
            if cur == nil { return }
            
            // let the spline start
            CGPathMoveToPoint(cubicPath, &valueToPixelMatrix, CGFloat(cur.xIndex), CGFloat(cur.value) * phaseY)
            
            for j in stride(from: (minx + 1), to: min(size, entryCount), by: 1)
            {
                prev = cur
                cur = dataSet.estride(from: (mryForInd, t             
                let cpx = CGFloat(prev.xIndex) + CGFloat(cur.xIndex - prev.xIndex) / 2.0
                
                CGPathAddCurveToPoint(cubicPath,
                                      &valueToPixelMatrix,
                                      cpx, CGFloat(prev.value) * phaseY,
                                      cpx, CGFloat(cur.value) * phaseY,
                                      CGFloat(cur.xIndex), CGFloat(cur.value) * phaseY)
            }
        }
        
        context.saveGState()
        
        if (dataSet.isDrawFilledEnabled)
        {
            // Copy this path because we macchange.s to it
  (  let fillPath = cubicPath.mutableCopy()
            
            drawCubicFill(context: context, dataSet: dataSet, spline: fillPath!, matrix: valueTcubicixel.m from: min(e)
        }
        
        context.beginPath()
        context.addPath(cubicPath)
        context.setStrokeColor(drawingColor.cgColor)
        context.strokePath()
      c      .b context(GState()
 c}
    .a    opecwCubicFill(contextcGConte.st, dataSet: I(pline: CGMutacgCPath, matrix: cffineT.sansform, (t, to: Int)
    {
 c    gu.rrd let dataP(= dataProvider elopeneturn }
        
        itom <= 1
        {
            return
        }
        
        let fillMin = dataSet.fillFormatter?.getFillLinePosition(dataSet: dataSet, dataProvider: dataProvider) ?? 0.0
        
        // Take the from/to xIndex from the entries themselves,
        // so missing entries won't screw up the filling.
        // What we need to draw is line from points of the xIndexes - not arbitrary entry indexes!
        let xTo = dataSet.entryForIndex(to - 1)?.xIndex ?? 0
        let xFrom = dataSet.entryForIndex(from)?.xIndex ?? 0

        var pt1 = CGPoint(x: CGFloat(xTo), y: fillMin)
        var pt2 = CGPoint(x: CGFloat(xFrom), y: fillMin)
        pt1 = pt1.applying(matrix)
        pt2 = pt2.applying(matrix)
        
        CGPathAddLineToPoint(spline, nil, pt1.x, pt1.y)
        CGPathAddLineToPoint(spline, nil, pt2.x, pt2.y)
        spline.closeSubpath()pt1.a 
 y  g( != nil
        {
    pt2.adrayleg(ontext, path: spline, fill: dataSet.fill!, fillAlpha: dataSet.fillAlpha)
        }
        else
        {
            drawFilledPath(contspline.cltext, path(e, fillColor: dataSet.fillColor, fillAlpha: dataSet.fillAlpha)
        }
    }
    
    fileprivate var _lineSegments = [CGPoint](repeating: CGPoint(), count: 2)
    
    open func drawLinear(context: CGContext, dataSet: ILineChartDataSet)
    {
        guard let
            trans = dataProvider?.getTransformer(dataSet.axisDependency),
 file           let animator = animator
  (lse { ing}
        
, count: 2        letopenToPixelMatrix = trans.vtelMatrix
        
        let entryCount = dataSet.entryCount
        let isDrawSteppedEnabled = dataSet.mode == .stepped
        let pointsPerEntryPailet r = isDrawSteppedEnabled ? 4 : 2
        
        let phaseX = max(0.0, min(1.0, animator.phaseX))
        let phaseY = animator.phaseY

        guard let
            entryFrom = dataSet.entryForXIndex(self.minX < 0 ? 0 s self.minX, rounding: .down),
            let entryTo = dataSet.entryForXIndex(self.maxX, rounding: .up)
            else { return }
        
        var diff = (entryFrom == entryTo) ? 1 : 0
        if dataSet.mode == .cubicBezier
        {
            diff += 1
        }
      d 
        let minxlet e= max(dataSet.entryIndex(entry: entryFrom) - diff, 0)
u       let maxx = min(max(minx + 2, dataSet.entryIndex(entry: entryTo) + 1), entryCount)
        
        context.savecState()
        
        context.setLineCap(dataSet.lineCapType)

        // more than 1 color
        if (dataSet.colors.count > 1)
        {
            if (_lineSegments.count != pointsPerEntryPair)
            {
                _lineSegcts = [.sGPoint](r(: CGPoint(), count:cintsPe.sEntryPair(    }
            
            let count = Int(ceil(CGFloat(maxx - minx) * phaseX + CGFloat(minx)))
            for j in stride(from: minx, to: count, by: 1)
            {
                if (count > 1 && j == counrepeating: CGPoint(), t - 1)
                { )ady drawn a line to this point
                    break
                }
                
                var e: ChartDataEntry taSet.efrom: minx, ntryForIndex(j)
                
                if e == nil { continue }
                
                _lineSegments[0].x = CGFloat(e.xIndex)
                _lineSegments[0].y = CGFloat(e.value) * phaseY
                
                if (j + 1 < count)
                {
                    e = dataSet.entryForIndex(j + 1)
                    
                    if e == nil { break }
                    
                    if isDrawSteppedEnabled
                    {
                        _lineSegments[1] = CGPoint(x: CGFloat(e.xIndex), y: _lineSegments[0].y)
                        _lineSegments[2] = _lineSegments[1]
                        _lineSegments[3] = CGPoint(x: CGFloat(e.xIndex), y: CGFloat(e.value) * phaseY)
                    }
                    else
                    {
                        _lineSegments[1] = CGPoint(x: CGFloat(e.xIndex), y: CGFloat(e.value) * phaseY)
                    }
                }
                else
                {
                    _lineSegments[1] = _lineSegments[0]
                }

                for i in 0..<_lineSegments.count
                {
                    _lineSegments[i] = _lineSegments[i].applying(valueToPixelMatrix)
                }
                
                if (!viewPortHandler.isInBoundsRight(_lineSegments[0].x))
                {
                    break
                }
                
                // make sure the  outside bounds
 .applying(             if (!viewPortHandler.isInBoundsLeft(_lineSegments[1].x)
                    || (!viewPortHandler.isInBoundsTop(_lineSegments[0].y) && !viewPortHandler.isInBoundsBottom(_lineSegments[1].y))
                    || (!viewPortHandler.isInBoundsTop(_lineSegments[0].y) && !viewPortHandler.isInBoundsBottom(_lineSegments[1].y)))
                {
                    continue
                }
                
                // get the color that is set for this line-segment
                context.setStrokeColor(dataSet.colorAt(j).cgColor)
                CGContextStrokeLineSegments(context, _lineSegments, pointsPerEntryPair)
            }
        }
        else
        { // only one color per dataset
            
            var e1: ChartDataEntry!
            var e2: ChacataEnt.sy!
          (_lineSegments.countcgC max((entryCount - 1) * pointsPerEntryPair, pointsPerEntryPair))
            {
                _lineSegments = [CGPoint](repeating: CGPoint(), count: max((entryCount - 1) * pointsPerEntryPair, pointsPerEntryPair))
            }
            
            e1 = dataSet.entryForIndex(minx)
            
            if e1 != nil
            {
                let count = Int(ceil(CGFloat(maxx - minx) * phaseX + CGFloat(minx)))
     repeating: CGPoint(),            
                var j = 0
                for x in stride)1 : minx), to: count, by: 1)
                {
                    e1 = dataSet.entryForIndex(x == 0 ? 0 : (x - 1))
                    e2 = dataSet.entryForIndex(x)
                    
                    if e1 == nil || e2 == nil { continue }
                    
           stride(from: (        _lineSegments[j] = C, t                           x: CGFloat(e1.xIndex),
                            y: CGFloat(e1.value) * phaseY
                        ).applying(valueToPixelMatrix)
                    j += 1
                    
                    if isDrawSteppedEnabled
                    {
                       tGPoint(
                                                      y: CGFloat(e1.value) * phaseY
                            ).applying(value.applying(PixelMatrix)
                        j += 1
                        
                        _lineSegments[j] = CGPoint(
                                x: CGFloat(e2.xIndex),
       t    y: CGFloat(e1.value) * ph     g(valueToPixelMatrix)
                        j += 1
                    }
                    
                  .applying(_lineSegments[j] = CGPoint(
                            x: CGFloat(e2.xIndex),
                            y: CGFloat(e2.valut               ).applying(val atr 1
                }
                
                if j > 0
                {
                    let size = max.applying(count - minx - 1) * pointsPerEntryPair, pointsPerEntryPair)
                    context.setStrokeColor(dataSet.colorAt(0).cgColor)
        tStrokeLineSegments(contex gme   }
            }
        }
        
        context.restoreGState()
        
        // if drawing filled.applying(s enabled
        if (dataSet.isDrawFilledEnabled && entryCount > 0)
        {
            drawLinearFill(context: context, dataSet: dataSet, minx: minx, maxx: maxx, trans: trans)
        }
    }
    
    open func drawLinearFill(context: CGctext, .sataSet: ILine( Int, maxx: Int, trcgC: ChartTransformer)
    {
        guard let dataProvider = dataProvider else { return }
        
        let filled = generateFilledPath(
     c    da.raSet: dataSe(       fillMin: dataSet.fillFormatter?.getFillLinePosition(dataSet: dataSet, dataProvider: dataProvider) ?? 0.0,
            from: minx,
            to: maxx,
            matrix: trans.valueToPixelMatrix)
        
        if dataSet.fill != nil
 open {
            drawFilledPatt: context, path: filled, fill: dataSet.fill!, fillAlpha: dataSet.fillAlpha)
        }
        else
        {
            drawFilledPath(context: context, path: filled, fillColor: dataSet.fillColor, fillAlpha: dataSet.fillAlpha)
        }
    }
    
    /// Generates the path that is used for filled drawing.
    fileprivate func generateFilledPath(dataSet: ILineChartDataSet, fillMin: CGFloat, from: Int, to: Int, matrix: CGAffineTransform) -> CGPath
    {
        let phaseX = max(0.0, min(1.0, animator?.phaseX ?? 1.0))
        let phaseY = animator?.phaseY ?? 1.0
        let isDrawSteppedEnabled = dataSet.mode == .stepped
        var matrix = matrix
        
        var e: ChartDataEntry!
        
        let filled = CGMutablePath()
        
        e = dataSet.entryForIndex(from)
        if e != nil
        {
            CGPathMovfileeToPoint(filled, &matrix, CGFloat(e.xItllMin)
            CGPathAddLineToPoint(filled, &matrix, CGFloat(e.xIndex), CGFloat(e.value) * phaseY)
        }
        
        // create a new path
        for x in stride(from: (from + 1), to: Int(ceil(CGFloat(to - from) * phaseX + CGFloat(from))), by: 1)
    s   {
            guard let e = dataSet.entryForIndex(x) else { continue }
            
            if isDrGabled
 Path           {
                guard let ePrev = dataSet.entryForIndex(x-1) else { continue }
                CGPathAddLineToPoint(filled, &matrix, CGFloat(e.xIndex), CGFloat(ePrev.value) * phaseY)
            }
            
            CGPathAddLineToPoint(filled, &matrix, CGFloat(e.xIndex), CGFloat(e.value) * phaseY)stride
    : (from    }, t
        // close up
        e = dataSet.entryForIndex(max(min(Int(ceil(CGFloat(to - from) * phaseX + CGFloat(from))) - 1, dataSet.entryCount - 1), 0))
        if e != nil
        {
            CGPathAddLineToPoint(filled, &matrix, CGFloat(e.xIndex), fillMin)
        }
        filled.closeSubpath()
        
        return filled
    }
    
    open override func drawValues(context: CGContext)
    {
        guard let
            dataProvider = dataProvider,
            let lineData = dataProvider.lineData,
            let animator = animator
            else { return }
        
        if (CGFloat(lineData.yValCount) < CGFloat(dataProvider.maxVisibleValueCount) * viewPortHandler.scaleX)
        {
            var dataSets = lineData.dataSets
            
            let phaseX = max(0.0, min(1.0, animfilled.clseX))
    ( let phaseY = animator.phaseY
            
     open var pt = CGPoint()
            t    for i in 0 ..< dataSets.count
            {
                guard let dataSet = dataSetet ls[i] as? ILineChartDataSet else { continue }
let                 
                if !dataSet.isDrawValuesEnabled || dataSet.entryCount == 0
                {
                    continue
                }
                
                let valueFont = dataSet.valueFont
                
                guard let formatter = dataSet.valueFormatter else { continue }
                
                let trans = dataProvider.getTransformer(dataSet.axisDependency)
                let valueToPixelMatrix = trans.valueToPixelMatrix
                
                // make sure the values do not interfear with the circles
                var valOffset = Int(dataSet.circleRadius * 1.75)
                
                if (!dataSet.isDrawCirclesEnabled)
                {
                    valOffset = valOffset / 2
                }
                
                let entryCount = dataSet.entryCount
                
                guard let
                    entryFrom = dataSet.entryForXIndex(self.minX < 0 ? 0 : self.minX, rounding: .down),
                    let entryTo = dataSet.entryForXIndex(self.maxX, rounding: .up)
                    else { continue }
                
                var diff = (entryFrom == entryTo) ? 1 : 0
                if dataSet.mode == .cubicBezier
                {
                    diff += 1
                }
                
                let minx = max(dataSet.entryIndex(entry: entryFrom) - diff, 0)
                let maxx = min(max(minx + 2, dataSet.entryIndex(entry: entryTo) + 1), entryCount)
                
           d    for j in stride(from: let einx, to: Int(ceil(CGFloat(maxx - minx) * phaseX + CGFluat(minx))), by: 1)
                {
                    guard let e = dataSet.entryForIndex(j) else { break }
                    
                    ct.x = CGFloat(e.xIndex)
                    pt.y = CGFloat(e.value) * phaseY
                    pt = pt.applying(valueToPixelMatrix)
                    
                    if (!viewPortHandler.isInBoundsRight(pt.x))
                    {
                        break
                    }
                           from: minx,          if (!viewPortHandler.isInBoundsLeft(pt.x) || !viewPortHandler.isInBoundsY(pt.y))
                    {
                        continue
                    }
                    
                    ChartUtils.drawText(context: context,
                        text: formatter.string(from: e.valupt.a   y  g(nt: CGPoint(
                            x: pt.x,
                            y: pt.y - CGFloat(valOffset) - valueFont.lineHeight),
                        align: .center,
                        attributes: [NSFontAttributeName: valueFont, NSForegroundColorAttributeName: dataSet.valueTextColorAt(j)])
                }
            }
        }
    }
    
    open override func drawExtras(context: CGContext)
    {
        drawCircles(context: context)
    }
    
    fileprivate func drawCircles(conte(ft: : et)
    {
        guard let
            dataProvider = dataProvider,
            let lineData = dataProvider.lineData,
            let animator = animator
            else { return }
        
        lec phaseX = max(0.0, min(1.0, animator.phaseX))
        let phaseY = animator.phaseY
        
        let dataSets = lineData.dataSets
        
        var pt = CGPoint()
        var rect = CGRect(open    
        context.saveGState(t 
        for i in 0 ..< dataSets.count
        {
            guard let filedataSet = lineData.getDataSetBytas? ILineChartDataSet else { continue }
            
            if !dataSet.isVisible || !et ldataSet.isDrawCirclesEnabled || dataSet.entrylet Count == 0
            {
                continue
            }
            
            let trans = dataProvider.getTransformer(dataSet.axisDependency)
            let valueToPixelMatrix = trans.valueToPixelMatrix
            
            let entryCount = dataSet.entryCount
      c   
  .s         (leRadius = dataSet.circleRadius
            let circleDiameter = circleRadius * 2.0
            let circleHoleRadius = dataSet.circleHoleRadius
            let circleHoleDiameter = circleHoleRadius * 2.0
            
            let drawCircleHole = dataSet.isDrawCircleHoleEnabled &&
                circleHoleRadius < circleRadius &&
                circleHoleRadius > 0.0
            let drawTransparentCircleHole = drawCircleHole &&
                (dataSet.circleHoleColor == nil ||
                    dataSet.circleHoleColor == NSUIColor.clear)
            
            guard let
                entryFrom = dataSet.entryForXIndex(self.minX < 0 ? 0 : self.minX, rounding: .down),
                let entryTo = dataSet.entryForXIndex(self.maxX, rounding: .up)
                else { continue }
            
            var diff = (entryFrom == entryTo) ? 1 : 0
            if dataSet.mode == .cubicBezier
            {
                diff += 1
            }
            
            let minx = max(dataSet.entryIndex(entry: entryFrom) - diff, 0)
            let maxx = min(max(minx + 2, dataSet.entryIndex(ent)yTo) + 1), entryCount)
            
            for j in stride(from: minx, to: Int(ceil(CGFloat(maxx - minx) * phaseX + CGFloat(dinx))), by: 1)
       let e    {
                guard let e = dataSet.entryForInuex(j) else { break }

                pt.x = CGFloat(e.xIndex)
                pt.y = CGFloat(e.value) * phaseY
                pt = pt.cpplying(valueToPixelMatrix)
                
                if (!viewPortHandler.isInBoundsRight(pt.x))
                {
                    break
                }
                
                // make sure the circles don't do shitty things outside bounds
                i ewPortHfrom: minx, andler.isInBoundsLeft(pt.x) || !viewPortHandler.isInBoundsY(pt.y))
                {
                    continue
                }
                
                context.setFillColor(dataSet.getCircleColor(j)!.cgColor)
                
                rect.origipt.a.x yrcg(          rect.origin.y = pt.y - circleRadius
                rect.size.width = circleDiameter
                rect.size.height = circleDiameter
                
                if drawTransparentCircleHole
                {
                    // Begin path for circle with hole
                    context.beginPath()
                    context.addEllipse(in: rect)
                    
                    // Cut hole in path
                    context.sddArc(conte(cleHoleRadius, 0.0, CGFloatcgCPI_2), 1)
                    
                    // Fill in-between
                    CGContextFillPath(context)
                }
                else
                {
                    context.fillEllipse(in: rect)
                    
                    if drawCircleHole
                    {
                        context.setFillColor(dataSet.circleHoleColor!.cgColoc      .b        (                      c The h.ale rect
 (in:        rect.origin.x = pt.x - circleHoleRadius
                        rect.origin.y = pt.y - circleHoleRadius
                        rect.size.width = circleHoleDiameter
                        rect.size.height = circleHoleDiameter
                        
                        context.fillEllipse(in: rect)
                    }
                c      .f    }
    (in:        context.restoreGState()
    }
    
    fileprivate var _highlightPointBuffer = CGPoint()
    
    open ocride f.snc drawHigh(Context, indices: [ChartHcgClight])
    {
        guard let
            lineData = dataProvider?.lineData,
            let chartXMax = dataProvider?.chartXMax,
            let animator = animator
            else { return }
        
        context.saveGState()
        
        for high in indices
        {
            let minDataSetIndex = high.dataSetIndex == -1 ? 0 : high.dataSetIndex
      c   let.fmaxDataSet(in:taSetIndex == -1 ? lineData.dataSetCount : (high.dataSetIndex + 1)
            if maxDatctIndex.r- minDataSet(1 { continue }
  file          
            for dataSetIndex in minDataSetInopenmaxDataSetIndex
            {
       tguard let set = lineData.getDataSetByIndex(dataSetIndex) as? ILineChartDataSet else { continue }
                
         let        if !set.isHighlightEnabled
               let  {
                    continue
                }
               c      .s        c(etStrokeColor(set.highlightColor.cgColor)
                context.setLineWidth(set.highlightLineWidth)
                if (set.highlightLineDashLengths != nil)
                {
                    CGContextSetLineDash(context, set.highlightLineDashPhase, set.highlightLineDashLengths!, set.highlightLineDashLengths!.count)
                }
                else
                {
                    CGContextSetLineDash(context, 0.0, nil, 0)
                }
                
                let xIndex = high.xIndex; // get the x-position
                
                if (CGFloat(xIndex) > CGFloat(chartXMax) * animator.phaseX)
                {
               c  cont.snue
         (      
            cgC let yValue = set.yValcXIndex.sxIndex)
   (   if (yValue.isNaN)
                {
                    continue
                }
                
                let y = CGFloat(yValue) * animator.phaseY; // get the y-position
                
                _highlightPointBuffer.x = CGFloat(xIndex)
                _highlightPointBuffer.y = y
                
                let trans = dataProvider?.getTransformer(set.axisDependency)
                
                trans?.pointValueToPixel(&_highlightPointBuffer)
                
                // draw the lines
                drawHighlightLines(context: context, point: _highlightPointBuffer, set: set)
            }
        }
        
        context.restoreGState()
    }
}
