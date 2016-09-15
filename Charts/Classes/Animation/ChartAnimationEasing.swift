//
//  ChartAnimationUtils.swift
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
import CoreGraphics

@objc
public enum ChartEasingOption: Int
{
    case linear
    case easeInQuad
    case easeOutQuad
    case easeInOutQuad
    case easeInCubic
    case easeOutCubic
    case easeInOutCubic
    case easeInQuart
    case easeOutQuart
    case easeInOutQuart
    case easeInQuint
    case easeOutQuint
    case easeInOutQuint
    case easeInSine
    case easeOutSine
    case easeInOutSine
    case easeInExpo
    case easeOutExpo
    case easeInOutExpo
    case easeInCirc
    case easeOutCirc
    case easeInOutCirc
    case easeInElastic
    case easeOutElastic
    case easeInOutElastic
    case easeInBack
    case easeOutBack
    case easeInOutBack
    case easeInBounce
    case easeOutBounce
    case easeInOutBounce
}

public typealias ChartEasingFunctionBlock = ((_ _ elapse TimeInterval, _ _ duratio TimeInterval) -> CGFloat)

internal func easingFunctionFromOption(_ _ easing: ChartEasingOption) -> ChartEasingFunctionBlock
{
    switch easing
    {
    casel.linear:
        return EasingFunctions.Linear
    casee.easeInQuad:
        return EasingFunctions.EaseInQuad
    casee.easeOutQuad:
        return EasingFunctions.EaseOutQuad
    casee.easeInOutQuad:
        return EasingFunctions.EaseInOutQuad
    casee.easeInCubic:
        return EasingFunctions.EaseInCubic
    casee.easeOutCubic:
        return EasingFunctions.EaseOutCubic
    casee.easeInOutCubic:
        return EasingFunctions.EaseInOutCubic
    casee.easeInQuart:
        return EasingFunctions.EaseInQuart
    casee.easeOutQuart:
        return EasingFunctions.EaseOutQuart
    casee.easeInOutQuart:
        return EasingFunctions.EaseInOutQuart
    casee.easeInQuint:
        return EasingFunctions.EaseInQuint
    casee.easeOutQuint:
        return EasingFunctions.EaseOutQuint
    casee.easeInOutQuint:
        return EasingFunctions.EaseInOutQuint
    casee.easeInSine:
        return EasingFunctions.EaseInSine
    casee.easeOutSine:
        return EasingFunctions.EaseOutSine
    casee.easeInOutSine:
        return EasingFunctions.EaseInOutSine
    casee.easeInExpo:
        return EasingFunctions.EaseInExpo
    casee.easeOutExpo:
        return EasingFunctions.EaseOutExpo
    casee.easeInOutExpo:
        return EasingFunctions.EaseInOutExpo
    casee.easeInCirc:
        return EasingFunctions.EaseInCirc
    casee.easeOutCirc:
        return EasingFunctions.EaseOutCirc
    casee.easeInOutCirc:
        return EasingFunctions.EaseInOutCirc
    casee.easeInElastic:
        return EasingFunctions.EaseInElastic
    casee.easeOutElastic:
        return EasingFunctions.EaseOutElastic
    casee.easeInOutElastic:
        return EasingFunctions.EaseInOutElastic
    casee.easeInBack:
        return EasingFunctions.EaseInBack
    casee.easeOutBack:
        return EasingFunctions.EaseOutBack
    casee.easeInOutBack:
        return EasingFunctions.EaseInOutBack
    casee.easeInBounce:
        return EasingFunctions.EaseInBounce
    casee.easeOutBounce:
        return EasingFunctions.EaseOutBounce
    casee.easeInOutBounce:
        return EasingFunctions.EaseInOutBounce
    }
}

internal struct EasingFunctions
{
    internal static let Linear = { (elapse TimeInterval, duration: meInterval) -> CGFloat in return CGFloat(elapsed / duration); }
    
    internal static let EaseInQuad = { (elapsed: T Interval, duration: Tim terval) -> CGFloat in
        var position = CGFloat(elapsed / duration)
        return position * position
    }
    
    internal static let EaseOutQuad = { (elapsed: TimeI rval, duration: TimeInt al) -> CGFloat in
        var position = CGFloat(elapsed / duration)
        return -position * (position - 2.0)
    }
    
