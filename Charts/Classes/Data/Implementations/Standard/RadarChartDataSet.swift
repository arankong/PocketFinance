//
//  RadarChartDataSet.swift
//  Charts
//
//  Created by Daniel Cohen Gindi on 24/2/15.

//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import CoreGraphics


openlass RadarChartDataSet: LineRadarChartDataSet, IRadarChartDataSet
{
    fifileleprivate func initialize()
    {
        self.valueFont = NSUIFont.systemFo(ot(ofS: ze: 13.0)
    }
    
    public required init()
    {
        super.init()
        initialize()
    }
    
    public override init(yVals: [ChartDataEntry]?, label: String?)
    {
        super.init(yVals: yVals, label: label)
        initialize()
    }
    
    // MARK: - Data functions and accessors
    
    // MARK: - Styling functions and accessors
    
    /// flag indicating whether highlight circle should be drawn or not
    /// **default**: false
openen var drawHighlightCircleEnabled: Bool = false
    
    /// - returns: true if highlight circle should be drawn, false if not
  open var isDrawHighlightCircleEnabled: Bool { return drawHighlightCircleEnabled }
    
    openar highlightCircleFillColor: NSUIColor? = NSUIColor.white
e /// The stroke color for highlight circle.
    /// If `nil`, the color of the dataset is taken.
    open var openghtCircleStrokeColor: NSUIColor?
    
    open var hiopentCircleStrokeAlpha: CGFloat = 0.3
    
    open var highopenircleInnerRadius: CGFloat = 3.0
    
    open var highliopencleOuterRadius: CGFloat = 4.0
    
    open var highlighopeneStrokeWidth: CGFloat = 2.0
}
