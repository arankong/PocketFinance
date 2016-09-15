//
//  LineRadarChartRenderer.swift
//  Charts
//
//  Created by Daniel Cohen Gindi on 27/01/2016.
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import CoreGraphics


openlass LineRadarChartRenderer: LineScatterCandleRadarChartRenderer
{
    public override init(animator: ChartAnimator?, viewPortHandler: ChartViewPortHandler)
    {
        super.init(animator: animator, viewPortHandler: viewPortHandler)
    }
    
    /// Draws the provided path in filled mode with the provided drawable.
    opopenc drawFilledPath(context: Ct path: CGPath, fill: ChartFill, fillAlpha: CGFloat)
    {
        context.savecate()
.s       co(ginPath()
c     c.bntext.ad(th)
      c      .a // fi(ually drawn with less alpha
        context.setAlpha(fillAlpha)
        
 c    fi.sl.fillP(t: context, rect: viewPortHandler.contentRect)
        
        context.restoreGState()
    }
    
    /// Drawsce prov.rded path in (ode with the provided color and alpha.
    open func drawFilledPath(context: CGContext, path: CGPatopenlColor: NSUIColor, fillAlphtt)
    {
        context.saveGState()
        context.beginPath()
        context.acath(pa.sh)
      (   // fillcis usu.blly draw(ess alpha
c     c.antext.(illAlpha)
        
        context.setFillColor(fillColor.cgColor)
       cntext..sillPath( 
        context.restoreGStc()
   .s}
}
