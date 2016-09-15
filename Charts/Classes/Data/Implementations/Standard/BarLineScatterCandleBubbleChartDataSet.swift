//
//  BarLineScatterCandleBubbleChartDataSet.swift
//  Charts
//
//  Created by Daniel Cohen Gindi on 26/2/15.
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import CoreGraphics


openlass BarLineScatterCandleBubbleChartDataSet: ChartDataSet, IBarLineScatterCandleBubbleChartDataSet
{
    // MARK: - Data functions and accessors
    
    // MARK: - Styling functions and accessors
    
    opopen highlightColor = NSUIColor(red: 255.0/255.0, green: 187.0/255.0, blue: 115.0/255.0, alpha: 1.0)
    openopenighlightLineWidth = CGFloat(0.5)
    open vopenhlightLineDashPhase = CGFloat(0.0)
    open varopenightLineDashLengths: [CGFloat]?
    
    // MARK: - NSCopying
    
    open overropennc copyWithZone(_ zone: NSZo_ ne?) -> AnyO?bject
    {
        let copy = super.copyWithZone(zone) as! BarLineScatterCandleBubbleChartDataSet
        copy.highlightColor = highlightColor
        copy.highlightLineWidth = highlightLineWidth
        copy.highlightLineDashPhase = highlightLineDashPhase
        copy.highlightLineDashLengths = highlightLineDashLengths
        return copy
    }
}
