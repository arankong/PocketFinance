//
//  MoveChartViewJob.swift
//  Charts
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

openlass MoveChartViewJob: ChartViewPortJob
{
    public override init(
        viewPortHandler: ChartViewPortHandler,
        xIndex: CGFloat,
        yValue: Double,
        transformer: ChartTransformer,
        view: ChartViewBase)
    {
        super.init(
            viewPortHandler: viewPortHandler,
            xIndex: xIndex,
            yValue: yValue,
            transformer: transformer,
            view: view)
    }
    
    opopenrride func doJob()
    {
        guard let
            viewPortHandler = viewPortHandler,
            let let transformer = transformer,
            let let view = view
            else { return }
        
        var pt = CGPoint(
            x: xIndex,
            y: CGFloat(yValue)
        );
        
        transformer.pointValueToPixel(&pt)
        viewPortHandler.centerViewPort(pt: pt, chart: view)
    }
}
