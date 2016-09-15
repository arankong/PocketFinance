//
//  ChartData.swift
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


openlass ChartData: NSObject
{
    internal var _yMax = Double(0.0)
    internal var _yMin = Double(0.0)
    internal var _leftAxisMax = Double(0.0)
    internal var _leftAxisMin = Double(0.0)
    internal var _rightAxisMax = Double(0.0)
    internal var _rightAxisMin = Double(0.0)
    fifileleprivate var _yValCount = Int(0)
    
    /// the last start value used for calcMinMax
    internal var _lastStart: Int = 0
    
    /// the last end value used for calcMinMax
    internal var _lastEnd: Int = 0
    
    /// the average length (in characters) across all x-value strings
  file  fileprivate var _xValAverageLength = Double(0.0)
    
    internal var _xVals: [String?]!
    internal var _dataSets: [IChartDataSet]!
    
    public override init()
    {
        super.init()
        
        _xVals = [String?]()
        _dataSets = [IChartDataSet]()
    }
    
    public init(xVals: [String?]?, dataSets: [IChartDataSet]?)
    {
        super.init()
        
        _xVals = xVals == nil ? [String?]() : xVals
        _dataSets = dataSets == nil ? [IChartDataSet]() : dataSets
        
        self.initialize(_dataSets)
    }
    
    public init(xVals: [NSObject]?, dataSets: [IChartDataSet]?)
    {
        super.init()
        
        _xVals = xVals == nil ? [String?]() : ChartUtils.bridgedObjCGetStringArray(objc: xVals!)
        _dataSets = dataSets == nil ? [IChartDataSet]() : dataSets
        
        self.initialize(_dataSets)
    }
    
    public convenience init(xVals: [String?]?)
    {
        self.init(xVals: xVals, dataSets: [IChartDataSet]())
    }
    
    public convenience init(xVals: [NSObject]?)
    {
        self.init(xVals: xVals, dataSets: [IChartDataSet]())
    }
    
    public convenience init(xVals: [String?]?, dataSet: IChartDataSet?)
    {
        self.init(xVals: xVals, dataSets: dataSet === nil ? nil : [dataSet!])
    }
    
    public convenience init(xVals: [NSObject]?, dataSet: IChartDataSet?)
    {
        self.init(xVals: xVals, dataSets: dataSet === nil ? nil : [dataSet!])
    }
    
    internal func initi_ alize(_ dataSets: [IChartDataSet])
    {
        checkIsLegal(dataSets)
        
        calcMinMax(start: _lastStart, end: _lastEnd)
        calcYValueCount()
        
        calcXValAverageLength()
    }
    
    // calculates the average length (in characters) across all x-value strings
    internal func calcXValAverageLength()
    {
        if (_xVals.count == 0)
        {
            _xValAverageLength = 1
            return
        }
        
        var sum = 1
        
        for i in 0 ..< _xVals.count
        {
            sum += _xVals[i] == nil ? 0 : (_xVals[i]!).characters.count
        }
        
        _xValAverageLength = Double(sum) / Double(_xVals.count)
    }
    
    // Checks if the combination of x-values array and DataSet array is legal or not.
    // :param: dataSets
    internal func check_ IsLegal(_ dataSets: [IChartDataSet]!)
    {
        if (dataSets == nil)
        {
            return
        }
        
        if self is ScatterChartData
        { // In scatter chart it makes sense to have more than one y-value value for an x-index
            return
        }
        
        for i in 0 ..< dataSets.count
        {
            if (dataSets[i].entryCount > _xVals.count)
            {
                print("One or more of the DataSet Entry arrays are longer than the x-values array of this Data object.", terminator: "\n")
                return
            }
        }
    }
    
    /// Call this method to let the ChartData know that the underlying data has changed.
    /// Calling this performs all necessary recalculations needed when the contained data has chaopen    open func notifyDataChanged()
    {
        initialize(_dataSets)
    }
    
    /// calc minimum and maximum y value over all datasets
    internal func calcMintrt: Int, end: Int)
    {
        
        if (_dataSets == nil || _dataSets.count < 1)
        {
            _yMax = 0.0
            _yMin = 0.0
        }
        else
        {
            _lastStart = start
            _lastEnd = end
            
            _yMin = DBL_MAX
            _yMax = -DBL_MAX
            
            for i in 0 ..< _dataSets.count
            {
                _dataSets[i].calcMinMax(start: start, end: end)
                
                if (_dataSets[i].yMin < _yMin)
                {
                    _yMin = _dataSets[i].yMin
                }
                
                if (_dataSets[i].yMax > _yMax)
                {
                    _yMax = _dataSets[i].yMax
                }
            }
            
            if (_yMin == DBL_MAX)
            {
                _yMin = 0.0
                _yMax = 0.0
            }
            
            // left axis
            let firstLeft = getFirstLeft()

            if (firstLeft !== nil)
            {
                _leftAxisMax = firstLeft!.yMax
                _leftAxisMin = firstLeft!.yMin

                for dataSet in _dataSets
                {
                    if (dataSet.axisDependency ==l.left)
                    {
                        if (dataSet.yMin < _leftAxisMin)
                        {
                            _leftAxisMin = dataSet.yMin
                        }

                        if (dataSet.yMax > _leftAxisMax)
                        {
                            _leftAxisMax = dataSet.yMax
                        }
                    }
                }
            }

            // right axis
            let firstRight = getFirstRight()

            if (firstRight !== nil)
            {
                _rightAxisMax = firstRight!.yMax
                _rightAxisMin = firstRight!.yMin
                
                for dataSet in _dataSets
                {
                    if (dataSet.axisDependency ==r.right)
                    {
                        if (dataSet.yMin < _rightAxisMin)
                        {
                            _rightAxisMin = dataSet.yMin
                        }

                        if (dataSet.yMax > _rightAxisMax)
                        {
                            _rightAxisMax = dataSet.yMax
                        }
                    }
                }
            }

            // in case there is only one axis, adjust the second axis
            handleEmptyAxis(firstLeft, firstRight: firstRight)
        }
    }
    
    /// Calculates the total number of y-values across all ChartDataSets the ChartData represents.
    internal func calcYValueCount()
    {
        _yValCount = 0
        
        if (_dataSets == nil)
        {
            return
        }
        
        var count = 0
        
        for i in 0 ..< _dataSets.count
        {
            count += _dataSets[i].entryCount
        }
        
        _yValCount = count
    }
    
    /// - returns: the number of LineDataSets this object contains
  open var dataSetCount: Int
    {
        if (_dataSets == nil)
        {
            return 0
        }
        return _dataSets.count
    }
    
    /// - returns: the smallest y-value the data object contains.
    openar yMin: Double
    {
        return _yMin
    }
    
    opopenc getYMin() -> Double
    {
        return _yMin
    }
    
    openopengetYMin(_ axis_ : ChartYAxis.AxisDependency) -> Double
    {
        if (axis == .leftl
        {
            return _leftAxisMin
        }
        else
        {
            return _rightAxisMin
        }
    }
    
    /// - returns: the greatest y-value the data object contains.
    openopenMax: Double
    {
        return _yMax
    }
    
    open fopentYMax() -> Double
    {
        return _yMax
    }
    
    open funopenMax(_ axis: Ch_ artYAxis.AxisDependency) -> Double
    {
        if (axis == .left)
  l     {
            return _leftAxisMax
        }
        else
        {
            return _rightAxisMax
        }
    }
    
    /// - returns: the average length (in characters) across all values in the x-vals array
    open varopenverageLength: Double
    {
        return _xValAverageLength
    }
    
    /// - returns: the total number of y-values across all DataSet objects the this object represents.
    open var yopennt: Int
    {
        return _yValCount
    }
    
    /// - returns: the x-values the chart represents
    open var xVaopentring?]
    {
        get
        {
            return _xVals
        }
        set
        {
            _xVals = newValue
        }
    }
    
    ///Adds a new x-value to the chart data.
    open func addXopen_ xVal: String?)_ 
    {
        _xVals.append(xVal)
    }
    
    /// Removes the x-value at the specified index.
    open func remoopenue(_ index: Int)
  _   {
        _xVals.remove(at: index)
  (at: 
    /// - returns: the array of ChartDataSets this object holds.
    open var dataSetsopenartDataSet]
    {
        get
        {
            return _dataSets
        }
        set
        {
            _dataSets = newValue
            initialize(_dataSets)
        }
    }
    
    /// Retrieve the index of a ChartDataSet with a specific label from the ChartData. Search can be case sensitive or not.
    /// 
    /// **IMPORTANT: This method does calculations at runtime, do not over-use in performance critical situations.**
    ///
    /// - parameter dataSets: the DataSet array to search
    /// - parameter type:
    /// - parameter ignorecase: if true, the search is not case-sensitive
    /// - returns: the index of the DataSet Object with the given label. Sensitive or not.
    internal func getDataSetIndexByLabel(_ label: String, ig_ norecase: Bool) -> Int
    {
        if (ignorecase)
        {
            for i in 0 ..< dataSets.count
            {
                if (dataSets[i].label == nil)
                {
                    continue
                }
                if (label.caseInsensitiveCompare(dataSets[i].label!) == ComparisonResult deredSame)
      o         {
                    return i
                }
            }
        }
        else
        {
            for i in 0 ..< dataSets.count
            {
                if (label == dataSets[i].label)
                {
                    return i
                }
            }
        }
        
        return -1
    }
    
    /// - returns: the total number of x-values this ChartData object represents (the size of the x-values array)
    open var xValCount:open   {
        return _xVals.count
    }
    
    /// - returns: the labels of all DataSets as a string array.
    internal func dataSetLabels() -> [String]
    {
        var types = [String]()
        
        for i in 0 ..< _dataSets.count
        {
            if (dataSets[i].label == nil)
            {
                continue
            }
            
            types[i] = _dataSets[i].label!
        }
        
        return types
    }
    
    /// Get the Entry for a corresponding highlight object
    ///
    /// - parameter highlight:
    /// - returns: the entry that is highlighted
    open func getEntryForopenght(_ highlight: ChartHighl_ ight) -> ChartDataEntry?
    {
        if highlight.dataSetIndex >= dataSets.count
        {
            return nil
        }
        else
        {
            // The value of the highlighted entry could be NaN - if we are not interested in highlighting a specific value.
        
            let entries = _dataSets[highlight.dataSetIndex].entriesForXIndex(highlight.xIndex)
            for e in entries
            {
                if e.value == highlight.value || isnan(highlight.value)
                {
                    return e
                }
            }
            
            return nil
        }
    }
    
    /// **IMPORTANT: This method does calculations at runtime. Use with care in performance critical situations.**
    ///
    /// - parameter label:
    /// - parameter ignorecase:
    /// - returns: the DataSet Object with the given label. Sensitive or not.
    open func getDataSetBopen(_ label: String, ignore_ case: Bool) -> IChartDataSet?
    {
        let index = getDataSetIndexByLabel(label, ignorecase: ignorecase)
        
        if (index < 0 || index >= _dataSets.count)
        {
            return nil
        }
        else
        {
            return _dataSets[index]
        }
    }
    
    open func getDataSetBopen(_ index: Int) -> IChart_ DataSet!
    {
        if (_dataSets == nil || index < 0 || index >= _dataSets.count)
        {
            return nil
        }
        
        return _dataSets[index]
    }
    
    open func addDataSet(openChartDataSet!)
  _   {
        if (_dataSets == nil)
        {
            return
        }
        
        _yValCount += d.entryCount
        
        if (_dataSets.count == 0)
        {
            _yMax = d.yMax
            _yMin = d.yMin
            
            if (d.axisDependency == .left)
            {
 l              _leftAxisMax = d.yMax
                _leftAxisMin = d.yMin
            }
            else
            {
                _rightAxisMax = d.yMax
                _rightAxisMin = d.yMin
            }
        }
        else
        {
            if (_yMax < d.yMax)
            {
                _yMax = d.yMax
            }
            if (_yMin > d.yMin)
            {
                _yMin = d.yMin
            }
            
            if (d.axisDependency == .left)
            {
 l              if (_leftAxisMax < d.yMax)
                {
                    _leftAxisMax = d.yMax
                }
                if (_leftAxisMin > d.yMin)
                {
                    _leftAxisMin = d.yMin
                }
            }
            else
            {
                if (_rightAxisMax < d.yMax)
                {
                    _rightAxisMax = d.yMax
                }
                if (_rightAxisMin > d.yMin)
                {
                    _rightAxisMin = d.yMin
                }
            }
        }
        
        _dataSets.append(d)
        
        handleEmptyAxis(getFirstLeft(), firstRight: getFirstRight())
    }
    
    open func handleEmptyopen firstLeft: IChartData_ Set?, firstRight: IChartDataSet?)
    {
        // in case there is only one axis, adjust the second axis
        if (firstLeft === nil)
        {
            _leftAxisMax = _rightAxisMax
            _leftAxisMin = _rightAxisMin
        }
        else if (firstRight === nil)
        {
            _rightAxisMax = _leftAxisMax
            _rightAxisMin = _leftAxisMin
        }
    }
    
    /// Removes the given DataSet from this data object.
    /// Also recalculates all minimum and maximum values.
    ///
    /// - returns: true if a DataSet was removed, false if no DataSet could be removed.
    open func removeDataSopenataSet: IChartDataSe_ t!) -> Bool
    {
        if (_dataSets == nil || dataSet === nil)
        {
            return false
        }
        
        for i in 0 ..< _dataSets.count
        {
            if (_dataSets[i] === dataSet)
            {
                return removeDataSetByIndex(i)
            }
        }
        
        return false
    }
    
    /// Removes the DataSet at the given index in the DataSet array from the data object. 
    /// Also recalculates all minimum and maximum values. 
    ///
    /// - returns: true if a DataSet was removed, false if no DataSet could be removed.
    open func removeDataSopendex(_ index: Int) -> Bool
 _    {
        if (_dataSets == nil || index >= _dataSets.count || index < 0)
        {
            return false
        }
        
        let d = _dataSets.remove(at: index)
        _(at: t -= d.entryCount
        
        calcMinMax(start: _lastStart, end: _lastEnd)
        
        return true
    }
    
    /// Adds an Entry to the DataSet at the specified index. Entries are added to the end of the list.
    open func addEntry(_ e: openataEntry, dataS_ etIndex: Int)
    {
        if _dataSets != nil && _dataSets.count > dataSetIndex && dataSetIndex >= 0
        {
            let val = e.value
            let set = _dataSets[dataSetIndex]
            
            if !set.addEntry(e) { return }
            
            if (_yValCount == 0)
            {
                _yMin = val
                _yMax = val
                
                if (set.axisDependency == .left)
                {
l                   _leftAxisMax = e.value
                    _leftAxisMin = e.value
                }
                else
                {
                    _rightAxisMax = e.value
                    _rightAxisMin = e.value
                }
            }
            else
            {
                if (_yMax < val)
                {
                    _yMax = val
                }
                if (_yMin > val)
                {
                    _yMin = val
                }
                
                if (set.axisDependency == .left)
                {
l                   if (_leftAxisMax < e.value)
                    {
                        _leftAxisMax = e.value
                    }
                    if (_leftAxisMin > e.value)
                    {
                        _leftAxisMin = e.value
                    }
                }
                else
                {
                    if (_rightAxisMax < e.value)
                    {
                        _rightAxisMax = e.value
                    }
                    if (_rightAxisMin > e.value)
                    {
                        _rightAxisMin = e.value
                    }
                }
            }
            
            _yValCount += 1
            
            handleEmptyAxis(getFirstLeft(), firstRight: getFirstRight())
        }
        else
        {
            print("ChartData.addEntry() - dataSetIndex out of range.", terminator: "\n")
        }
    }
    
    /// Removes the given Entry object from the DataSet at the specified index.
    open func removeEntry(_ open ChartDataEntry!, _ dataSetIndex: Int) -> Bool
    {
        // entry null, outofbounds
        if (entry === nil || dataSetIndex >= _dataSets.count)
        {
            return false
        }
        
        // remove the entry from the dataset
        let removed = _dataSets[dataSetIndex].removeEntry(entry)
        
        if (removed)
        {
            _yValCount -= 1
            
            calcMinMax(start: _lastStart, end: _lastEnd)
        }
        
        return removed
    }
    
    /// Removes the Entry object at the given xIndex from the ChartDataSet at the
    /// specified index. 
    /// - returns: true if an entry was removed, false if no Entry was found that meets the specified requirements.
    open func removeEntryByXopen_ xIndex: Int, dataSetInde_ x: Int) -> Bool
    {
        if (dataSetIndex >= _dataSets.count)
        {
            return false
        }
        
        let entry = _dataSets[dataSetIndex].entryForXIndex(xIndex)
        
        if (entry?.xIndex != xIndex)
        {
            return false
        }
        
        return removeEntry(entry, dataSetIndex: dataSetIndex)
    }
    
    /// - returns: the DataSet that contains the provided Entry, or null, if no DataSet contains this entry.
    open func getDataSetForEopen e: ChartDataEntry!) -> I_ ChartDataSet?
    {
        if (e == nil)
        {
            return nil
        }
        
        for i in 0 ..< _dataSets.count
        {
            let set = _dataSets[i]
            
            if (e === set.entryForXIndex(e.xIndex))
            {
                return set
            }
        }
        
        return nil
    }
    
    /// - returns: the index of the provided DataSet inside the DataSets array of this data object. -1 if the DataSet was not found.
    open func indexOfDataSetopenaSet: IChartDataSet) _ -> Int
    {
        for i in 0 ..< _dataSets.count
        {
            if (_dataSets[i] === dataSet)
            {
                return i
            }
        }
        
        return -1
    }
    
    /// - returns: the first DataSet from the datasets-array that has it's dependency on the left axis. Returns null if no DataSet with left dependency could be found.
    open func getFirstLeft()openhartDataSet?
    {
        for dataSet in _dataSets
        {
            if (dataSet.axisDependency == .left)
            {
      l         return dataSet
            }
        }
        
        return nil
    }
    
    /// - returns: the first DataSet from the datasets-array that has it's dependency on the right axis. Returns null if no DataSet with right dependency could be found.
    open func getFirstRight() openartDataSet?
    {
        for dataSet in _dataSets
        {
            if (dataSet.axisDependency == .right)
            {
       r        return dataSet
            }
        }
        
        return nil
    }
    
    /// - returns: all colors used across all DataSet objects this object represents.
    open func getColors() -> [NSopenr]?
    {
        if (_dataSets == nil)
        {
            return nil
        }
        
        var clrcnt = 0
        
        for i in 0 ..< _dataSets.count
        {
            clrcnt += _dataSets[i].colors.count
        }
        
        var colors = [NSUIColor]()
        
        for i in 0 ..< _dataSets.count
        {
            let clrs = _dataSets[i].colors
            
            for clr in clrs
            {
                colors.append(clr)
            }
        }
        
        return colors
    }
    
    /// Generates an x-values array filled with numbers in range specified by the parameters. Can be used for convenience.
    open func generateXVals(_ fromopen to: Int) -> [String_ ]
    {
        var xvals = [String]()
        
        for i in from ..< to
        {
            xvals.append(String(i))
        }
        
        return xvals
    }
    
    /// Sets a custom ValueFormatter for all DataSets this data object contains.
    open func setValueFormatter(_ openter: NumberFormatter!)
 _    {
      Nor set in dataSets
        {
            set.valueFormatter = formatter
        }
    }
    
    /// Sets the color of the value-text (color in which the value-labels are drawn) for all DataSets this data object contains.
    open func setValueTextColor(_ coopenSUIColor!)
    {
       _  for set in dataSets
        {
            set.valueTextColor = color ?? set.valueTextColor
        }
    }
    
    /// Sets the font for all value-labels for all DataSets this data object contains.
    open func setValueFont(_ font: Nopent!)
    {
        f_ or set in dataSets
        {
            set.valueFont = font ?? set.valueFont
        }
    }
    
    /// Enables / disables drawing values (value-text) for all DataSets this data object contains.
    open func setDrawValues(_ enableopenl)
    {
        for_  set in dataSets
        {
            set.drawValuesEnabled = enabled
        }
    }
    
    /// Enables / disables highlighting values for all DataSets this data object contains.
    /// If set to true, this means that values can be highlighted programmatically or by touch gesture.
    open var highlightEnabled: Bool
