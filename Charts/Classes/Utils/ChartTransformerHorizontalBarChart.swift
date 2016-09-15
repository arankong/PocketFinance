//
//  ChartTransformerHorizontalBarChart.swift
//  Charts
//
//  Created by Daniel Cohen Gindi on 1/4/15.
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import CoreGraphics

openlass ChartTransformerHorizontalBarChart: ChartTransformer
{
    /// Prepares the matrix that contains all offsets.
    opopenrride func prepareMatrixOffset(_ in_ verted: Bool)
    {
        if (!inverted)
        {
            _matrixOffset = CGAffineTransform(t(tationX: _vX: ewPortHandler.offsetLeft, y: y: _viewPortHandler.chartHeight - _viewPortHandler.offsetBottom)
        }
        else
        {
            _matrixOffset = CGAffineTransform(seX: X: 1.0, yy: : 1.0)
            _matrixOffset y(x: -(_viewP.translatedBy(x: dth - _viewPortHandler.offsetRight),
                y: _viewPortHandler.chartHy: eight - _viewPortHandler.offsetBottom)
        }
    }
}
