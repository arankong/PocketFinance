//
//  StockPrices.swift
//  Portfolio Rebalancing
//
//  Created by Weirui Kong on 2016-07-28.
//  Copyright © 2016 uwaterloo. All rights reserved.
//

import UIKit

class OptionPrices {
    
    // MARK: Properties
    var ticker: String
    var price: Double
    var startDate: String
    var endDate: String
    
    // MARK: Initialization
    init (ticker: String, startDate: String, endDate: String) {
        self.ticker = ticker.uppercaseString
        self.startDate = startDate
        self.endDate = endDate
        self.price = 0
        
        self.getOptionPrice(ticker, startDate: self.startDate, endDate: self.endDate) { query, error in
            if let price = query?["underlying_price"] as? Double {
                self.price = price
            }
        }
    }
    
    // TESTTT
    func getOptionPrice(ticker: String, startDate: String, endDate: String, completionHandler: (NSDictionary?, NSError?) -> Void )  {
        
        let year = endDate.substringWithRange(endDate.startIndex...endDate.startIndex.advancedBy(3))
        var month = endDate.substringWithRange(endDate.startIndex.advancedBy(5)...endDate.startIndex.advancedBy(6))
        if month.hasPrefix("0") {
            month.removeAtIndex(month.startIndex)
        }
        var day = endDate.substringWithRange(endDate.startIndex.advancedBy(8)...endDate.startIndex.advancedBy(9))
        if day.hasPrefix("0") {
            day.removeAtIndex(month.startIndex)
        }
        
        let sYqlTemplate = "http://www.google.com/finance/option_chain?q={TICKER}&expd={DAY}&expm={MONTH}&expy={YEAR}&output=json"
        var sYql = sYqlTemplate.stringByReplacingOccurrencesOfString("{TICKER}",withString: ticker)
        sYql = sYql.stringByReplacingOccurrencesOfString("{DAY}",withString: day)
        sYql = sYql.stringByReplacingOccurrencesOfString("{MONTH}",withString: month)
        sYql = sYql.stringByReplacingOccurrencesOfString("{YEAR}",withString: year)
        print(sYql)
        sYql = sYql.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        let urlYql = (NSURL(string: sYql))!
        
        let request = NSURLRequest(URL:urlYql)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        //let session = NSURLSession(configuration:config, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        
        let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
            
            if((error) != nil) {
                print(error!.localizedDescription)
            }
            else {
                // JSON process
                do {
                    // Google, in their infinite wisdom, doesn't enclose the key names in quotes, so the returned JSON is not well formed
                    NSJSONSerialization.isValidJSONObject(data!)
                    
                    let NSStringfromData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    var optionChainString = NSStringfromData as! String
                    // Add the quotes back in with the help of regular expression
                    optionChainString = optionChainString.stringByReplacingOccurrencesOfString("(\\w+)\\s*:", withString: "\"$1\":", options: NSStringCompareOptions.RegularExpressionSearch, range: Range(start: optionChainString.startIndex, end: optionChainString.endIndex))
                    let tempNSString = optionChainString as NSString
                    let tempNSData = tempNSString.dataUsingEncoding(NSUTF8StringEncoding)!
                    // Now we can get the perfect JSON object
                    let jsonDict = try NSJSONSerialization.JSONObjectWithData(tempNSData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    print(jsonDict)
                    //                    let price = jsonDict["underlying_price"]
                    
                    //                    let query: NSDictionary = jsonDict["calls"] as! NSDictionary
                    
                    completionHandler(jsonDict, nil)
                    return
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
            
        })
        
        //LAUNCH the NSURLSessionDataTask!!!!!!
        task.resume()
        usleep(600000)
    }
}
