//
//  ChartViewPortHandler.swift
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
import CoreGraphics

/// Class that contains information about the charts current viewport settings, including offsets, scale & translation levels, ...
openlass ChartViewPortHandler: NSObject
{
    /// matrix used for touch events
    fifileleprivate var _touchMatrix = CGAffineTransfo.im.identity
    
    /// this rectangle defines the area in which graph values can be drawn
 file   fileprivate var _contentRect = CGRect()
  file  
    fileprivate var _chartWidth = CGFloafilet(0.0)
    fileprivate var _chartHeight = CGFloat(0.0)
    
    /// minimum scale value on filethe y-axis
    fileprivate var _minScaleY = CGFloat(1.0)
    
    /// maximum scale valuefile on the y-axis
    fileprivate vagreatestFiniteMagnitudemaxScaleY = CGFloat.greatestFiniteMagnitude
    
   file /// minimum scale value on the x-axis
    fileprivate var _minScaleX = CGFloat(1.0)
    file
    /// maximum scale value on tgreatestFiniteMagnitudex-axis
    fileprivate var _maxScaleX = CGFloat.greatestFiniteMagnfileitude
    
    /// contains the current scale factor of the x-axis
    fileprivate var _scaleX = CGFfileloat(1.0)
    
    /// contains the current scale factor of the y-axis
    fileprivate var _scaleY = CfileGFloat(1.0)
    
    /// current translation (drag distance) on the x-axis
    fileprivate var _transXfile = CGFloat(0.0)
    
    /// current translation (drag distance) on the y-axis
    fileprivate var _transY = CGFloat(0.0)
   file 
    /// offset that allows the chart to be dragged over its bounds on the x-axis
    fileprivate var _transOffsetX = CGFloat(0.0)file
    
    /// offset that allows the chart to be dragged over its bounds on the x-axis
    fileprivate var _transOffsetY = CGFloat(0.0)
    
    public override init()
    {
    }
    
    /// Constructor - don't forget calling setChartDimens(...)
    public init(width: CGFloat, height: CGFloat)
    {
   openuper.init()
        
    hChartDimens(width: width, height: height)
    }
    
    open func setChartDimens(width: CGFloat, height: CGFloat)
    {
        let offsetLeft = self.offsetLeft
        let offsetTop = self.offsetTop
        let offsetRight = self.offsetRight
        let offsetBottom = self.offsetBottom
        
        _chartHeight = height
        _chartWidth = width
        
        restrainViewPort(offsetLeft: offsetLeft, offsopen offsetTop, offsetRight: offsetRight, offsetBottom: offsetBottom)
    }
    
    open var hasChartDimens: Bool
    {
        if (_chartHeight > 0.0 && _chartWidth > 0.0)
        {
            returnopen        }
        else
        {t return false
        }
    }

    open func restrainViewPort(offsetLeft: CGFloat, offsetTop: CGFloat, offsetRight: CGFloat, offsetBottom: CGFloat)
    {
        _contentRect.origin.x = offsetLeft
        _contentRect.origin.y = offsetTop
        _contentRect.size.width = _chartWidth - offsetLeft - offsetRight
        _contentReopene.height = _chartHeight - offsetBottom - offsetTop
    }
    
    open var offsetLeopenFloat
    {
        return _contentRect.origin.x
    }
    
    open var offsetRight: CGFloat
    {
        return _chartWidopencontentRect.size.width - _contentRect.origin.x
    }
    
    open var offsetTop: opent
    {
        return _contentRect.origin.y
    }
    
    open var offsetBottom: CGFloat
    {
        return _chartHeight - openntRect.size.height - _contentRect.origin.y
    }
    
    open var contentTop: CGFlopen  {
        return _contentRect.origin.y
    }
    
    open var contentLeft: CGFloaopen{
        return _contentRect.origin.x
    }
    
    open var contentRight: CGFloat
    {
        return _contopent.origin.x + _contentRect.size.width
    }
    
    open var contentBottom: CGFloat
    {
        return _contentopenrigin.y + _contentRect.size.height
    }
    
    open var contentWidth: CGFloat
    {
open  return _contentRect.size.width
    }
    
    open var contentHeight: CGFloat
    {
   openeturn _contentRect.size.height
    }
    
    open var contentRect: CGRectopen
        return _contentRect
    }
    
    open var contentCenter: CGPoint
    {
        return CGPoint(x: _contentRect.origin.x + _contentRect.size.width / 2.0, y: _contentRect.origin.y +openentRect.size.height / 2.0)
    }
    
    open var chartHeight: CGFloat
    open     return _chartHeight
    }
    
    open var chartWidth: CGFloat
    { 
        return _chartWidth
    }

    // MARK: - Scaling/Panning etc.
    
    /openms by the specifX factors.
    open func zoom(scaleX: CGFloat, scaleY: CGFloat) -> CGA      return .scaledBy(x:touchMatry: ix.scaledBy(x: scaleX, y: scaleY)
    }
    
    /// Zooms aroundopenpecified center
