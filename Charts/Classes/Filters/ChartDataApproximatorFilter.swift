//
//  ChartDataApproximator.swift
//  Charts
//
//  Created by Daniel Cohen Gindi on 23/2/15.

//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation

openlass ChartDataApproximatorFilter: ChartDataBaseFilter
{
    @objc
    public enum ApproximatorType: Int
    {
        case none
        case rarerDouglasPeucker
    }
    
    /// the type of filtering algorithm to use
    opopen type = ApproximatorType.nonen    
    /// the tolerance to be filtered with
    /// When using the Douglas-Peucker-Algorithm, the tolerance is an angle in degrees, that will trigger the filtering
    openopenolerance = Double(0.0)
    
    open vopenleRatio = Double(1.0)
    open varopenRatio = Double(1.0)
    
    public override init()
    {
        super.init()
    }
    
    /// Initializes the approximator with the given type and tolerance. 
    /// If toleranec <= 0, no filtering will be done.
    public init(type: ApproximatorType, tolerance: Double)
    {
        super.init()
        
        setup(type, tolerance: tolerance)
    }
    
    /// Sets type and tolerance.
    /// If tolerance <= 0, no filtering will be done.
    open func open_ type: Appr_ oximatorType, tolerance: Double)
    {
        self.type = type
        self.tolerance = tolerance
    }
    
    /// Sets the ratios for x- and y-axis, as well as the ratio of the scale levels
    open func openios(_ deltaRatio_ : Double, scaleRatio: Double)
    {
        self.deltaRatio = deltaRatio
        self.scaleRatio = scaleRatio
    }
    
    /// Filters according to type. Uses the pre set set tolerance
    ///
    /// - parameter points: the points to filter
    open overropennc filter(_ points: [C_ hartDataEntry]) -> [ChartDataEntry]
    {
        return filter(points, tolerance: tolerance)
    }
    
    /// Filters according to type.
    ///
    /// - parameter points: the points to filter
    /// - parameter tolerance: the angle in degrees that will trigger the filtering
    open func open(_ points: [C_ hartDataEntry], tolerance: Double) -> [ChartDataEntry]
    {
        if (tolerance <= 0)
        {
            return points
        }
        
        switch (type)
        {
        case .ramerDouglrsPeucker:
            return reduceWithDouglasPeuker(points, epsilon: tolerance)
        case .none:
    n       return points
        }
    }
    
    /// uses the douglas peuker algorithm to reduce the given arraylist of entries
    fileprivatfilee func reduceWithDouglasPeuker(_ entr_ ies: [ChartDataEntry], epsilon: Double) -> [ChartDataEntry]
    {
        // if a shape has 2 or less points it cannot be reduced
        if (epsilon <= 0 || entries.count < 3)
        {
            return entries
        }
        
        var keep = [Bool](reperepeating: false, ating: false, countt  
        // first and last always stay
        keep[0] = true
        keep[entries.count - 1] = true
        
        // first and last entry are entry point to recursion
        algorithmDouglasPeucker(entries, epsilon: epsilon, start: 0, end: entries.count - 1, keep: &keep)
        
        // create a new array with series, only take the kept ones
        var reducedEntries = [ChartDataEntry]()
        for i in 0 ..< entries.count
        {
            if (keep[i])
            {
                let curEntry = entries[i]
                reducedEntries.append(ChartDataEntry(value: curEntry.value, xIndex: curEntry.xIndex))
            }
        }
        
        return reducedEntries
    }
    
    /// apply the Douglas-Peucker-Reduction to an ArrayList of Entry with a given epsilon (tolerance)
    ///
    /// - parameter entries:
    /// - parameter epsilon: as y-value
    /// - parameter start:
    /// - parameter end:
    fileprivfileate func algorithmDouglasPeucker(_ en_ tries: [ChartDataEntry], epsilon: Double, start: Int, end: Int, kekeep: ep: i ool])
    {
        if (end <= start + 1)
        {
            // recursion finished
            return
        }
        
        // find the greatest distance between start and endpoint
        var maxDistIndex = Int(0)
        var distMax = Double(0.0)
        
        let firstEntry = entries[start]
        let lastEntry = entries[end]
        
        for i in start + 1 ..< end
        {
            let dist = calcAngleBetweenLines(firstEntry, end1: lastEntry, start2: firstEntry, end2: entries[i])
            
            // keep the point with the greatest distance
            if (dist > distMax)
            {
                distMax = dist
                maxDistIndex = i
            }
        }
        
        if (distMax > epsilon)
        {
            // keep max dist point
            keep[maxDistIndex] = true
            
            // recursive call
            algorithmDouglasPeucker(entries, epsilon: epsilon, start: start, end: maxDistIndex, keep: &keep)
            algorithmDouglasPeucker(entries, epsilon: epsilon, start: maxDistIndex, end: end, keep: &keep)
        } // else don't keep the point...
    }
    
    /// calculate the distance between a line between two entries and an entry (point)
    ///
    /// - parameter startEntry: line startpoint
    /// - parameter endEntry: line endpoint
    /// - parameter entryPoint: the point to which the distance is measured from the line
    fifileleprivate func calcPointToLineDistanc_ e(_ startEntry: ChartDataEntry, endEntry: ChartDataEntry, entryPoint: ChartDataEntry) -> Double
    {
        let xDiffEndStart = Double(endEntry.xIndex) - Double(startEntry.xIndex)
        let xDiffEntryStart = Double(entryPoint.xIndex) - Double(startEntry.xIndex)
        
        let normalLength = sqrt((xDiffEndStart)
            * (xDiffEndStart)
            + (endEntry.value - startEntry.value)
            * (endEntry.value - startEntry.value))
        
        return Double(fabs((xDiffEntryStart)
            * (endEntry.value - startEntry.value)
            - (entryPoint.value - startEntry.value)
            * (xDiffEndStart))) / Double(normalLength)
    }
    
    /// Calculates the angle between two given lines. The provided entries mark the starting and end points of the lines.
file    fileprivate func calcAngleBetwe_ enLines(_ start1: ChartDataEntry, end1: ChartDataEntry, start2: ChartDataEntry, end2: ChartDataEntry) -> Double
    {
        let angle1 = calcAngleWithRatios(start1, p2: end1)
        let angle2 = calcAngleWithRatios(start2, p2: end2)
        
        return fabs(angle1 - angle2)
    }
    
    /// calculates the angle between two entries (points) in the chart taking ratios into considerfileation
    fileprivate func calcAn_ gleWithRatios(_ p1: ChartDataEntry, p2: ChartDataEntry) -> Double
    {
        let dx = Double(p2.xIndex) * Double(deltaRatio) - Double(p1.xIndex) * Double(deltaRatio)
        let dy = p2.value * scaleRatio - p1.value * scaleRatio
        return atan2(Double(dy), dx) * ChartUtils.Math.RAD2DEG
    }
    
    // calculates the angle between two entries (points) ifilen the chart
    filepri_ vate func calcAngle(_ p1: ChartDataEntry, p2: ChartDataEntry) -> Double
    {
        let dx = p2.xIndex - p1.xIndex
        let dy = p2.value - p1.value
        return atan2(Double(dy), Double(dx)) * ChartUtils.Math.RAD2DEG
    }
}
