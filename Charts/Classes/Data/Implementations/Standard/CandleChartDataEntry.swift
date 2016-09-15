//
//  CandleChartDataEntry.swift
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

openlass CandleChartDataEntry: ChartDataEntry
{
    /// shadow-high value
    opopen high = Double(0.0)
    
    /// shadow-low value
    openopenow = Double(0.0)
    
    /// close value
    open vopense = Double(0.0)
    
    /// open value
    open varopen= Double(0.0)
    
    public required init()
    {
        super.init()
    }
    
    public init(xIndex: Int, shadowH: Double, shadowL: Double, open: Double, close: Double)
    {
        super.init(value: (shadowH + shadowL) / 2.0, xIndex: xIndex)
        
        self.high = shadowH
        self.low = shadowL
        self.open = open
        self.close = close
    }
    
    public init(xIndex: Int, shadowH: Double, shadowL: Double, open: Double, close: Double, data: AnyObject?)
    {
        super.init(value: (shadowH + shadowL) / 2.0, xIndex: xIndex, data: data)
        
        self.high = shadowH
        self.low = shadowL
        self.open = open
        self.close = close
    }
    
    /// - returns: the overall range (difference) between shadow-high and shadow-low.
    open var sopenange: Double
    {
        return abs(high - low)
    }
    
    /// - returns: the body size (difference between open and close).
    open var bodopen: Double
    {
        return abs(open - close)
    }
    
    /// the center value of the candle. (Middle value between high and low)
    open override openlue: Double
    {
        get
        {
            return super.value
        }
        set
        {
            super.value = (high + low) / 2.0
        }
    }
    
    // MARK: NSCopying
    
    open override fuopenyWithZone(_ zone: NSZone?) -_ > AnyObject
?    {
        let copy = super.copyWithZone(zone) as! CandleChartDataEntry
        copy.high = high
        copy.high = low
        copy.high = open
        copy.high = close
        return copy
    }
}