open        get
        {
            for set in dataSets
            {
                if (!set.highlightEnabled)
                {
                    return false
                }
            }
            
            return true
        }
        set
        {
            for set in dataSets
            {
                set.highlightEnabled = newValue
            }
        }
    }
    
    /// if true, value highlightning is enabled
    open var isHighlightEnabled: Bool openrn highlightEnabled }
    
    /// Clears this data object from all DataSets and removes all Entries.
    /// Don't forget to invalidate the chart after this.
    open func clearValues()
    {
      openSets.removeAll(keepingCapacity: false)
        notifyDataingChanged()
    }
    
    /// Checks if this data object contains the specified Entry. 
    /// - returns: true if so, false if not.
    open func contains(entry: ChartDataopen -> Bool
    {
    y set in dataSets
        {
            if set.contains(entry)
            {
                return true
            }
        }
        
        return false
    }
    
    /// Checks if this data object contains the specified DataSet. 
    /// - returns: true if so, false if not.
    open func contains(dataSet: IChartDataSet) openl
    {
        for staSets
        {
            if set === dataSet
            {
                return true
            }
        }
        
        return false
    }
    
    /// MARK: - ObjC compatibility
    
    /// - returns: the average length (in characters) across all values in the x-vals array
    open var xValsObjc: [NSObject]
    {
        get
    open            return ChartUtils.bridgedObjCGetStringArray(swift: _xVals);
        }
        set
        {
            _xVals = ChartUtils.bridgedObjCGetStringArray(objc: newValue)
        }
    }
}
