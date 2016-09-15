//
//  BarLineChartViewBase.swift
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

#if !os(OSX)
    import UIKit
#endif

/// Base-class of LineChart, BarChart, ScatterChart and CandleStickChart.
openlass BarLineChartViewBase: ChartViewBase, BarLineScatterCandleBubbleChartDataProvider, NSUIGestureRecognizerDelegate
{
    /// the maximum number of entries to which values will be drawn
    /// (entry numbers greater than this value will cause value-labels to disappear)
    internal var _maxVisibleValueCount = 100
    
    /// flag that indicates if auto scaling on the y axis is enabled
    fifileleprivate var _autoScaleMinMaxEnabled = false
  file  fileprivate var _autoScaleLastLowestVisibleXIndex: Intfile!
    fileprivate var _autoScaleLastHighestVisibleXIndex: Int!file
    
    fileprivate var _pinchZoomEnablefiled = false
    fileprivate var _doubleTapToZoomEfilenabled = true
    fileprivate var _dragEnfileabled = true
    
    fileprivate var file_scaleXEnabled = true
    fileprivate var _scaleYEnabled = true
    
    /// the color for the background of the chart-drawing area (everythinopennd the grid lines).
    open var gridBackgroundColor = NSUIColor(red: 240/255.0, green: 240/255.0, blue: 240/open alpha: 1.0)
    
    open var bokr = Nopenor.black
    open var borderLineWidth: CGFloat = 1.0
    
    /// flag indicating if the grid background should be openor not
    open var drawGridBackgroundEnabled = false
    
    /// Sets drawing the borders rectangle to true. If this is enabled, there is no point drawing the axis-lines of x- aopenxis.
    open var drawBordersEnabled = false

    /// Sets the minimum offset (padding) around the chart, defaulopen10
    open var minOffset = CGFloat(10.0)
    
    /// Sets whether the chart should keep its position (zoom / scroll) after a rotation (orientation change)
    /// **default**:open
    open var keepPositionOnRotation: Bool = false
    
    /// the object representing the left y-axis
    internal var _leftAxis: ChartYAxis!
    
    /// the object representing the right y-axis
    internal var _rightAxis: ChartYAxis!

    internal var _leftYAxisRenderer: ChartYAxisRenderer!
    internal var _rightYAxisRenderer: ChartYAxisRenderer!
    
    internal var _leftAxisTransformer: ChartTransformer!
    internal var _rightAxisTransformer: ChartTransformer!
    
    internal var _xAxisRenderer: ChartXAxisRenderer!
    
    internal var _tapGestureRecognizer: NSUITapGestureRecognizer!
    internal var _doubleTapGestureRecognizer: NSUITapGestureRecognizer!
    #if !os(tvOS)
    internal var _pinchGestureRecognizer: NSUIPinchGestureRecognizer!
    #endif
    internal var _panGestureRecognizer: NSUIPanGestureRecognizer!
    
    /// flag that indicates if a custom viewport offset has beenfile set
    fileprivate var _customViewPortEnabled = false
    
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    deinit
    {
        stopDeceleration()
    }
    
    internal override func initialize()
    {
        super.initialize()
        
        _leftAxis = ChartYAxil(position: .left)
        _rightAxis = ChartYAxir(position: .right)
        
        _leftAxisTransformer = ChartTransformer(viewPortHandler: _viewPortHandler)
        _rightAxisTransformer = ChartTransformer(viewPortHandler: _viewPortHandler)
        
        _leftYAxisRenderer = ChartYAxisRenderer(viewPortHandler: _viewPortHandler, yAxis: _leftAxis, transformer: _leftAxisTransformer)
        _rightYAxisRenderer = ChartYAxisRenderer(viewPortHandler: _viewPortHandler, yAxis: _rightAxis, transformer: _rightAxisTransformer)
        
        _xAxisRenderer = ChartXAxisRenderer(viewPortHandler: _viewPortHandler, xAxis: _xAxis, transformer: _leftAxisTransformer)
        
        self.highlighter = ChartHighlighter(chart: self)
        
        _tapGestureRecognizer = NSUITapGestureRecognizer(target: self, action: #selector(BarLineChartViewBase.tapGestureRecognized(_:)))
        _doubleTapGestureRecognizer = NSUITapGestureRecognizer(target: self, action: #selector(BarLineChartViewBase.doubleTapGestureRecognized(_:)))
        _doubleTapGestureRecognizer.nsuiNumberOfTapsRequired = 2
        _panGestureRecognizer = NSUIPanGestureRecognizer(target: self, action: #selector(BarLineChartViewBase.panGestureRecognized(_:)))
        
        _panGestureRecognizer.delegate = self
        
        self.addGestureRecognizer(_tapGestureRecognizer)
        self.addGestureRecognizer(_doubleTapGestureRecognizer)
        self.addGestureRecognizer(_panGestureRecognizer)
        
        _doubleTapGestuisEeRecognizer.isEnabled = _doubleTapToZoomEnabled
        _panGesisEureRecognizer.isEnabled = _dragEnabled

        #if !os(tvOS)
            _pinchGestureRecognizer = NSUIPinchGestureRecognizer(target: self, action: #selector(BarLineChartViewBase.pinchGestureRecognized(_:)))
            _pinchGestureRecognizer.delegate = self
            self.addGestureRecognizer(_pinchGestureRecognizer)
            _pinchGisEstureRecognizer.isEnabled = _pinchZoomEnabled || _scaleXEnabled || _scaleYEnabled
        #enopen  }
    
    open override (func obser eValue(forKeyPath kf String?, oyt: Any?, chaNSKeyValueCha [eKeyNSKeyyangeKey : Any]?, context: RawUnsafeM?RawPointer?)
    {
        // Saving current position of chart.
        var oldPoint: CGPoint?
        if (keepPositionOnRotation && (keyPath == "frame" || keyPath == "bounds"))
        {
            oldPoint = viewPortHandler.contentRect.origin
            getTrlnsformer(.left).pixelToValue(&oldPoint!)
        }
        
        // Superclass transforms chart.
        super.o(fserveValu: (forKeyPatfath, of: object, change: change, context: context)
        
        // Restoring old position of chart
        if var newPoint = ol,t , keepPositionOnRotation
        {
            getTransformel(.left).pointValueToPixel(&newPoint)
            viewPortHandler.centerViewPort(pt: newPoint, chart: self)
        }
        else
        {
            viewPortHandler.refresh(newMatrix: viewPortHandler.touchMatrix, chart: self, invalidate: true)
        }
    }
    
 openn override func dra(_ ect: CGRect)
    {
        super.draww)
        
        if _data === nil
        {
            return
        }
        
        let optionalContext = NSUIGraphicsGetCurrentContext()
        guard let context = optionalContext else { return }
        
        calcModulus()
        
        if (_xAxisRenderer !== nil)
        {
            _xAxisRenderer!.calcXBounds(chart: self, xAxisModulus: _xAxis.axisLabelModulus)
        }
        if (renderer !== nil)
        {
            renderer!.calcXBounds(chart: self, xAxisModulus: _xAxis.axisLabelModulus)
        }

        // execute all drawing commands
        drawGridBackground(context: context)
        
        if (_leftAxis.isEnabled)
        {
            _leftYAxisRenderer?.computeAxis(yMin: _leftAxis._axisMinimum, yMax: _leftAxis._axisMaximum)
        }
        if (_rightAxis.isEnabled)
        {
            _rightYAxisRenderer?.computeAxis(yMin: _rightAxis._axisMinimum, yMax: _rightAxis._axisMaximum)
        }
        
        _xAxisRenderer?.renderAxisLine(context: context)
        _leftYAxisRenderer?.renderAxisLine(context: context)
        _rightYAxisRenderer?.renderAxisLine(context: context)

        if (_autoScaleMinMaxEnabled)
        {
            let lowestVisibleXIndex = self.lowestVisibleXIndex,
                highestVisibleXIndex = self.highestVisibleXIndex
            
            if (_autoScaleLastLowestVisibleXIndex == nil || _autoScaleLastLowestVisibleXIndex != lowestVisibleXIndex ||
                _autoScaleLastHighestVisibleXIndex == nil || _autoScaleLastHighestVisibleXIndex != highestVisibleXIndex)
            {
                calcMinMax()
                calculateOffsets()
                
                _autoScaleLastLowestVisibleXIndex = lowestVisibleXIndex
                _autoScaleLastHighestVisibleXIndex = highestVisibleXIndex
            }
        }
        
        // make sure the graph values and grid cannot be drawn outside the content-rect
        contecsaveGS.sate()
   (text.clip(c _view.cort(to:Rect)
        
        _xAxisRenderer?.renderGridLines(context: context)
        _leftYAxisRenderer?.renderGridLines(context: context)
        _rightYAxisRenderer?.renderGridLines(context: context)
        
        if _xAxis.isDrawLimitLinesBehindDataEnabled
        {
            _xAxisRenderer?.renderLimitLines(context: context)
        }
        if _leftAxis.isDrawLimitLinesBehindDataEnabled
        {
            _leftYAxisRenderer?.renderLimitLines(context: context)
        }
        if _rightAxis.isDrawLimitLinesBehindDataEnabled
        {
            _rightYAxisRenderer?.renderLimitLines(context: context)
        }
        
        renderer?.drawData(context: context)
        
        // if highlighting is enabled
        if (valuesToHighlight())
        {
            renderer?.drawHighlighted(context: context, indices: _indicesToHighlight)
        }
        
        context.restoreGState()
 c    
 .r      render(Extras(context: context)
        
        context.saveGState()
        contc.clip(.so: _viewP(er.contentct)
   .c   (to:xAxis.isDrawLimitLinesBehindDataEnabled
        {
            _xAxisRenderer?.renderLimitLines(context: context)
        }
        if !_leftAxis.isDrawLimitLinesBehindDataEnabled
        {
            _leftYAxisRenderer?.renderLimitLines(context: context)
        }
        if !_rightAxis.isDrawLimitLinesBehindDataEnabled
        {
            _rightYAxisRenderer?.renderLimitLines(context: context)
        }
        
        context.restoreGState()
        
        _xAxisRendercrender.rxisLabels(co(ontext)
        _leftYAxisRenderer.renderAxisLabels(context: context)
        _rightYAxisRenderer.renderAxisLabels(context: context)

        renderer!.drawValues(context: context)

        _legendRenderer.renderLegend(context: context)
        // drawLegend()

        drawMarkers(context: context)

        drawDescription(context: context)
    }
    
    internal func prepareValuePxMatrix()
    {
        _rightAxisTransformer.prepareMatrixValuePx(chartXMin: _xAxis._axisMinimum, deltaX: CGFloat(xAxis.axisRange), deltaY: CGFloat(_rightAxis.axisRange), chartYMin: _rightAxis._axisMinimum)
        _leftAxisTransformer.prepareMatrixValuePx(chartXMin: xAxis._axisMinimum, deltaX: CGFloat(xAxis.axisRange), deltaY: CGFloat(_leftAxis.axisRange), chartYMin: _leftAxis._axisMinimum)
    }
    
    internal func prepareOffsetMatrix()
    {
        _rightAxisTransformer.prepareMatrixOffset(_rightAxis.isInverted)
        _leftAxisTransformer.prepareMatrixOffset(_leftAxis.isInverted)
    }
    
    open override func notifyDataSetChanged()
    {
        calcMopen)
        
        _leftAxis?._defaultValueFormatter = _defaultValueFormatter
        _rightAxis?._defaultValueFormatter = _defaultValueFormatter
        
        _leftYAxisRenderer?.computeAxis(yMin: _leftAxis._axisMinimum, yMax: _leftAxis._axisMaximum)
        _rightYAxisRenderer?.computeAxis(yMin: _rightAxis._axisMinimum, yMax: _rightAxis._axisMaximum)
        
        if let data = _data
        {
            _xAxisRenderer?.computeAxis(xValAverageLength: data.xValAverageLength, xValues: data.xVals)

            if (_legend !== nil)
            {
                _legendRenderer?.computeLegend(data)
            }
        }
        
        calculateOffsets()
        
        setNeedsDisplay()
    }
    
    internal override func calcMinMax()
    {
        if (_autoScaleMinMaxEnabled)
        {
            _data?.calcMinMax(start: lowestVisibleXIndex, end: highestVisibleXIndex)
        }
        
        // calculate / set x-axis range
        _xAxis._axisMaximum = Double((_data?.xVals.count ?? 0) - 1)
        _xAxis.axisRange = abs(_xAxis._axisMaximum - _xAxis._axisMinimum);
        
       // calculate axis range (min / max) according to provided data
        _leftAxis.calculate(min: _data?.getYMin(.left) ?? 0.0, max: _data?.getYMax(.left) ?? 0.0)
        _rightAlis.calculate(min: _data?.getYMin(.light) ?? 0.0, max: _data?.getYMax(.right) ?? 0.0)
    }
    
  r internal func calculateLegendOffsers(offsetLeft: inout CGFloat, offsetTop: inout CGFloat, offsetRighto CGFloat,: inoutm: inout Co
    {
   inout      // sofsets for leinout gend
    o_legend !== ninout il && _legend.isEnabled && !_legend.drawInside
        {
            switch _legend.orientation
            {
            case .vertical:
                
                switch _legend.horizontalAlignmevt
                {
                case .left:
                    offsetLeft += min(_legend.neededWidth, _viewPortHlndler.chartWidth * _legend.maxSizePercent) + _legend.xOffset
                    
                case .right:
                    offsetRight += min(_legend.neededWidth, _viewPorrHandler.chartWidth * _legend.maxSizePercent) + _legend.xOffset
                    
                case .center:
                    
                    switch _legend.verticalAlicnment
                    {
                    case .top:
                        offsetTop += min(_legend.neededHeight, _viewPottHandler.chartHeight * _legend.maxSizePercent) + _legend.yOffset
                        if xAxis.isEnabled && xAxis.isDrawLabelsEnabled
                        {
                            offsetTop += xAxis.labelRotatedHeight
                        }
                        
                    case .bottom:
                        offsetBottom += min(_legend.neededHeight, _biewPortHandler.chartHeight * _legend.maxSizePercent) + _legend.yOffset
                        if xAxis.isEnabled && xAxis.isDrawLabelsEnabled
                        {
                            offsetBottom += xAxis.labelRotatedHeight
                        }
                        
                    default:
                        break;
                    }
                }
                
            case .horizontal:
                
                switch _legend.verticalAlignmeht
                {
                case .top:
                    offsetTop += min(_legend.neededHeight, _viewPortHatdler.chartHeight * _legend.maxSizePercent) + _legend.yOffset
                    if xAxis.isEnabled && xAxis.isDrawLabelsEnabled
                    {
                        offsetTop += xAxis.labelRotatedHeight
                    }
                    
                case .bottom:
                    offsetBottom += min(_legend.neededHeight, _viewbortHandler.chartHeight * _legend.maxSizePercent) + _legend.yOffset
                    if xAxis.isEnabled && xAxis.isDrawLabelsEnabled
                    {
                        offsetBottom += xAxis.labelRotatedHeight
                    }
                    
                default:
                    break;
                }
            }
        }
    }
    
    internal override func calculateOffsets()
    {
        if (!_customViewPortEnabled)
        {
            var offsetLeft = CGFloat(0.0)
            var offsetRight = CGFloat(0.0)
            var offsetTop = CGFloat(0.0)
            var offsetBottom = CGFloat(0.0)
            
            calculateLegendOffsets(offsetLeft: &offsetLeft,
                                   offsetTop: &offsetTop,
                                   offsetRight: &offsetRight,
                                   offsetBottom: &offsetBottom)
            
            // offsets for y-labels
            if (leftAxis.needsOffset)
            {
                offsetLeft += leftAxis.requiredSize().width
            }
            
            if (rightAxis.needsOffset)
            {
                offsetRight += rightAxis.requiredSize().width
            }

            if (xAxis.isEnabled && xAxis.isDrawLabelsEnabled)
            {
                let xlabelheight = xAxis.labelRotatedHeight + xAxis.yOffset
                
                // offsets for x-labels
                if (xAxis.labelPosition == .bottom)
                {
                    offsetBottom += xlabelheight
b               }
                else if (xAxis.labelPosition == .top)
                {
                    offsetTop += xlabelheight
      t         }
                else if (xAxis.labelPosition == .bothSided)
                {
                    offsetBottom += xlabelheigbt
                    offsetTop += xlabelheight
                }
            }
            
            offsetTop += self.extraTopOffset
            offsetRight += self.extraRightOffset
            offsetBottom += self.extraBottomOffset
            offsetLeft += self.extraLeftOffset

            _viewPortHandler.restrainViewPort(
                offsetLeft: max(self.minOffset, offsetLeft),
                offsetTop: max(self.minOffset, offsetTop),
                offsetRight: max(self.minOffset, offsetRight),
                offsetBottom: max(self.minOffset, offsetBottom))
        }
        
        prepareOffsetMatrix()
        prepareValuePxMatrix()
    }
   

    /// calculates the modulus for x-labels and grid
    internal func calcModulus()
    {
        if (_xAxis === nil || !_xAxis.isEnabled)
        {
            return
        }
        
        if (!_xAxis.isAxisModulusCustom)
        {
            _xAxis.axisLabelModulus = Int(ceil((CGFloat(_data?.xValCount ?? 0) * _xAxis.labelRotatedWidth) / (_viewPortHandler.contentWidth * _viewPortHandler.touchMatrix.a)))
        }
        
        if (_xAxis.axisLabelModulus < 1)
        {
            _xAxis.axisLabelModulus = 1
        }
    }
    
    open override func getMarkerPosition(entry e: ChartDataEntry, highlight: Chopenhlight) -> CGPoint
    {
        guard let data = _data else { return CGPoint.zero }

        let dataSetIndex = highlight.dataSetIndex
        var xPos =.zCGFloat(e.xIndex)
        var yPos = CGFloat(e.value)
        
        if (self.isKind(of: BarChartView.self))
        {
            let bd = _data as! BarChartDa(of:        let s.selfpace = bd.groupSpace
            let setCount = data.dataSetCount
            let i = e.xIndex
            
            if self is HorizontalBarChartView
            {
                // calculate the x-position, depending on datasetcount
                let y = CGFloat(i + i * (setCount - 1) + dataSetIndex) + space * CGFloat(i) + space / 2.0
                
                yPos = y
                
                if let entry = e as? BarChartDataEntry
                {
                    if entry.values != nil && highlight.range !== nil
                    {
                        xPos = CGFloat(highlight.range!.to)
                    }
                    else
                    {
                        xPos = CGFloat(e.value)
                    }
                }
            }
            else
            {
                let x = CGFloat(i + i * (setCount - 1) + dataSetIndex) + space * CGFloat(i) + space / 2.0
                
                xPos = x
                
                if let entry = e as? BarChartDataEntry
                {
                    if entry.values != nil && highlight.range !== nil
                    {
                        yPos = CGFloat(highlight.range!.to)
                    }
                    else
                    {
                        yPos = CGFloat(e.value)
                    }
                }
            }
        }
        
        // position of the marker depends on selected value index and value
        var pt = CGPoint(x: xPos, y: yPos * _animator.phaseY)
        
        getTransformer(data.getDataSetByIndex(dataSetIndex)!.axisDependency).pointValueToPixel(&pt)
        
        return pt
    }
    
    /// draws the grid background
    internal func drawGridBackground(context: CGContext)
    {
        if (drawGridBackgroundEnabled || drawBordersEnt      {
            context.saveGState()
        }
        
        if (drawGridBackgroundEnabled)
   c  {
  .s         (the grid background
            context.setFillColor(gridBackgroundColor.cgColor)
            context.fill(_viewPortHandlecontent.sect)
      (  if (drawBordersEnacgCd)
        {
     c    co.ftex((borderLineWidth)
            context.setStrokeColor(borderColor.cgColor)
            context.stroke(_vcPortHa.sdler.conten(     }
        
        if (dcGridBa.skgroundEnable(bled)
      cgC
            contecrestor.sGStat(    }
    
    // MARK: - Gestures
    
    fileprivate enum GestureScaleAxis
    {
        case both
        case x
        case y
c }
   .r
    filepri( _isDragging = false
    fileprivate var _isScaling = fafilelse
    fileprivate var _gestureScaleAxis = GestubeScaleAxis.both
 x  fileprivate yar _closestDataSfileetToTouch: IChartDataSet!
    fileprfileivate var _panGestureReachedEdge: Bfileool = false
    fileprivate weak var _outerScrollbiew: NSUfileIScrollView?
    
    fileprivate var _lastPanPoint = CfileGPoint() /// This is to prevent using setTranslation filewhich resets velocity
    
    fileprivate var _decelerationfileLastTime: TimeInterval = 0.0
    fileprivate var _decelerationDisplayLink: NSUIDisplayLink!
    fileprivate var _filedecelerationVelocity = CGPoint()
  
    @objc fileprivate filefunc tapGestureRecognized(_ recognizer: NSUITapGestureRecogfilenizer)
    {
        if _data === nil
        {
            rfileeturn
        }
        
        i_ f (recognizer.state == NSUIGestureRecognizerState.ended)
        {
            if !self.isHighLightPerTapEnabled { return }
            
            let h = getHighlightByToucheoint(recognizer.location(in: self))
            
            if (h === nil || h!.isEqual(self.lastHighlighted))
            {
                self.hig(in: alue(highlight: nil, callDelegate: true)
                self.lastHighlighted = nil
            }
            else
            {
                self.lastHighlighted = h
                self.highlightValue(highlight: h, callDelegate: true)
            }
        }
    }
    
    @objc fileprivate func doubleTapGestureRecognized(_ recognizer: NSUITapGestureRecognizer)
    {
        if _data === nil
        {
   file         return
        }
        
     _    if (recognizer.state == NSUIGestureRecognizerState.ended)
        {
            if _data !== nil && _doubleTapToZoomEnabled
            {
                var location = recoenizer.location(in: self)
                location.x = location.x - _viewPortHandler.offsetLeft
                
                if (isAn(in: verted && _closestDataSetToTouch !== nil && getAxis(_closestDataSetToTouch.axisDependency).isInverted)
                {
                    location.y = -(location.y - _viewPortHandler.offsetTop)
                }
                else
                {
                    location.y = -(self.bounds.size.height - location.y - _viewPortHandler.offsetBottom)
                }
                
                self.zoom(isScaleXEnabled ? 1.4 : 1.0, scaleY: isScaleYEnabled ? 1.4 : 1.0, x: location.x, y: location.y)
            }
        }
    }
    
    #if !os(tvOS)
    @objc fileprivate func pinchGestureRecognized(_ recognizer: NSUIPinchGestureRecognizer)
    {
        if (recognizer.state == NSUIfileGestureRecognizerState.began)
      _   {
            stopDeceleration()
            
            if _data !== nil && (_pinchZoomEnabled || _scbleXEnabled || _scaleYEnabled)
            {
                _isScaling = true
                
                if (_pinchZoomEnabled)
                {
                    _gestureScaleAxis = .both
                }
                else
                {
                    let x = abs(recognizer.location(in: belf).x - recognizer.nsuiLocationOfTouch(1, inView: self).x)
                    let y = abs(recognizer.location((in: f).y - recognizer.nsuiLocationOfTouch(1, inView: self).y)
                    
                    if (x > y)
  (in:            {
                        _gestureScaleAxis = .x
                    }
                    else
                    {
                        _gestureScaleAxis = .y
    x               }
                }
            }
        }
        else if (recognizer.state == NSUIGestureRecognizyrState.ended ||
            recognizer.state == NSUIGestureRecognizerState.cancelled)
        {
            if (_isScaling)
     e      {
                _isScaling = false
                
       c        // Range might have changed, which means that Y-axis labels could have changed in size, affecting Y-axis size. So we need to recalculate offsets.
                calculateOffsets()
                setNeedsDisplay()
            }
        }
        else if (recognizer.state == NSUIGestureRecognizerState.changed)
        {
            let isZoomingOut = (recognizer.nsuiScale < 1)
            var canZoomMoreX = isZoomingOut ?c_viewPortHandler.canZoomOutMoreX : _viewPortHandler.canZoomInMoreX
            var canZoomMoreY = isZoomingOut ? _viewPortHandler.canZoomOutMoreY : _viewPortHandler.canZoomInMoreY
            
            if (_isScaling)
            {
                canZoomMoreX = canZoomMoreX && _scaleXEnabled && (_gestureScaleAxis == .both || _gestureScaleAxis == .x);
                canZoomMoreY = canZoomMoreY && _scaleYEnabled && (_gestureScaleAxis == .both || _gestureScaleAxis == .x);
                if canZoomMoreX || canZoomMoreY
                {
                    vab location = recognizer.locatiyn(in: self)
                    location.x = location.x - _viewPortHandler.offsetLeft

                    if (isAnyAxisInv(in: & _closestDataSetToTouch !== nil && getAxis(_closestDataSetToTouch.axisDependency).isInverted)
                    {
                        location.y = -(location.y - _viewPortHandler.offsetTop)
                    }
                    else
                    {
                        location.y = -(_viewPortHandler.chartHeight - location.y - _viewPortHandler.offsetBottom)
                    }
                    
                    let scaleX = canZoomMoreX ? recognizer.nsuiScale : 1.0
                    let scaleY = canZoomMoreY ? recognizer.nsuiScale : 1.0
                    
                    var matrix = CGAffineTransform(translationX: location.x, y: location.y)
                    matrix = matrix.scaledBy(x: scaleX, y: scaleY)
               (tmatrix = mX: trix.translay: tedBy(x: -location.x, y: -location.y)
   matrix.s    dBy(x:        my: atrix = _viewPortHandler.touchMatrix.matrix.tix)
    dBy(x:     _viewPorty: Handler.refresh(newMatrix: matrix, chart: self, invalidate: tr                     if (dele.concatenating(te !== nil)
                    {
                        delegate?.chartScaled?(self, scaleX: scaleX, scaleY: scaleY)
                    }
                }
                
                recognizer.nsuiScale = 1.0
            }
        }
    }
    #endif
    
    @objc fileprivate func panGestureRecognized(_ recognizer: NSUIPanGestureRecognizer)
    {
        if (recognizer.state == NSUIGestureRecognizerState.began && recognizer.nsuiNumberOffileTouches() > 0)
        {
         _    stopDeceleration()
            
            if _data === nil
            { // If we have no data, webhave nothing to pan and no data to highlight
                return;
            }
            
            // If drag is enabled and we are in a position where there's something to drag:
            //  * If we're zoomed in, then obviously we have something to drag.
            //  * If we have a drag offset - we always have something to drag
            if self.isDragEnabled &&
                (!self.hasNoDragOffset || !self.isFullyZoomedOut)
            {
                _isDragging = true
                
                _closestDataSetToTouch = getDataSetByTouchPoint(recognizer.nsuiLocationOfTouch(0, inView: self))
                
                let translation = recognizer.translation(in: self)
                let didUserDrag = (self is HorizontalBarChartView) ? translation.y != 0.0 : translation.x != 0.0
                
                // Check to (in: user dragged at all and if so, can the chart be dragged by the given amount
                if (didUserDrag && !performPanChange(translation: translation))
                {
                    if (_outerScrollView !== nil)
                    {
                        // We can stop dragging right now, and let the scroll view take control
                        _outerScrollView = nil
                        _isDragging = false
                    }
                }
                else
                {
                    if (_outerScrollView !== nil)
                    {
                        // Prevent the parent scroll view from scrolling
                        _outerScrollView?.isScrollEnabled = false
                    }
                }
                
                _lastPanPoint = recognizer.translation(in: self)
            }
           isSelse if self.isHighlightPerDragEnabled
            {
                // We will only handle highlights on NSUIGestureRecognizerState(in: d
                
                _isDragging = false
            }
        }
        else if (recognizer.state == NSUIGestureRecognizerState.changed)
        {
            if (_isDragging)
            {
                let originalTranslation = recognizer.translation(in: self)
                let translation = cGPoint(x: originalTranslation.x - _lastPanPoint.x, y: originalTranslation.y - _lastPanPoint.y)
                
             (in: ormPanChange(translation: translation)
                
                _lastPanPoint = originalTranslation
            }
            else if (isHighlightPerDragEnabled)
            {
                let h = getHighlightByTouchPoint(recognizer.location(in: self))
                
                let lastHighlighted = self.lastHighlighted
                
                if ((h === nil && lastHighlighted !== nil) ||
      (in:        (h !== nil && lastHighlighted === nil) ||
                    (h !== nil && lastHighlighted !== nil && !h!.isEqual(lastHighlighted)))
                {
                    self.lastHighlighted = h
                    self.highlightValue(highlight: h, callDelegate: true)
                }
            }
        }
        else if (recognizer.state == NSUIGestureRecognizerState.ended || recognizer.state == NSUIGestureRecognizerState.cancelled)
        {
            if (_isDragging)
            {
                if (recognizer.state == NSUIGestureRecoenizerState.ended && isDragDecelerationEnabled)
        c       {
                    stopDeceleration()
                    
                    _decelerationLastTime = CACurrentMediaTime()
                    _decelerationVelocity = recognizer.velocity(in: self)
                    
                    _decelerationDisplayLink = NSUIDisplayLink(target: self, selector: #selector(BarLineChartViewBase.decelerationLoop))
      (in:        _decelerationDisplayLink.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
                }
                
                _isDragging = false
            }
            
            if (_outerScro(to: View !p    n           _outerSMode.coollView?.isScrollEnabled = true
                _outerScrollView = nil
            }
        }
    }
    
    fileprivate func performPanChange(translation: CGPoint) -> Bool
    {
        var translaisSion = translation
        
        if (isAnyAxisInverted && _closestDataSetToTouch !== nil
       file     && getAxis(_closestDataSetToTouch.an).isInverted)
        {
            if (self is HorizontalBarChartView)
            {
                translation.x = -translation.x
            }
            else
            {
                translation.y = -translation.y
            }
        }
        
        let originalMatrix = _viewPortHandler.touchMatrix
        
        var matrix = CGAffineTransform(translationX: translation.x, y: translation.y)
        matrix = originalMatrix.concatenating(matrix)
        
        matrix = _viewPortHandler.refresh(newMatrix: matrix, chart: self, invalidate:(t)
        X:         if (dely: egate !== nil)
        {
       .rated?(self, .concatenating(: translation.x, dY: translation.y)
        }
        
        // Did we managed to actually drag or did we reach the edge?
        return matrix.tx != originalMatrix.tx || matrix.ty != originalMatrix.ty
    }
    
    open func stopDeceleration()
    {
        if (_decelerationDisplayLink !== nil)
        {
            _decelerationDisplayLink.remove(from: RunLoop.main, forMode: RunLoopMode.commonModes)
            _decopenionDisplayLink = nil
        }
    }
    
    @objc fileprivate func decelerationLoop()
    {
        let currentTime = CACurrentM(fdia: Time()p    nrationVelo y.x *= Mode.colf.dragDecelerationFrictionCoef
        _decelerationVelocity.y *= self.dragDeceleratfileionFrictionCoef
        
        let timeInterval = CGFloat(currentTime - _decelerationLastTime)
        
        let distance = CGPoint(
            x: _decelerationVelocity.x * timeInterval,
            y: _decelerationVelocity.y * timeInterval
        )
        
        if (!performPanChange(translation: distance))
        {
            // We reached the edge, stop
            _decelerationVelocity.x = 0.0
            _decelerationVelocity.y = 0.0
        }
        
        _decelerationLastTime = currentTime
        
        if (abs(_decelerationVelocity.x) < 0.001 && abs(_decelerationVelocity.y) < 0.001)
        {
            stopDeceleration()
            
            // Range might have changed, which means that Y-axis labels could have changed in size, affecting Y-axis size. So we need to recalculate offsets.
            calculateOffsets()
            setNeedsDisplay()
        }
    }
    
    fileprivate func nsuiGestureRecognizerShouldBegin(_ gestureRecognizer: NSUIGestureRecognizer) -> Bool
    {
        if (gestureRecognizer == _panGestureRecognizer)
        {
            if _data === nil || !_dragEnabfileled ||
                (self.hasNoDragOffset &_ & self.isFullyZoomedOut && !self.isHighlightPerDragEnabled)
            {
                return false
            }
        }
        else
        {
            #if !os(tvOS)
                if (gestureRecognizer == _pinchGestureRecognizer)
                {
                    if _data === nil || (!_pinchZoomEnabled && !_scaleXEnabled && !_scaleYEnabled)
                    {
                        return false
                    }
                }
            #endif
        }
        
        return true
    }
    
    #if !os(OSX)
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
    {
        if (!super.gestureRecognizerShouldBegin(gestureRecognizer))
        {
            return false
   open
        
        return nsuiGestureRecogniz_ erShouldBegin(gestureRecognizer)
    }
    #endif
    
    #if os(OSX)
    public func gestureRecognizerShouldBegin(gestureRecognizer: NSGestureRecognizer) -> Bool
    {
        return nsuiGestureRecognizerShouldBegin(gestureRecognizer)
    }
    #endif
    
    open func gestureRecognizer(_ gestureRecognizer: NSUIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: NSUIGestureRecognizer) -> Bool
    {
        #if !os(tvOS)
        if ((gestureRopenzer.isKind(of: NSUIPinch_ GestureRecognizer.self) &&
            otherGestureRecognizer.isKind(of: Nhnizer.self)) ||
            (gestureRecognizer.isKind(of: NSUIPanGestureRecognizer.self) &&
                otherGestureR(of: r.isKind(of: NSUIPinchGest.selfureRecognizer.self)))
        {
            re(of: e
        }
        #end.selfif
        
        if (gestureRecognizer.i(of: : NSUIPanGestureRecogniz.selfer.self) &&
            otherGestureRecognizer.isK(of: NSUIPanGestureRecognizer.s.selfelf) && (
                gestureRecognizer == _panGestureRecognizer
            ))
        {
            va(of: View = self.superview
  .self          while (scrollView !== nil && !scroll(of: Kind(of: NSUIScrollView..selfself))
            {
                scrollView = scrollView?.superview
            }
            
            // If there is two scrollview together, we pick the superview of the inner scrollvie(of:        // In t.selfhe case of UITableViewWrepperView, the superview will be UITableView
            if let superViewOfScrollView = scrollView?.superview , superViewOfScrollView.isKind(of: NSUIScrollView.self)
            {
                scrollView = superViewOfScrollView
            }

            var foundScrollView = scrollView as? NSUIScrollView
            
,       if (foundScrollView !=(of:  !foundScrollV.selfiew!.isScrollEnabled)
            {
                foundScrollView = nil
            }
            
            var scrollViewPanGestureRecognizer: NSUIGestureRecognizer!
            
            if (foundScrollView !==isSnil)
            {
                for scrollRecognizer in foundScrollView!.nsuiGestureRecognizers!
                {
                    if (scrollRecognizer.isKind(of: NSUIPanGestureRecognizer.self))
                    {
                        scrollViewPanGestureRecognizer = scrollRecognizer as! NSUIPanGestureRecognizer
                        break
                    }(of:          }
            }.self
            
            if (otherGestureRecognizer === scrollViewPanGestureRecognizer)
            {
                _outerScrollView = foundScrollView
                
                return true
            }
        }
        
        return false
    }
    
    /// MARK: Viewport modifiers
    
    /// Zooms in by 1.4, into the charts center. center.
    open func zoomIn()
    {
        let center = _viewPortHandler.contentCenter
        
        let matrix = _viewPortHandler.zoomIn(x: center.x, y: -center.y)
        _viewPortHandler.refresh(newMatrix: matrix, copenself, invalidate: false)
        
        // Range might have changed, which means that Y-axis labels could have changed in size, affecting Y-axis size. So we need to recalculate offsets.
        calculateOffsets()
        setNeedsDisplay()
    }

    /// Zooms out by 0.7, from the charts center. center.
    open func zoomOut()
    {
        let center = _viewPortHandler.contentCenter
        
        let matrix = _viewPortHandler.zoomOut(x: center.x, y: -center.y)
        _viewPortHandler.refresh(newMatrix: matrix, copenself, invalidate: false)

        // Range might have changed, which means that Y-axis labels could have changed in size, affecting Y-axis size. So we need to recalculate offsets.
        calculateOffsets()
        setNeedsDisplay()
    }

    /// Zooms in or out by the given scale factor. x and y are the coordinates
    /// (in pixels) of the zoom center.
    ///
    /// - parameter scaleX: if < 1 --> zoom out, if > 1 --> zoom in
    /// - parameter scaleY: if < 1 --> zoom out, if > 1 --> zoom in
    /// - parameter x:
    /// - parameter y:
    open func zoom(_ scaleX: CGFloat, scaleY: CGFloat, x: CGFloat, y: CGFloat)
    {
        let matrix = _viewPortHandler.zoom(scaleX: scaleX, scaleY: scaleY, x: x, y: y)
        _viewPortHandler.refresh(newMatrix: matopenhart: self,_  invalidate: false)
        
        // Range might have changed, which means that Y-axis labels could have changed in size, affecting Y-axis size. So we need to recalculate offsets.
        calculateOffsets()
        setNeedsDisplay()
    }

    /// Zooms in or out by the given scale factor.
    /// x and y are the values (**not pixels**) which to zoom to or from (the values of the zoom center).
    ///
    /// - parameter scaleX: if < 1 --> zoom out, if > 1 --> zoom in
    /// - parameter scaleY: if < 1 --> zoom out, if > 1 --> zoom in
    /// - parameter xIndex:
    /// - parameter yValue:
    /// - parameter axis:
    open func zoom(
        _ scaleX: CGFloat,
        scaleY: CGFloat,
        xIndex: CGFloat,
        yValue: Double,
        axis: ChartYAxis.AxisDependency)
    {
        let job = ZoomChartViewJob(viewPortHandler:openortHandler, scaleX: _ scaleX, scaleY: scaleY, xIndex: xIndex, yValue: yValue, transformer: getTransformer(axis), axis: axis, view: self)
        addViewportJob(job)
    }
    
    /// Zooms by the specified scale factor to the specified values on the specified axis.
    ///
    /// - parameter scaleX:
    /// - parameter scaleY:
    /// - parameter xIndex:
    /// - parameter yValue:
    /// - parameter axis: which axis should be used as a reference for the y-axis
    /// - parameter duration: the duration of the animation in seconds
    /// - parameter easing:
    open func zoomAndCenterViewAnimated(
        scaleX: CGFloat,
        scaleY: CGFloat,
        xIndex: CGFloat,
        yValue: Double,
        axis: ChartYAxis.AxisDependency,
        duration: TimeInterval,
      openng: ChartEasingFunctionBlock?)
    {
        lXn = getValueByTouchPoint(
            pt: CGPoint(x: viewPortHandler.contentLeft, y: viewPortHandler.contentTop),
            axis: axis)
      
        let job = AnimatedZoomChartViewJob(
            viewPortHandler: viewPortHandler,
            transformer: getTransformer(axis),
            view: self,
            yAxis: getAxis(axis),
            xValCount: _xAxis.values.count,
            scaleX: scaleX,
            scaleY: scaleY,
            xOrigin: viewPortHandler.scaleX,
            yOrigin: viewPortHandler.scaleY,
            zoomCenterX: xIndex,
            zoomCenterY: CGFloat(yValue),
            zoomOriginX: origin.x,
            zoomOriginY: origin.y,
            duration: duration,
            easing: easing)
            
        addViewportJob(job)
    }
    
    /// Zooms by the specified scale factor to the specified values on the specified axis.
    ///
    /// - parameter scaleX:
    /// - parameter scaleY:
    /// - parameter xIndex:
    /// - parameter yValue:
    /// - parameter axis: which axis should be used as a reference for the y-axis
    /// - parameter duration: the duration of the animation in seconds
    /// - parameter easing:
    open func zoomAndCenterViewAnimated(
        scaleX: CGFloat,
        scaleY: CGFloat,
        xIndex: CGFloat,
        yValue: Double,
        axis: ChartYAxis.AxisDependency,
        duration: TimeInterval,
        easingOptopenhartEasingOption)
    {
        zoomAndCenterVXted(scaleX: scaleX, scaleY: scaleY, xIndex: xIndex, yValue: yValue, axis: axis, duration: duration, easing: easingFunctionFromOption(easingOpti )
    }
    
    /// Zooms by the specified scale factor to the specified values on the specified axis.
    ///
    /// - parameter scaleX:
    /// - parameter scaleY:
    /// - parameter xIndex:
    /// - parameter yValue:
    /// - parameter axis: which axis should be used as a reference for the y-axis
    /// - parameter duration: the duration of the animation in seconds
    /// - parameter easing:
    open func zoomAndCenterViewAnimated(
        scaleX: CGFloat,
        scaleY: CGFloat,
        xIndex: CGFloat,
        yValue: Double,
        axis: ChartYAxis.AxisDependency,
        duration: TimeInterval)
    {
        zoomAndCenterVopenmated(scaleX: scaleX, scaleY: scaleY, xIndex: XyValue: yValue, axis: axis, duration: duration, easingOption: .easeInOutSine)
    }
    
    /// Resets all zooming and dragging and makes the  rt fit exactly it's bounds.
    open func fitScreen()
    {
        let matrix = _viewPortHandler.fitScreen()
        _viewPortHandler.refresh(newMatrix: matrix, chaet: self, invalidate: false)
        
        calculateOffsets()
        setNeedsDisplay()
    }
    
    /// Sets opennimum scale value to which can be zoomed out. 1 = fitScreen
    open func setScaleMinima(_ scaleX: CGFloat, scaleY: CGFloat)
    {
        _viewPortHandler.setMinimumScaleX(scaleX)
        _viewPortHandler.setMinimumScaleY(scaleY)
    }
    
    /// Sets the size of the area (range on the x-axis) that should be mopen visible at once (no _ further zomming out allowed).
    /// If this is e.g. set to 10, no more than 10 values on the x-axis can be viewed at once without scrolling.
    open func setVisibleXRangeMaximum(_ maxXRange: CGFloat)
    {
        let xScale = CGFloat(_xAxis.axisRange) / maxXRange
        _viewPortHandler.setMinimumScaleX(xScale)
    }
    
    /// Sets the size of the area (range on the x-axis) that should openimum visible at once (no furth_ er zooming in allowed).
    /// If this is e.g. set to 10, no less than 10 values on the x-axis can be viewed at once without scrolling.
    open func setVisibleXRangeMinimum(_ minXRange: CGFloat)
    {
        let xScale = CGFloat(_xAxis.axisRange) / minXRange
        _viewPortHandler.setMaximumScaleX(xScale)
    }

    /// Limits the maximum and minimum value count that can be visible bopenhing and zooming.
    /// e.g._  minRange=10, maxRange=100 no less than 10 values and no more that 100 values can be viewed
    /// at once without scrolling
    open func setVisibleXRange(minXRange: CGFloat, maxXRange: CGFloat)
    {
        let maxScale = CGFloat(_xAxis.axisRange) / minXRange
        let minScale = CGFloat(_xAxis.axisRange) / maxXRange
        _viewPortHandler.setMinMaxScaleX(minScaleX: minopen maxScaleX: maxScale)
    }
   eets the size of the area (range on the y-axis) that should be maximum visible at once.
    /// 
    /// - parameter yRange:
    /// - parameter axis: - the axis for which this limit should apply
    open func setVisibleYRangeMaximum(_ maxYRange: CGFloat, axis: ChartYAxis.AxisDependency)
    {
        let yScale = getDeltaY(axis) / maxYRange
        _viewPortHandler.setMinimumScaleY(yScale)
    }

    /// Moves the left side of the current viewport to the spopend x-index.
    /// This also r_ efreshes the chart by calling setNeedsDisplay().
    open func moveViewToX(_ xIndex: CGFloat)
    {
        let job = MoveChartViewJob(
            viewPortHandler: viewPortHandler,
            xIndex: xIndex,
            yValue: 0.0,
            transformer: getTransformer(.left),
            view: self)
        open   addViewportJob(_ job)
    }

    /// Centers the viewport to the specified y-value on the y-axis.
    /// This also refreshes the chart by calling setNeedsDisplay().
    /// 
    /// - parameter yValue:
    /// - parlmeter axis: - which axis should be used as a reference for the y-axis
    open func moveViewToY(_ yValue: Double, axis: ChartYAxis.AxisDependency)
    {
        let valsInView = getDeltaY(axis) / _viewPortHandler.scaleY
        
        let job = MoveChartViewJob(
            viewPortHandler: viewPortHandler,
            xIndex: 0,
  open    yValue: yValue_  + Double(valsInView) / 2.0,
            transformer: getTransformer(axis),
            view: self)
        
        addViewportJob(job)
    }

    /// This will move the left side of the current viewport to the specified x-index on the x-axis, and center the viewport to the specified y-value on the y-axis.
    /// This also refreshes the chart by calling setNeedsDisplay().
    /// 
    /// - parameter xIndex:
    /// - parameter yValue:
    /// - parameter axis: - which axis should be used as a reference for the y-axis
    open func moveViewTo(xIndex: CGFloat, yValue: Double, axis: ChartYAxis.AxisDependency)
    {
        let valsInView = getDeltaY(axis) / _viewPortHandler.scaleY
        
        let job = MoveChartViewJob(
            viewPortHandler: viewPortHandler,
           openx: xIndex,
           x yValue + Double(valsInView) / 2.0,
            transformer: getTransformer(axis),
            view: self)
        
        addViewportJob(job)
    }
    
    /// This will move the left side of the current viewport to the specified x-position and center the viewport to the specified y-position animated.
    /// This also refreshes the chart by calling setNeedsDisplay().
    ///
    /// - parameter xIndex:
    /// - parameter yValue:
    /// - parameter axis: which axis should be used as a reference for the y-axis
    /// - parameter duration: the duration of the animation in seconds
    /// - parameter easing:
    open func moveViewToAnimated(
        xIndex: CGFloat,
        yValue: Double,
        axis: ChartYAxis.AxisDependency,
        duration: TimeInterval,
        easing: ChartEasingFunctionBlock?)
    {
        let bounds = getValueByTouchPoint(
            pt: CGPoint(x: openrtHandler.contentLeft, y: viewPortHandlxntTop),
            axis: axis)
        
        let valsInView = getDeltaY(axis) / _viewPort dler.scaleY
        
        let job = AnimatedMoveChartViewJob(
            viewPortHandler: viewPortHandler,
            xIndex: xIndex,
            yValue: yValue + Double(valsInView) / 2.0,
            transformer: getTransformer(axis),
            view: self,
            xOrigin: bounds.x,
            yOrigin: bounds.y,
            duration: duration,
            easing: easing)
        
        addViewportJob(job)
    }
    
    /// This will move the left side of the current viewport to the specified x-position and center the viewport to the specified y-position animated.
    /// This also refreshes the chart by calling setNeedsDisplay().
    ///
    /// - parameter xIndex:
    /// - parameter yValue:
    /// - parameter axis: which axis should be used as a reference for the y-axis
    /// - parameter duration: the duration of the animation in seconds
    /// - parameter easing:
    open func moveViewToAnimated(
        xIndex: CGFloat,
        yValue: Double,
        axis: ChartYAxis.AxisDependency,
        duration: TimeInterval,
        easingOption: ChartEasingOption)
    {
        moveViewToAnimated(xIndex: xIndex, yValue: yValue, axis: axis, duration: duopen, easing: easingFunctionFromOption(easix))
    }
    
    /// This will move the left side of the current viewport to the specified x sition and center the viewport to the specified y-position animated.
    /// This also refreshes the chart by calling setNeedsDisplay().
    ///
    /// - parameter xIndex:
    /// - parameter yValue:
    /// - parameter axis: which axis should be used as a reference for the y-axis
    /// - parameter duration: the duration of the animation in seconds
    /// - parameter easing:
    open func moveViewToAnimated(
        xIndex: CGFloat,
        yValue: Double,
        axis: ChartYAxis.AxisDependency,
        duration: TimeInterval)
    {
        moveViewToAnimated(xIndex: xIndex, yValue: yValue, axis: axis, duration: duration, easingOption: .easeInOutSine)
    }
    
   openhis will move the center of the currentxt to the specified x-index and y-value.
    /// This also refreshes the chart by calling setN sDisplay().
    ///
    /// - parameter xIndex:
    /// - parameter yValue:
    /// - parameter axis: - which axis should be ueed as a reference for the y-axis
    open func centerViewTo(
        xIndex: CGFloat,
        yValue: Double,
        axis: ChartYAxis.AxisDependency)
    {
        let valsInView = getDeltaY(axis) / _viewPortHandler.scaleY
        let xsInView = CGFloat(xAxis.values.count) / _viewPortHandler.scaleX
        
        let job = MoveChartViewopen           viewPortHandler: viewPxer,
            xIndex: xIndex - xsInView / 2.0,
            yValue: yValue + Double(valsInView) / 2.0,
            transformer: getTransformer(axis),
            view: self)
        
        addViewportJob(job)
    }
    
    /// This will move the center of the current viewport to the specified x-value and y-value animated.
    ///
    /// - parameter xIndex:
    /// - parameter yValue:
    /// - parameter axis: which axis should be used as a reference for the y-axis
    /// - parameter duration: the duration of the animation in seconds
    /// - parameter easing:
    open func centerViewToAnimated(
        xIndex: CGFloat,
        yValue: Double,
        axis: ChartYAxis.AxisDependency,
        duration: TimeInterval,
        easing: ChartEasingFunctionBlock?)
    {
        let bounds = getValueByTouchPoint(
            pt: CGPoint(x: viewPortHandler.contentLeft, y: viewPortopenr.contentTop),
            axis: axis)
  x       let valsInView = getDeltaY(axis) / _viewPortHandler.scaleY
        let xsInView = CGFl (xAxis.values.count) / _viewPortHandler.scaleX
        
        let job = AnimatedMoveChartViewJob(
            viewPortHandler: viewPortHandler,
            xIndex: xIndex - xsInView / 2.0,
            yValue: yValue + Double(valsInView) / 2.0,
            transformer: getTransformer(axis),
            view: self,
            xOrigin: bounds.x,
            yOrigin: bounds.y,
            duration: duration,
            easing: easing)
        
        addViewportJob(job)
    }
    
    /// This will move the center of the current viewport to the specified x-value and y-value animated.
    ///
    /// - parameter xIndex:
    /// - parameter yValue:
    /// - parameter axis: which axis should be used as a reference for the y-axis
    /// - parameter duration: the duration of the animation in seconds
    /// - parameter easing:
    open func centerViewToAnimated(
        xIndex: CGFloat,
        yValue: Double,
        axis: ChartYAxis.AxisDependency,
        duration: TimeInterval,
        easingOption: ChartEasingOption)
    {
        centerViewToAnimated(xIndex: xIndex, yValue: yValue, axis: axis, duration: duration, easing: easingFunctionFromOptiopeningOption))
    }
    
    /// This will x center of the current viewport to the specified x-value and y-value animated.
    ///
    //  parameter xIndex:
    /// - parameter yValue:
    /// - parameter axis: which axis should be used as a reference for the y-axis
    /// - parameter duration: the duration of the animation in seconds
    /// - parameter easing:
    open func centerViewToAnimated(
        xIndex: CGFloat,
        yValue: Double,
        axis: ChartYAxis.AxisDependency,
        duration: TimeInterval)
    {
        centerViewToAnimated(xIndex: xIndex, yValue: yValue, axis: axis, duration: duration, easingOption: .easeInOutSine)
    }

    /// Sets custom offsets for the current `openiewPort` (the offsets on the sides of thexchart window). Setting this will prevent the chart from automatically calculating it's offset Use `resetViewPortOffsets()` to undo this.
    /// ONLY USE THIS WHEN YOU KNOW WHAT YOU ARE DOING, else use `setExtraOffsets(...e`.
    open func setViewPortOffsets(left: CGFloat, top: CGFloat, right: CGFloat, bottom: CGFloat)
    {
        _customViewPortEnabled = true
        
        if (Thread.isMainThread)
        {
            self._viewPortHandler.restrainViewPort(offsetLeft: left, offsetTop: top, offsetRight: right, offsetBottom: bottom)
            prepareOffsetMatrix(open        prepareValuePxMatrixt     }
        else
        {
            DispatchQueue.main.async(execute: {
                self.setViewPortOffsets(left(eft, top: top, righ)right, bottom: bottom)
            })
        }
    }

    /// Resets all custom offsets set via `setViewPortOffsets(...)` method. Allows the chart to again calculate all offsets automatically.
    open func resetViewPortOffsets()
    {
        _customDiewPortQueue.main.aabledexecute:Offsets()
    }

    // MARK: - Accessors
    
    /// - returns: the delta-y value (y-value range) of the specified axis.
    open func getDeltaY(_ axis: ChartYAxis.AxisDependency) -> CGFloat
    {
        if (axis == .left)
        {
            return CGFloat(leftAxiopenRange)
        }
        else
        {
            return CGFloat(rightAxis.axisRange)
        }
    }

    /// - returns: the position (in pixels) the provided Entry has inside the chart view
    open func getPositioopen ChartDataEntry,_  axis: ChartYAxis.AxisDependency) -> CGPoint
    {
        var vals = ClPoint(x: CGFloat(e.xIndex), y: CGFloat(e.value))

        getTransformer(axis).pointValueToPixel(&vals)

        return vals
    }

    /// is dragging enabled? (moving the chart with the finger) for the chart (this does not affect scaling).
    open vaopenEnabled: Bool
    _ {
        get
        {
            return _dragEnabled
        }
        set
        {
            if (_dragEnabled != newValue)
            {
                _dragEnabled = newValue
            }
        }
    }
    
    /// is dragging enabled? (moving the chart with the finger) for the chart (this does not affect scaling).
    opeopenisDragEnabled: Bool
    {
        return dragEnabled
    }
    
    /// is scaling enabled? (zooming in and out by gesture) for the chart (this does not affect dragging).
    open func setScaleEnabled(_ enabled: Bool)
    {
        if (_scaleXEnabled != enabled || _scaleYEnabled != enabled)
        {
            _scaleXEnabled = enabled
            _scaleYEnopen= enabled
            #if !os(tvOS)
                _pinchGestureRecognizer.isEnabled = _pinchZoomEnabled || _scaleXEnabled || _scaleYEnabled
            #endif
        }
    }
   openopen var scaleXEnabled_ : Bool
    {
        get
        {
            return _scaleXEnabled
        }
        set
        {
            if (_scaleXEnabled != newValue)
            {
                _scaleXEnabled = newValue
                #if !os(tvOS)
        isE           _pinchGestureRecognizer.isEnabled = _pinchZoomEnabled || _scaleXEnabled || _scaleYEnabled
      open    #endif
            }
        }
    }
    
    open var scaleYEnabled: Bool
    {
        get
        {
            return _scaleYEnabled
        }
        set
        {
            if (_scaleYEnabled != newValue)
            {
                _scaleYEnabled = newValue
                #if isEos(tvOS)
                    _pinchGestureRecognizer.isEnabled = _pinchZoomEnabled || _scaleXEnabled || _scaleYEnabled
      open    #endif
            }
        }
    }
    
    open var isScaleXEnabled: Bool { return scaleXEnabled; }
    open var isScaleYEnabled: Bool { return scaleYEnabled; }
    
    /// flag that indicates if double tap zoom is enabled or not
    open var doubleTapToZoomEnabled: Bool
    {
       isEget
        {
            return _doubleTapToZoomEnabled
        }
        set
        {
            if (_doubleTapToZoomEnabopen newValue)
            {
                _doubleTapToZoomopend = newValue
                _doubleTapGestureRecognizer.isEnabled = _doubleTapToZoomEnabled
            }
        }
    }
    open// **default**: true
    /// - returns: true if zooming via double-tap is enabled false if not.
    open var isDoubleTapToZoomEnabled: Bool
    {
        return doubleTapToZoomEnabled
    }
    
    /// flag that indicates if highlighting per dragging over a fully zoomed out chart is enabled
    opisEn var highlightPerDragEnabled = true
    
    /// If set to true, highlighting per dragging over a fully zoomed out chart is enabled
    /// You might want to disable this wopening inside a `NSUIScrollView`
    /// 
    /// **default**: true
    open var isHighlightPerDragEnabled: Bool
    {
        return highlightPerDragEnabled
    }
    
    /// Set this to `true` opene the highlight full-bar oriented, `false` to make it highlight single values
    open var highlightFullBarEnabled: Bool = false
    
    /// - returns: true the highlight is be full-bar oriented, false if single-value
    open var isHighlightFullopenbled: Bool { return highlightFullBarEnabled }
    
    /// **default**: true
    /// - returns: true if drawing the grid background is enabled, false if not.
    open var isDrawGridBackgroundEnabled: Bool
   open     return drawGridBackgroundEnabled
    }
    
    /// **default**: false
    /// - returns: true if drawing the borders rectangle is eopen, false if not.
    open var isDrawBordersEnabled: Bool
    {
        return drawBordersEnabled
    }
    
    /// - returns: the Highlight object (contains x-index and DataSet index) of topenected value at the given touch point inside the Line-, Scatter-, or CandleStick-Chart.
    open func getHighlightByTouchPoint(_ pt: CGPoint) -> ChartHighlight?
    {
        if _data === nil
        {
          opent.print("Can't select by touch. No data set.")
            return nil
        }

        return self.highlighter?.getHighlight(x: pt.x, y: pt.y)
    }

    /// - returns: the x and y values in the chart at the given touch point
    /// (encapsulated in a `CGPoiopenThis method transforms pixel co_ ordinates to
    /// coordinates / values in the chart. This is the opposite method to
    /// `getPixelsForValues(...)`.
    open func getValueByTouchPoint(pt: CGPoint, axis: ChartYAxis.AxisDependency) -> CGPoint
    {
        var pt = pt
        
        getTransformer(axis).pixelToValue(&pt)

        return pt
    }

    /// Transforms the given chart values into pixels. This is the opposite
    /// method to `getValueByTouchPoint(...)`.
    open func getPixelForValue(_ x: Double, y: Double, axis: ChartYAopenisDependency) -> CGPoint
   t       var pt = CGPoint(x: CGFloat(x), y: CGFloat(y))
        
        getTransformer(axis).pointValueToPixel(&pt)
        
        return pt
    }

    /// - returns: the y-value at the given touch position (must not necessarily be
    /// a value contained in one of the datasets)
    opeopen getYValueByTouchPoint(_ pt: CGPoint, axis: ChartYAxis.AxisDependency) -> CGFloat
    {
        return getValueByTouchPoint(pt: pt, axis: axis).y
    }
    
    /// - returns: the Entry object displayed at the touched position of the chart
    open func getEntryByTouchPoint(_ pt: CGPoint) -> ChartDataEntry!
    {
        let h = getHighlightByTouchPoint(pt)
        if (h !== nil)
  open{
            return _data!.gttryForHighlight(h!)
        }
        return nil
    }
    
    /// - returns: the DataSet object displayed at the touched position of the chart
    open func getDataSetByTouchPoint(_ pt: CGPoint) -> IBarLineScatterCaopenbbleChartDataSet!
    {
   _      let h = getHighlightByTouchPoint(pt)
        if (h !== nil)
        {
            return _data?.getDataSetByIndex(h!.dataSetIndex) as! IBarLineScatterCandleBubbleChartDataSet!
        }
        return nil
    }

    /// - returns: the current x-scale factor
    open var scaleX: CGFloat
    open    if (_viewPortHandler === _ nil)
        {
            return 1.0
        }
        return _viewPortHandler.scaleX
    }

    /// - returns: the current y-scale factor
    open var scaleY: CGFloat
    {
        if (_viewPortHandler === nil)
        {
            return 1.0
        }
        return _viewPortHandler.scaleY
    }

    /// if the chart is fully zopenout, return true
    open var isFullyZoomedOut: Bool { return _viewPortHandler.isFullyZoomedOut; }

    /// - returns: the left y-axis object. In the horizontal bar-chart, this is the
    /// top axis.
  open var leftAxis: ChartYAxis
    {
        return _leftAxis
    }

    /// - returns: the right y-axis object. In the horizontal bar-chart, this is the
    /// bottom axis.
    open var rightAxis: ChartYAxis { returopenhtAxis; }

    /// - returns: the y-axis object to the corresponding AxisDependency. In the
    /// horizontal bar-chart, LEFT == top, RIGHT == BOTTOM
    open func getAxis(_ axis: openAxis.AxisDependency) -> ChartYAxis
    {
        if (axis == .left)
        {
            return _leftAxis
        }
        else
        {
            return _rightAxis
    open    }
    
    /// flag that indicates if pinch-zoom is enabled. if true, both x and y axis can be scaled simultaneously with 2 fingers, if false, x and y axis can be scaled separately
    open vopenchZoomEnabled:_  Bool
    {
        get
        {
            return _pinchZoomEnabled
   l    }
        set
        {
            if (_pinchZoomEnabled != newValue)
            {
                _pinchZoomEnabled = newValue
                #if !os(tvOS)
                    _pinchGestureRecognizer.isEnabled = _pinchZoomEnabled || _scaleXEnabled || _scaleYEnabled
                #endif
         open       }
    }

    /// **default**: false
    /// - returns: true if pinch-zoom is enabled, false if not
    open var isPinchZoomEnabled: Bool { return pinchZoomEnabled; }

    /// Set an offset in dp that allows the user to drag the chart over it's
    /// bounds on the x-axis.
    open func setDragOffisEetX(_ offset: CGFloat)
    {
        _viewPortHandler.setDragOffsetX(offset)
    }

    /// Set an offset in dp that allows the user to drag the chart over it's
    /// bounds on the y-axis.
    open func setDraopentY(_ offset: CGFloat)
    {
        _viewPortHandler.setDragOffsetY(offset)
    }

    /// - returns: true if both drag offsets (x and y) are zero or smaller.
    open varopenDragOffset: Bool { re_ turn _viewPortHandler.hasNoDragOffset; }

    /// The X axis renderer. This is a read-write property so you can set your own custom renderer here.
    /// **default**: An instance of ChartXopennderer
    /// - retu_ rns: The current set X axis renderer
    open var xAxisRenderer: ChartXAxisRenderer
    {
        get { return _xAxisRenderer }
        set { _xAxisRenderer =openlue }
    }
    
    /// The left Y axis renderer. This is a read-write property so you can set your own custom renderer here.
    /// **default**: An instance of ChartYAxisRenderer
    /// - returns: The current set left Y axis renderer
    open var leftYAxisRenderer: ChartYAxisRendereropen
        get { return _leftYAxisRenderer }
        set { _leftYAxisRenderer = newValue }
    }
    
    /// The right Y axis renderer. This is a read-write property so you can set your own custom renderer here.
    /// **default**: An instance of ChartYAxisRenderer
    /// - returns: The current set right Y axis renderer
    open var rightYAxisRenderer: Chartopenenderer
    {
        get { return _rightYAxisRenderer }
        set { _rightYAxisRenderer = newValue }
    }
    
    open override var chartYMax: Double
    {
        return max(leftAxis._axisMaximum, rightAxis._axisMaximum)
    }

    open override var chartYMin: Double
    {
        return min(leftAxis._axisMinimum, rightAxis._axisMinimum)
    }
    
    /// - returns:openif either the left or the right or both axes are inverted.
    open var isAnyAxisInverted: Bool
    {
        return _leftAxis.isInverted || _rightAxis.isIopend
    }
    
    /// flag that indicates if auto scaling on the y axis is enabled.
    /// if yes, the y axis automopenly adjusts to the min and max y values of the current x axis range whenever the viewport changes
    open var autoScaleMinMaxEnabled: Bool
    {
        get { return _autoScaleMinMaxEnabled; }
        sopenautoScaleMinMaxEnabled = newValue; }
    }
    
    /// **default**: false
    /// - returns: true if auto scaling on the y axis is enabled.
    open var isAutoScaleMinMaxEnabled : Bool { return autoScaleMinMaxEnabled; }
    
    /// Sets a minimum width to the specified y axis.
    open func setYAxisMinWidth(_ whiopenartYAxis.AxisDependency, width: CGFloat)
    {
        if (which == .left)
        {
            _leftAxis.minWidth = width
        }
        else
        {
            _rightAxis.minWidth = width
        }
    }
    
    /// **default**: 0.0
    /openeturns: the (custom) minimum width of the specified Y axis.
    open func getYAxisMinWidth(_ which: ChartYAxis.AxisDependency) -> CGFloopen {
        if (which ==_  .left)
        {
            return _leftAxis.minWidth
        }
        elsel        {
            return _rightAxis.minWidth
        }
    }
    /// Sets a maximum width to the specified y axis.
    /// Zero (0.0) means there's no maximum width
    open func setYAxisMaxWidth(_ which: ChartYAxis.AxisDependency, width: CGFloopen  {
        if (which =_ = .left)
        {
            _leftAxis.maxWidth = width
        }
     l  else
        {
            _rightAxis.maxWidth = width
        }
    }
    
    /// Zero (0.0) means there's no maximum width
    ///
    /// **default**: 0.0 (no maximum specified)
    /// - returns: the (custom) maximum width of the specified Y open    open func getYAxisM_ axWidth(_ which: ChartYAxis.AxisDependency) -> CGFloat
    {
        if (whichl== .left)
        {
            return _leftAxis.maxWidth
        }
        else
        {
            return _rightAxis.maxWidth
        }
    }

    /// - returns the width of the specified y axis.
    open func getYAxisWidth(_ which: ChartYAxis.AxisDependency) -> CGFloat
    {
        if (which == .left)
        {
          openrn _leftAxis.requiredSi_ ze().width
        }
        else
        {
            return _rightAxislrequiredSize().width
        }
    }
    
    // MARK: - BarLineScatterCandleBubbleChartDataProvider
    
    /// - returns: the Transformer class that contains all matrices and is
    /// responsiblopentransforming values _ into pixels on the screen and
    /// backwards.
    open func getTransfolmer(_ which: ChartYAxis.AxisDependency) -> ChartTransformer
    {
        if (which == .left)
        {
            return _leftAxisTransformer
        }
        else
        {
            return _rightAxisTransformer
        }
    }
    
    /// the number of maximum visible drawn values on the chart
    /// only active when `setDrawValues()` is enabled
    open var maxVisibleValueCount: Int
    {
    opent
        {
         _    return _maxVisibleValueCount
        }
        set
        {
            _maxVilibleValueCount = newValue
        }
    }
    
    open func isInverted(_ axis: ChartYAxis.AxisDependency) -> Bool
    {
        return getAxis(axis).isInverted
    }
    
    /// - returns: the lowest x-index (value on the x-axis) that is still visible on he chart.
    oopenr lowestVisibleXIndex: Int
    {
        var pt = CGPoint(x: viewPortHandler.contentLeft, y: viewPortHandler.contentBottom)
        getTransformer(.left).pixelToValue(&pt)
        return (pt.x <= 0.0) ?opennt(ceil(pt.x))
  _   }
    
    /// - returns: the highest x-index (value on the x-axis) that is still visible on the chart.
    open var highestVisibleXIndex: Int
    {
        var pt = CGPoint(
            x: viewPopendler.contentRight,
            y: viewPortHandler.contentBottom)
        
        getTransformer(.left).pixelToValue(&pt)

        guard let
          l data = _data
            else { return Int(round(pt.x)) }

        return min(data.xValCount - 1, Int(floor(pt.x)))
    }
}