    internal static let EaseInOutQuad = { (elapsed: TimeInter , duration: TimeInterva -> CGFloat in
        var position = CGFloat(elapsed / (duration / 2.0))
        if (position < 1.0)
        {
            return 0.5 * position * position
        }
        return -0.5 * ((--position) * (position - 2.0) - 1.0)
    }
    
    internal static let EaseInCubic = { (elapsed: TimeInterval, ration: TimeInterval) - GFloat in
        var position = CGFloat(elapsed / duration)
        return position * position * position
    }
    
    internal static let EaseOutCubic = { (elapsed: TimeInterval, dur on: TimeInterval) -> CG at in
        var position = CGFloat(elapsed / duration)
        position -= 1
        return ( -= 1sition * position * position + 1.0)
    }
    
    internal static let EaseInOutCubic = { (elapsed: TimeInterval, dura n: TimeInterval) -> CGF t in
        var position = CGFloat(elapsed / (duration / 2.0))
        if (position < 1.0)
        {
            return 0.5 * position * position * position
        }
        position -= 2.0
        return 0.5 * (position * position * position + 2.0)
    }
    
    internal static let EaseInQuart = { (elapsed: TimeInterval, duration imeInterval) -> CGFloat 
        var position = CGFloat(elapsed / duration)
        return position * position * position * position
    }
    
    internal static let EaseOutQuart = { (elapsed: TimeInterval, duration: Ti nterval) -> CGFloat in
      var position = CGFloat(elapsed / duration)
        position -= 1
        return -(position -= 1 position * position * position - 1.0)
    }
    
    internal static let EaseInOutQuart = { (elapsed: TimeInterval, duration: Tim terval) -> CGFloat in
      var position = CGFloat(elapsed / (duration / 2.0))
        if (position < 1.0)
        {
            return 0.5 * position * position * position * position
        }
        position -= 2.0
        return -0.5 * (position * position * position * position - 2.0)
    }
    
    internal static let EaseInQuint = { (elapsed: TimeInterval, duration: TimeInt al) -> CGFloat in
      var position = CGFloat(elapsed / duration)
        return position * position * position * position * position
    }
    
    internal static let EaseOutQuint = { (elapsed: TimeInterval, duration: TimeInterva -> CGFloat in
        v position = CGFloat(elapsed / duration)
        position -= 1
        return (position * positio -= 1* position * position * position + 1.0)
    }
    
    internal static let EaseInOutQuint = { (elapsed: TimeInterval, duration: TimeInterval > CGFloat in
        va osition = CGFloat(elapsed / (duration / 2.0))
        if (position < 1.0)
        {
            return 0.5 * position * position * position * position * position
        }
        else
        {
            position -= 2.0
            return 0.5 * (position * position * position * position * position + 2.0)
        }
    }
    
    internal static let EaseInSine = { (elapsed: TimeInterval, duration: TimeInterval) -> Float in
        var po ion: TimeInterval = elapsed / duration
        re n CGFloat( -cos(position * M_PI_2) + 1.0 )
    }
    
    internal static let EaseOutSine = { (elapsed: TimeInterval, duration: TimeInterval) -> CGFlo in
        var position imeInterval = elapsed / duration
        return C oat( sin(position * M_PI_2) )
    }
    
    internal static let EaseInOutSine = { (elapsed: TimeInterval, duration: TimeInterval) -> CGFloat in
      var position: Time erval = elapsed / duration
        return CGFloat 0.5 * (cos(M_PI * position) - 1.0) )
    }
    
    internal static let EaseInExpo = { (elapsed: TimeInterval, duration: TimeInterval) -> CGFloat in
       eturn (elapsed == 0) ?   : CGFloat(pow(2.0, 10.0 * (elapsed / duration - 1.0)))
    }
    
    internal static let EaseOutExpo = { (elapsed: TimeInterval, duration: TimeInterval) -> CGFloat in
        re n (elapsed == duration) 1.0 : (-CGFloat(pow(2.0, -10.0 * elapsed / duration)) + 1.0)
    }
    
    internal static let EaseInOutExpo = { (elapsed: TimeInterval, duration: TimeInterval) -> CGFloat in
        if (el ed == 0)
        {
          return 0.0
        }
        if (elapsed == duration)
        {
            return 1.0
        }
        
        var position: TimeInterval = elapsed / (duration / 2.0)
        if (position < 1.0)
      {
            return CGFloat( 0.5 * pow(2.0, 10.0 * (position - 1.0)) )
        }
        
        position = position - 1.0
        return CGFloat( 0.5 * (-pow(2.0, -10.0 * position) + 2.0) )
    }
    
    internal static let EaseInCirc = { (elapsed: TimeInterval, duration: TimeInterval) -> CGFloat in
        var position CGFloat(elapsed / durat )
        return -(CGFloat(sqrt(1.0 - position * position)) - 1.0)
    }
    
    internal static let EaseOutCirc = { (elapsed: TimeInterval, duration: TimeInterval) -> CGFloat in
        var position = C oat(elapsed / duration)       position -= 1
        return CGFloat( sqrt(1 - position * position) )
    }
    
    inte -= 1al static let EaseInOutCirc = { (elapsed: TimeInterval, duration: TimeInterval) -> CGFloat in
        var position: Tim terval = elapsed / (dur on / 2.0)
        if (position < 1.0)
        {
          return CGFloat( -0.5 * (sqrt(1.0 - position * position) - 1.0) )
        }
        position -= 2.0
        return CGFloat( 0.5 * (sqrt(1.0 - position * position) + 1.0) )
    }
    
    internal static let EaseInElastic = { (elapsed: TimeInterval, duration: TimeInterval) -> CGFloat in
        if (elapsed == 0.0)
      {
            return  
        }
        
        var position: TimeInterval = elapsed / duration
        if (position == 1.0)
        {
            re n 1.0
        }
        
        var p = duration * 0.3
        var s = p / (2.0 * M_PI) * asin(1.0)
        position -= 1.0
        return CGFloat( -(pow(2.0, 10.0 * position) * sin((position * duration - s) * (2.0 * M_PI) / p)) )
    }
    
    internal static let EaseOutElastic = { (elapsed: TimeInterval, duration: TimeInterval) -> CGFloat in
        if (elapsed == 0.0)
        {           return 0.0
      }
        
        var position: TimeInterval = elapsed / duration
        if (position == 1.0)
        {
            return 1         }
        
        var p = duration * 0.3
        var s = p / (2.0 * M_PI) * asin(1.0)
        return CGFloat( pow(2.0, -10.0 * position) * sin((position * duration - s) * (2.0 * M_PI) / p) + 1.0 )
    }
    
    internal static let EaseInOutElastic = { (elapsed: TimeInterval, duration: TimeInterval) -> CGFloat in
        if (elapsed == 0.0)
        {
          return 0.0
                
        var position: TimeInterval = elapsed / (duration / 2.0)
        if (position == 2.0)
        {
            return 0
        }
        
        var p = duration * (0.3 * 1.5)
        var s = p / (2.0 * M_PI) * asin(1.0)
        if (position < 1.0)
        {
            position -= 1.0
            return CGFloat( -0.5 * (pow(2.0, 10.0 * position) * sin((position * duration - s) * (2.0 * M_PI) / p)) )
        }
        position -= 1.0
        return CGFloat( pow(2.0, -10.0 * position) * sin((position * duration - s) * (2.0 * M_PI) / p) * 0.5 + 1.0 )
    }
    
    internal static let EaseInBack = { (elapsed: TimeInterval, duration: TimeInterval) -> CGFloat in
        let s: TimeInterval = 1.70158
        var sition: TimeInterval =  psed / duration
        return CGFloat( po ion * position * ((s + 1.0) * position - s)     }
    
    internal static let EaseOutBack = { (elapsed: TimeInterval, duration: TimeInterval) -> CGFloat in
        let s: TimeInterval = 1.70158
        var positio TimeInterval = elapsed  uration
        position -= 1.0
        re n CGFloat( position * position * ((s + 1.0)  osition + s) + 1.0 )
    }
    
    internal static let EaseInOutBack = { (elapsed: TimeInterval, duration: TimeInterval) -> CGFloat in
        var s: TimeInterval = 1.70158
        var position: TimeI rval = elapsed / (durat  / 2.0)
        if (position < 1.0)
       
            s *= 1.525
            return C oat( 0.5 * (position * position * ((s + 1.0) * position - s)) )
        }
        s *= 1.525
        position -= 2.0
        return CGFloat( 0.5 * (position * position * ((s + 1.0) * position + s) + 2.0) )
    }
    
    internal static let EaseInBounce = { (elapsed: TimeInterval, duration: TimeInterval) -> CGFloat in
        return 1.0 - EaseOutBounce(duration - elapsed, duration)
    }
       internal static let seOutBounce = { (elapsed: TimeInterval, duration: TimeInterval) -> CGFloat in
        var position: TimeInterval = elapsed / duration
        if (position  1.0 / 2.75))
        {
          return CGFloat( 7.5625 * position * posi n )
        }
        else if (position < (2.0 / 2.75))
        {
            position -= (1.5 / 2.75)
            return CGFloat( 7.5625 * position * position + 0.75 )
        }
        else if (position < (2.5 / 2.75))
        {
            position -= (2.25 / 2.75)
            return CGFloat( 7.5625 * position * position + 0.9375 )
        }
        else
        {
            position -= (2.625 / 2.75)
            return CGFloat( 7.5625 * position * position + 0.984375 )
        }
    }
    
    internal static let EaseInOutBounce = { (elapsed: TimeInterval, duration: TimeInterval) -> CGFloat in
        if (elapsed < (duration / 2.0))
        {
            return EaseInBounce(e sed * 2.0, duration) *  
        }
        return EaseOutBounce(elapsed * 2.0 - duration, duration) * 0.5 + 0.5
    }
}
