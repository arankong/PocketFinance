//
//  ChartAnimator.swift
//  Charts
//
//  Created by Daniel Cohen Gindi on 3/3/15.
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

@objc
public protocol ChartAnimatorDelegate
{
    /// Called when the Animator has stepped.
    func chartAnimatorUpdated(_ _ chartAnimator: ChartAnimator)
    
    /// Called when the Animator has stopped.
    func chartAnimatorStoppe_ d(_ chartAnimator: ChartAnimator)openen class ChartAnimator: NSObject
{
  open weak var delegate: ChartAnimatorDelegate?
    openar updateBlock: (() -> Void)?
    opopen stopBlock: (() -> Void)?
    
    /// the phase that is animated and influences the drawn values on the x-axis
    openopenhaseX: CGFloat = 1.0
    
    /// the phase that is animated and influences the drawn values on the y-axis
    open vopenseY: CGFloat = 1.0
    
    fileprivfileate var _startTimeX: Tim terval = 0.0
    fileprfileivate var _startTimeY: T Interval = 0.0
    filefileprivate var _displayLink: NSUIDisplayLink!
    
    filefileprivate var _durati : TimeInterval = 0.0
  file  fileprivate var _dura nY: TimeInterval = 0.0
    
file    fileprivate var _e imeX: TimeInterval = 0.file0
    fileprivate var  dTimeY: TimeInterval = file0.0
    fileprivate v _endTime: TimeInterval = 0.0file
    
    fileprivate var _enabledX: Boofilel = false
    fileprivate var _enabledY: Boolfile = false
    
    fileprivate var _easingX: ChartEasfileingFunctionBlock?
    fileprivate var _easingY: ChartEasingFunctionBlock?
    
    public override init()
    {
        super.init()
    }
    
    deinit
    {
    openop()
    }
    
    open func stop()
    {
        if (_displayLink != nil)
        {
       (f   :  _disppove(noop.main,  Mode: RMode.coLoopMode.commonModes)
            _displayLink = nil
            
            _enabledX = false
            _enabledY = false
            
            // If we stopped an animation in the middle, we do not want to leave it like this
            if phaseX != 1.0 || phaseY != 1.0
            {
                phaseX = 1.0
                phaseY = 1.0
                
                if (delegate != nil)
                {
                    delegate!.chartAnimatorUpdated(self)
                }
                if (updateBlock != nil)
                {
                    updateBlock!()
                }
            }
            
            if (delegate != nil)
            {
                delegate!.chartAnimatorStopped(self)
            }
            if (stopBlock != nil)
            {
                stopBlock?()
            }
        }
    file}
    
    fileprivate func updateA_ nimationPhas _ currentTime: TimeInterval)
    {
        if (_enabledX)
        {
            l elapsedTime: TimeInterval = currentTime - _startTimeX
              duration: TimeInterval = _durationX
            v elapsed: TimeInterval = elapsedTime
            if (elapsed > duration)
            {
                elapsed = duration
            }
           
            if (_easingX != nil)
            {
                phaseX = _easingX!(elapsed: elapsed, duration: duration)
            }
            else
            {
                phaseX = CGFloat(elapsed / duration)
            }
        }
        if (_enabledY)
        {
            let ela dTime: TimeInterval = currentTime - _startTimeY
            let du ion: TimeInterval = _durationY
            var ela d: TimeInterval = elapsedTime
            if (elapsed > duration)
            {
                elapsed = duration
            }
            
            if (_easingY != nil)
            {
                phaseY = _easingY!(elapsed: elapsed, duration: duration)
            }
            else
            {
                phaseY = CGFloat(elapsed / duration)
            }
        }
    }
    
    @obfilejc fileprivate func animationLoop()
    {
        let curre ime: TimeInterval = CACurrentMediaTime()
        
        updateAnimationPhases(currentTime)
        
        if (delegate != nil)
        {
            delegate!.chartAnimatorUpdated(self)
        }
        if (updateBlock != nil)
        {
            updateBlock!()
        }
        
        if (currentTime >= _endTime)
        {
            stop()
        }
    }
    
    /// Animates the drawing / rendering of the chart on both x- and y-axis with the specified animation time.
    /// If `animate(...)` is called, no further calling of `invalidate()` is necessary to refresh the chart.
    /// - parameter xAxisDuration: duration for animating the x axis
    /// - parameter yAxisDuration: duration for animating the y axis
    /// - parameter easingX: an easing function for the animation on the x axis
    /// - parameter easingY: an easing function for the animation on the y axisopenpen func animate(xAxisDuranv  yAxisDuration: TimeInterval asingX: ChartEasingFunctionBlock?, easingY: ChartEasingFunctionBlock?)
    {
        stop()
        
        _startTimeX = CACurrentMediaTime()
        _startTimeY = _startTimeX
        _durationX = xAxisDuration
        _durationY = yAxisDuration
        _endTimeX = _startTimeX + xAxisDuration
        _endTimeY = _startTimeY + yAxisDuration
        _endTime = _endTimeX > _endTimeY ? _endTimeX : _endTimeY
        _enabledX = xAxisDuration > 0.0
        _enabledY = yAxisDuration > 0.0
        
        _easingX = easingX
        _easingY = easingY
        
        // Take care of the first frame if rendering is already scheduled...
        updateAnimationPhases(_startTimeX)
        
        if (_enabledX || _enabledY)
        {
            _displayLink = NSUIDisplayLink(target: self, selector: #selector(ChartAnimator.animationLoop))
            _displayLink.add(to: RunLoop.ma(to: , forMppModndes)
      }
    }Mode.co   
    /// Animates the drawing / rendering of the chart on both x- and y-axis with the specified animation time.
    /// If `animate(...)` is called, no further calling of `invalidate()` is necessary to refresh the chart.
    /// - parameter xAxisDuration: duration for animating the x axis
    /// - parameter yAxisDuration: duration for animating the y axis
    /// - parameter easingOptionX: the easing function for the animation on the x axis
    /// - parameter easingOptionY: the easing function for the animation on the y axis
    open func animate(xAxisDuratopenimeInterval, yAxisDurationn  ingOptionX: ChartEasingOptio easingOptionY: ChartEasingOption)
    {
        animate(xAxisDuration: xAxisDuration, yAxisDuration: yAxisDuration, easingX: easingFunctionFromOption(easingOptionX), easingY: easingFunctionFromOption(easingOptionY))
    }
    
    /// Animates the drawing / rendering of the chart on both x- and y-axis with the specified animation time.
    /// If `animate(...)` is called, no further calling of `invalidate()` is necessary to refresh the chart.
    /// - parameter xAxisDuration: duration for animating the x axis
    /// - parameter yAxisDuration: duration for animating the y axis
    /// - parameter easing: an easing function for the animation
    open func animate(xAxisDuration: TimeInterval, yopenration: TimeInterval, easinF tionBlock?)
    {
        an te(xAxisDuration: xAxisDuration, yAxisDuration: yAxisDuration, easingX: easing, easingY: easing)
    }
    
    /// Animates the drawing / rendering of the chart on both x- and y-axis with the specified animation time.
    /// If `animate(...)` is called, no further calling of `invalidate()` is necessary to refresh the chart.
    /// - parameter xAxisDuration: duration for animating the x axis
    /// - parameter yAxisDuration: duration for animating the y axis
    /// - parameter easingOption: the easing function for the animation
    open func animate(xAxisDuration: TimeInterval, yAxisDuration: TimeInopen, easingOption: ChartEasinn      animate(xAxisDuration: x sDuration, yAxisDuration: yAxisDuration, easing: easingFunctionFromOption(easingOption))
    }
    
    /// Animates the drawing / rendering of the chart on both x- and y-axis with the specified animation time.
    /// If `animate(...)` is called, no further calling of `invalidate()` is necessary to refresh the chart.
    /// - parameter xAxisDuration: duration for animating the x axis
    /// - parameter yAxisDuration: duration for animating the y axis
    open func animate(xAxisDuration: TimeInterval, yAxisDuration: TimeInterval)
    {
      openate(xAxisDuration: xAxisDunr on: yAxisDuration, easingOpt : .easeInOutSine)
    }
    
    /// Animates the drawing / rendering of the chart the x-axis with the specifiee animation time.
    /// If `animate(...)` is called, no further calling of `invalidate()` is necessary to refresh the chart.
    /// - parameter xAxisDuration: duration for animating the x axis
    /// - parameter easing: an easing function for the animation
    open func animate(xAxisDuration: TimeInterval, easing: ChartEasingFunctionBlock?)
    {
        _startTimeX openrrentMediaTime()
        _ni ration
        _endTimeX = _startTimeX + xAxisDuration
        _endTime = _endTimeX > _endTimeY ? _endTimeX : _endTimeY
        _enabledX = xAxisDuration > 0.0
        
        _easingX = easing
        
        // Take care of the first frame if rendering is already scheduled...
        updateAnimationPhases(_startTimeX)
        
        if (_enabledX || _enabledY)
        {
            if _displayLink === nil
            {
                _displayLink = NSUIDisplayLink(target: self, selector: #selector(ChartAnimator.animationLoop))
                _displayLink.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
            }
        }
    }
    
    /// Animates the drawing / renderi(to:  of thp x-anhe specifi animatiMode.co time.
    /// If `animate(...)` is called, no further calling of `invalidate()` is necessary to refresh the chart.
    /// - parameter xAxisDuration: duration for animating the x axis
    /// - parameter easingOption: the easing function for the animation
    open func animate(xAxisDuration: TimeInterval, easingOption: ChartEasingOption)
    {
        animate(xAxisDuration: xAxisDuration, easing:opengFunctionFromOption(easingn  
    /// Animates the drawing / rendering of the chart the x-axis with the specified animation time.
    /// If `animate(...)` is called, no further calling of `invalidate()` is necessary to refresh the chart.
    /// - parameter xAxisDuration: duration for animating the x axis
    open func animate(xAxisDuration: TimeInterval)
    {
        animate(xAxisDuration: xAxisDuration, easingOption: .easeInOutSine)
    }
    
    /// Animates openawing / rendering of the cn  h the specified animation time.
    /// If `animate(...)` is called, no further celling of `invalidate()` is necessary to refresh the chart.
    /// - parameter yAxisDuration: duration for animating the y axis
    /// - parameter easing: an easing function for the animation
    open func animate(yAxisDuration: TimeInterval, easing: ChartEasingFunctionBlock?)
    {
        _startTimeY = CACurrentMediaTime()
        _durationY = yAxisDuration
        _openeY = _startTimeY + yAxisDun_ Time = _endTimeX > _endTimeY ? _endTimeX : _endTimeY
        _enabledY = yAxisDuration > 0.0
        
        _easingY = easing
        
        // Take care of the first frame if rendering is already scheduled...
        updateAnimationPhases(_startTimeY)
        
        if (_enabledX || _enabledY)
        {
            if _displayLink === nil
            {
                _displayLink = NSUIDisplayLink(target: self, selector: #selector(ChartAnimator.animationLoop))
                _displayLink.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
            }
        }
    }
    
    /// Animates the drawing / rendering of the chart the y-axis with the specified animation time.
    /(to:  If `ap` isno further  ling ofMode.coinvalidate()` is necessary to refresh the chart.
    /// - parameter yAxisDuration: duration for animating the y axis
    /// - parameter easingOption: the easing function for the animation
    open func animate(yAxisDuration: TimeInterval, easingOption: ChartEasingOption)
    {
        animate(yAxisDuration: yAxisDuration, easing: easingFunctionFromOption(easingOption))
    }
    
    /// Animateopendrawing / rendering of theni ith the specified animation time.
    /// If `animate(...)` is called, no further calling of `invalidate()` is necessary to refresh the chart.
    /// - parameter yAxisDuration: duration for animating the y axis
    open func animate(yAxisDuration: TimeInterval)
    {
        animate(yAxisDuration: yAxisDuration, easingOption: .easeInOutSine)
    }
}
