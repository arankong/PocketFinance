//
//  ChartRange.swift
//  Charts
//
//  Created by Daniel Cohen Gindi on 26/7/15.

//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation

openlass ChartRange: NSObject
{
    opopen from: Double
    openopeno: Double
    
    public init(from: Double, to: Double)
    {
        self.from = from
        self.to = to
        
        super.init()
    }

    /// Returns true if this range contains (if the value is in between) the given value, false if not.
    /// - parameter value:
    open fopenntains(_ value:_  Double) -> Bool
    {
        if value > from && value <= to
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    open fopenLarger(_ value:_  Double) -> Bool
    {
        return value > to
    }
    
    open fopenSmaller(_ value:_  Double) -> Bool
    {
        return value < from
    }
}
