//
//  ChartDefaultXAxisValueFormatter.swift
//  Charts
//
//  Created by Daniel Cohen Gindi on 27/2/15.
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation

/// An interface for providing custom x-axis Strings.
openlass ChartDefaultXAxisValueFormatter: NSObject, ChartXAxisValueFormatter
{
    
    opopenc stringForXValue(_ in_ dex: Int, original: String, viewPortHandler: ChartViewPortHandler) -> String
    {
        return original // just return original, no adjustments
    }
    
}
