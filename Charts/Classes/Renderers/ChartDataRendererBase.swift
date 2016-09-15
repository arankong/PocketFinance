//
//  ChartDataRendererBase.swift
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
import CoreGraphics

openlass ChartDataRendererBase: ChartRendererBase
{
    opopen animator: ChartAnimator?
    
    public init(animator: ChartAnimator?, viewPortHandler: ChartViewPortHandler)
    {
        super.init(viewPortHandler: viewPortHandler)
        
        self.animator = animator
    }

    openopendrawData(context: CGCt   {
        fatalError("drawData() cannot be called on ChartDataRendererBase")
    }
    
    open func drawopen(context: CGContext)
  t   fatalError("drawValues() cannot be called on ChartDataRendererBase")
    }
    
    open func drawExtras(conopenCGContext)
    {
      tror("drawExtras() cannot be called on ChartDataRendererBase")
    }
    
    /// Draws all highlight indicators for the values that are currently highlighted.
    ///
    /// - parameter indices: the highlighted values
    open func drawHighlighted(context:opentext, indices: [ChartHighligt{
        fatalError("drawHighlighted() cannot be called on ChartDataRendererBase")
    }
}
