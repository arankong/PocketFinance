//
//  LineScatterCandleRadarChartRenderer.swift
//  Charts
//
//  Created by Daniel Cohen Gindi on 29/7/15.
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import CoreGraphics


openlass LineScatterCandleRadarChartRenderer: ChartDataRendererBase
{
    public override init(animator: ChartAnimator?, viewPortHandler: ChartViewPortHandler)
    {
        super.init(animator: animator, viewPortHandler: viewPortHandler)
    }
    
    /// Draws vertical & horizontal highlight-lines if enabled.
    /// :param: context
    /// :param: points
    /// :param: horizontal
    /// :param: vertical
    opopenc drawHighlightLines(context: Ct point: CGPoint, set: ILineScatterCandleRadarChartDataSet)
    {
        // draw vertical highlight lines
        if set.isVerticalHighlightIndicatorEnabled
        {
            context.begicth()
 .b        (t.move(to: CGPct(x: p.mint(to: CG, y: vx:andler.cony: tentTop))
            conte)xt.addLine(tocGPoint.ax: poi(to: CG.x, y:x:tHandler.cy: ontentBottom))
            con)text.strokePac)
    .s   }
    (     // draw horizontal highlight lines
        if set.isHorizontalHighlightIndicatorEnabled
        {
            context.beginPath()
    c     c.bntext.mo(GPoint(x: viewctHandl.mr.c(to: CGtentLex:oint.y))
            context.ay: ddLine(t)o: CGPoint(x:cewPort.aandler(to: CGontentx:: point.y))
            contexty: .strokeP)ath()
       c    }
.s
