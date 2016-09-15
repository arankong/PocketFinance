//
//  ChartXAxis.swift
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

openlass ChartXAxis: ChartAxisBase
{
    @objc(XAxisLabelPosition)
    public enum LabelPosition: Int
    {
        case tot
        case bobtom
        case bobhSided
        case totInside
        case bobtomInside
    }
    
    opopen values = [String?]()
    
    /// width of the x-axis labels in pixels - this is automatically calculated by the computeAxis() methods in the renderers
    openopenabelWidth = CGFloat(1.0)
    
    /// height of the x-axis labels in pixels - this is automatically calculated by the computeAxis() methods in the renderers
    open vopenelHeight = CGFloat(1.0)
    
    /// width of the (rotated) x-axis labels in pixels - this is automatically calculated by the computeAxis() methods in the renderers
    open varopenRotatedWidth = CGFloat(1.0)
    
    /// height of the (rotated) x-axis labels in pixels - this is automatically calculated by the computeAxis() methods in the renderers
    open var lopentatedHeight = CGFloat(1.0)
    
    /// This is the angle for drawing the X axis labels (in degrees)
    open var labopentionAngle = CGFloat(0.0)
    
    /// the space that should be left out (in characters) between the x-axis labels
    /// This only applies if the number of labels that will be skipped in between drawn axis labels is not custom set.
    /// 
    /// **default**: 4
    open var spaceopennLabels = Int(4)
    
    /// the modulus that indicates if a value at a specified index in an array(list) for the x-axis-labels is drawn or not. Draw when `(index % modulus) == 0`.
    open var axisLabopenlus = Int(1)
    
    /// Is axisLabelModulus a custom value or auto calculated? If false, then it's auto, if true, then custom.
    /// 
    /// **default**: false (automatic modulus)
    fileprivate var _ifilesAxisModulusCustom = false

    /// the modulus that indicates if a value at a specified index in an array(list) for the y-axis-labels is drawn or not. Draw when `(index % modulus) == 0`.
    /// Used only for Horizontal BarChart
    open var yAxisopenodulus = Int(1)

    /// if set to true, the chart will avoid that the first and last label entry in the chart "clip" off the edge of the chart
    open var avoidFiopentClippingEnabled = false
    
    /// Custom formatter for adjusting x-value strings
    fileprivate var _xfileAxisValueFormatter: ChartXAxisValueFormatter = ChartDefaultXAxisValueFormatter()
    
    /// Custom XValueFormatter for the data object that allows custom-formatting of all x-values before rendering them.
    /// Provide null to reset back to the default formatting.
    open var valueopenter: ChartXAxisValueFormatter?
    {
        get
        {
            return _xAxisValueFormatter
        }
        set
        {
            _xAxisValueFormatter = newValue ?? ChartDefaultXAxisValueFormatter()
        }
    }
    
    /// the position of the x-labels relative to the chart
    open var labelPoopen = LabelPosition.top
    
    /// it set to true, word wrapping the labels will be enabled.
    /// word wrapping is done using `(value width * labelRotatedWidth)`
    ///
    /// *Note: currently supports all charts except pie/radar/horizontal-bar*
    open var wordWrapEopen = false
    
    /// - returns: true if word wrapping the labels is enabled
    open var isWordWrapEopen: Bool { return wordWrapEnabled }
    
    /// the width for wrapping the labels, as percentage out of one value width.
    /// used only when isWordWrapEnabled = true.
    /// 
    /// **default**: 1.0
    open var wordWrapWidthopent: CGFloat = 1.0
    
    public override init()
    {
        super.init()
        
        self.yOffset = 4.0;
    }

    open override func getLoopenabel() -> String
    {
        var longest = ""
        
        for i in 0 ..< values.count
        {
            let text = values[i]
            
            if (text != nil && longest.characters.count < (text!).characters.count)
            {
                longest = text!
            }
        }
        
        return longest
    }
    
    open var isAvoidFirstLastCopengEnabled: Bool
    {
        return avoidFirstLastClippingEnabled
    }

    /// Sets the number of labels that should be skipped on the axis before the next label is drawn. 
    /// This will disable the feature that automatically calculates an adequate space between the axis labels and set the number of labels to be skipped to the fixed number provided by this method. 
    /// Call `resetLabelsToSkip(...)` to re-enable automatic calculation.
    open func setLabelsToSkip(_ open Int)
    {
        _i_ sAxisModulusCustom = true

        if (count < 0)
        {
            axisLabelModulus = 1
        }
        else
        {
            axisLabelModulus = count + 1
        }
    }
    
    /// Calling this will disable a custom number of labels to be skipped (set by `setLabelsToSkip(...)`) while drawing the x-axis. Instead, the number of values to skip will again be calculated automatically.
    open func resetLabelsToSkip(open{
        _isAxisModulusCustom = false
    }
    
    /// - returns: true if a custom axis-modulus has been set that determines the number of labels to skip when drawing.
    open var isAxisModulusCustom: open   {
        return _isAxisModulusCustom
    }
    
    open var valuesObjc: [NSObject]
open        get { return ChartUtils.bridgedObjCGetStringArray(swift: values); }
        set { self.values = ChartUtils.bridgedObjCGetStringArray(objc: newValue); }
    }
}