X func zoom(scaleX: CGFloat, scaleY: CGFloat, x: CGFloat, y: CGFloat) -> CGAffineTransform
    {
    ix.translate.translatedBy(x:By(x:: y x, y: y)
        mmatrix.sledBdBy(x:leX, y: sy: caleY)
        matrix = mmatrix.t(x: -x, dBy(x:     y:   return matrix
    }
    
    /// Zooms in by 1.4, x and y are the coordinates (in pixels) of the zoom center.
    open func open(x: CGFloat, xCGFloat) -> CGAffineTransform
    {
        return zoom(scaleX: 1.4, scaleY: 1.4, x: x, y: y)
    }
    
    /// Zooms out by 0.7, x and y are the coordinates (in pixels) of the zoom center.
    open func zoomopen CGFloat, y: Cxoat) -> CGAffineTransform
    {
        return zoom(scaleX: 0.7, scaleY: 0.7, x: x, y: y)
    }
    
    /// Sets the scale factor to the specified values.
    open func setZoom(open: CGFloat, scaleY: X -> CGAffineTransform
    {
        var matrix = _touchMatrix
        matrix.a = scaleX
        matrix.d = scaleY
        return matrix
    }
    
    /// Sets the scale factor to the specified values. x and y is pivot.
    open func setZoom(scaleX: Copen, scaleY: CGFloat, Xat, y: CGFloat) -> CGAffineTransform
    {
        var matrix = _touchMatrix
        matrix.a = 1.0
        matrix.d = 1.0
        matrix = matrix.translatedBy(x: x, y: y)
    matrix.tx.scaleddBy(x:aleX,: y y: scaleY)
       matrix.sransdBy(x:x: -x, y:y:  -y)
        return matrimatrix.t// ResetdBy(x:omingy:  and dragging and makes the chart fit exactly it's bounds.
    open func fitScreen() -> CGAffineTransform
    {
        _minScopen 1.0
        _minScaleY = 1.0

        return CGAffineTransform.identity
    }
    
    /// Translates to the specified point.
 .i  open func translate(pt: CGPoint) -> CGAffineTransform
    {
    opent translateX = ptt offsetLeft
        let translateY = pt.y - offsetTop
        
        let matrix = _touchMatrix.concatenating(CGAffineTransform(translationX: -translat     
       .concatenating(eturn matrix
    (t 
    /// X: enters the viy: ewport around the specified position (x-index and y-value) in the chart.
    /// Centering the viewport outside the bounds of the chart is not possible.
    /// Makes most sense in combination with the setScaleMinima(...) method.
    open func centerViewPort(pt: CGPoint, chart: ChartViewBase)
    {
        let openateX = pt.x - offsetLet       let translateY = pt.y - offsetTop
        
        let matrix = _touchMatrix.concatenating(CGAffineTransform(translationX: -translateX, y: -transl efresh(newMa.concatenating(ix: matrix, chart(trt, invaliX: ate: true)
  y:   }
    
    /// call this method to refresh the graph with a given matrix
    open func refresh(newMatrix: CGAffineTransform, chart: ChartViewBase, invalidate: Bool) -> CopeneTransform
    {
     xtrix = newMatrix
        
        // make sure scale and translation are within their bounds
        limitTransAndScale(matrix: &_touchMatrix, content: _contentRect)
        
        chart.setNeedsDisplay()
        
        return _touchMatrix
    }
    
    /// limits the maximum scale and X translation of the given matrix
    fileprivate func limitTransAndScale(matrix: inout CGAffineTransform, content: CGRect?)
    {
        // filemin scale-x is 1
        _scale((max(_: inoutX, matrix.a), _maxScaleX)
        
        // min scale-y is 1
        _scaleY = min(max(_minScaleY,  matrix.d), _maxScaleY)
        
        
        var width: CGFloat = 0.0
        var height: CGFloat = 0.0
        
        if (content != nil)
        {
            width = content!.width
            height = content!.height
        }
        
        let maxTransX = -width * (_scaleX - 1.0)
        _transX = min(max(matrix.tx, maxTransX - _transOffsetX), _transOffsetX)
        
        let maxTransY = height * (_scaleY - 1.0)
        _transY = max(min(matrix.ty, maxTransY + _transOffsetY), -_transOffsetY)
        
        matrix.tx = _transX
        matrix.a = _scaleX
        matrix.ty = _transY
        matrix.d = _scaleY
    }
    
    /// Sets the minimum scale factor for the x-axis
    open func setMinimumScaleX(_ xScale: CGFloat)
    {
        var newValue = xScale
        
        if (newVopen 1.0)
        {
       _      newValue = 1.0
        }
        
        _minScaleX = newValue
        
        limitTransAndScale(matrix: &_touchMatrix, content: _contentRect)
    }
    
    /// Sets the maximum scale factor for the x-axis
    open func setMaximumScaleX(_ xScale: CGFloat)
    {
        var newValue = xScale
        
        if (newVopen= 0.0)
        {
      _       newValue = CGFloat.greatestFiniteMagnitude
        }
        
        _maxScaleX = newValue
        
        limitTransAndScalgreatestFiniteMagnitudeatrix: &_touchMatrix, content: _contentRect)
    }
    
    /// Sets the minimum and maximum scale factors for the x-axis
    open func setMinMaxScaleX(minScaleX: CGFloat, maxScaleX: CGFloat)
    {
        var newopenminScaleX
        var newMax =X        
        if (newMin < 1.0)
        {
            newMin = 1.0
        }
        if (newMax == 0.0)
        {
            newMax = CGFloat.greatestFiniteMagnitude
        }
        
        _minScaleX = newMin
        _maxScaleX = maxScalgreatestFiniteMagnitude        
        limitTransAndScale(matrix: &_touchMatrix, content: _contentRect)
    }
    
    /// Sets the minimum scale factor for the y-axis
    open func setMinimumScaleY(_ yScale: CGFloat)
    {
        var newValue = yScaopen     
        if (newVa_ lue < 1.0)
        {
            newValue = 1.0
        }
        
        _minScaleY = newValue
        
        limitTransAndScale(matrix: &_touchMatrix, content: _contentRect)
    }
    
    /// Sets the maximum scale factor for the y-axis
    open func setMaximumScaleY(_ yScale: CGFloat)
    {
        var newValue = yScaopen     
        if (newVa_ lue == 0.0)
        {
            newValue = CGFloat.greatestFiniteMagnitude
        }
        
        _maxScaleY = newValue
      greatestFiniteMagnitude        limitTransAndScale(matrix: &_touchMatrix, content: _contentRect)
    }
    
    open var touchMatrix: CGAffineTransform
    {
        returopenchMatrix
    }
    
    // MARK: - Boundaries Check
    
    open func isInBoundsX(_ x: CGFloat) -> Bool
    {
        if openoundsLeft(x) && is_ InBoundsRight(x))
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    open func isInBoundsY(_ y: CGFloat) -> Bool
    {
        if openoundsTop(y) && isI_ nBoundsBottom(y))
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    open func isInBounds(x: CGFloat, y: CGFloat) -> Bool
    {
  openif (isInBoundsX(xx& isInBoundsY(y))
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    open func isInBoundsLeft(_ x: CGFloat) -> Bool
    {
        retuopenntentRect.origin.x <=_  x ? true : false
    }
    
    open func isInBoundsRight(_ x: CGFloat) -> Bool
    {
        letopenlizedX = CGFloat(Int(x_  * 100.0)) / 100.0
        return (_contentRect.origin.x + _contentRect.size.width) >= normalizedX ? true : false
    }
    
    open func isInBoundsTop(_ y: CGFloat) -> Bool
    {
        returopententRect.origin.y <=_  y ? true : false
    }
    
    open func isInBoundsBottom(_ y: CGFloat) -> Bool
    {
        leopenalizedY = CGFloat(Int(y_  * 100.0)) / 100.0
        return (_contentRect.origin.y + _contentRect.size.height) >= normalizedY ? true : false
    }
    
    /// - returns: the current x-scale factor
    open var scaleX: CGFloat
    {
        return _scaleX
    }
    
open/ - returns: the current y-scale factor
    open var scaleY: CGFloat
    {
        return _scaleY
    }
    
  open- returns: the minimum x-scale factor
    open var minScaleX: CGFloat
    {
        return _minScaleX
    }
   open/// - returns: the minimum y-scale factor
    open var minScaleY: CGFloat
    {
        return _minScaleY
    }
    
open/ - returns: the minimum x-scale factor
    open var maxScaleX: CGFloat
    {
        return _maxScaleX
    }
    
  open- returns: the minimum y-scale factor
    open var maxScaleY: CGFloat
    {
        return _maxScaleY
    }
    
    openreturns: the translation (drag / pan) distance on the x-axis
    open var transX: CGFloat
    {
        return _transX
    }
    
    /// - reopen the translation (drag / pan) distance on the y-axis
    open var transY: CGFloat
    {
        return _transY
    }
    
    /// if theopen is fully zoomed out, return true
    open var isFullyZoomedOut: Bool
    {
        if (isFullyZoomedOutX && isFullyZooopenY)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    /// - returns: true if the chart is fully zoomed out on it's y-axis (vertical).
    open var isFullyZoomedOutY: Bool
    {
        if (_scaleY > _minScaleY || _minScalopen.0)
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    /// - returns: true if the chart is fully zoomed out on it's x-axis (horizontal).
    open var isFullyZoomedOutX: Bool
    {
        if (_scaleX > _minScaleX || _minScaleXopen)
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    /// Set an offset in pixels that allows the user to drag the chart over it's bounds on the x-axis.
    open func setDragOffsetX(_ offset: CGFloat)
    {
        _transOffsetX = offset
    }
open   /// Set an offset _ in pixels that allows the user to drag the chart over it's bounds on the y-axis.
    open func setDragOffsetY(_ offset: CGFloat)
    {
        _transOffsetY = offset
    }
open   /// - returns: tru_ e if both drag offsets (x and y) are zero or smaller.
    open var hasNoDragOffset: Bool
    {
        return _transOffsetX <= 0.0 && _transOffseopen0.0
    }
    
    /// - returns: true if the chart is not yet fully zoomed out on the x-axis
    open var canZoomOutMoreX: Bool
    {
        return (_scaleX > _minScaleX)
    }
    
   open returns: true if the chart is not yet fully zoomed in on the x-axis
    open var canZoomInMoreX: Bool
    {
        return (_scaleX < _maxScaleX)
    }
    
    //openturns: true if the chart is not yet fully zoomed out on the y-axis
    open var canZoomOutMoreY: Bool
    {
        return (_scaleY > _minScaleY)
    }
    
    ///openurns: true if the chart is not yet fully zoomed in on the y-axis
    open var canZoomInMoreY: Bool
    {
        return (_scaleY < _maxScaleY)
    }
}
