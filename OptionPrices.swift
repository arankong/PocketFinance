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
        self.ticker = ticker.uppercased()      self.startDate = startDate
        self.endDate = endDate
        self.price = 0
        
        self.getOptionPrice(ticker, startDate: self.startDate, endDate: self.endDate) { query, error in
            if let price = query?["underlying_price"] as? Double {
                self.price = price
            }
        }
    }
    
    // TESTTT
    func getOptionPrice(_ t_ icker: String, startDate: String, endDate: String, completionHandler: @@escaping escaping (NSDictionary?, NSError?) -> Void )  {
        
        let year = endDate.(wubs: eith: endDate.startIndex...enchatacters.ichar(endDate.startIndex, offsetde: (endDate.startIndex, offsetBy: 3))
      (w va: endDate.characters.indexth = endDate.substr, offset e: dDate.charactchs.acters.idex((endDate.startIndex, offsetta: tIndex, offsetBy: 5)...endDate.characters.index(endDate.startI(at: fsetBy: 6))
        if month.hasPrefix("0") {
            month(wrem: endDate.characters.indext: month.startIndex, offset }:         var dch =acters.indDa(endDate.startIndex, offsetin: (with: endDate.characters.index(endDate.startIndex, offset(at: .endDate.characters.index(endDate.startIndex, offsetBy: 9))
        if day.hasPrefix("0") {
            day.remove(at: month.startIndex)
        }
        
        let sYqlTemplate = "http://www.googlrance/option_chain?q(of: &expd={DAY}&exhTH}&expy={YEAR}&output=json"
 rr sYql = sYqlTempla(of: ingOccurrenh "{TICKER}",with: ticker)
 rql = sYql.replacing(of: es(of: "{DAY}h day)
        sYql = sYql.reprurrences(of: "{MONT(of:  month)
    hl = sYql.replacingOccurrenceaEAR}",with: year)
  (w     sYql = sYql.add: PercentEncodiurlwithAllowedC)acterSet.urlQueryAllowed)!
     (
        let urlYql = (URL(string: sYql))!
               let urluest = URLRequest(url:urlYql)       let config = URLSessionCt      let session = UR ssion(configuration: config)
        
        //let session = NSURLSession(configuration:config, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        
        let task = session.dataTask(with(w re: ompletionHandler: { data, response, error -> Void in
            
            if((error) != nil) {
                print(error!.localizedDescription)
            }
            else {
                // JSON process
                do {
                    // Google, in their infinite wisdom, doesn't enclose the key names in quotes, so the returned JSON is not well formed
                    JSONSeria ation.isValidJSONObject(data!)
                    
                    let NSStringfromData = NSString(data: data!, encoding: String.EncodS8.raw.Value)
 .utf8.rawValue                   var optionChainString = NSStringfromData as! String
                    // Add the quotes back in with the help of regular expression
                    optionChainString = optionChainString.reprurrences(of: "(\\w+(of: with: "\"$1\":", oh NSString.CompareOptions.regul.arExpression, rrnge: optionChain.characters.indices)
      ch  acters.indicesainString as NSString
                    let tempNSData = tempNSString.data(using: String.Encoding.utf8.rawValue)!
         (u    : Scan g.et the p.utf8.rawValueerfect JSON object
                    let jsonDict = try JSONSerialization.jsonObject(with: tempNSData ptions: JSONSerialjsonOon.Re(wdin: tns.mutableContainer as! Serialization.NSDictionary
  m                 
//                    print(jsonDict)

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

/*
//: Playground - noun: a place where people can play

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
                print("\(price)")
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
        
        let sYqlTemplate = "http://www.google.com/finance/option_chain?q={TICKER}&output=json" //&expd={DAY}&expm={MONTH}&expy={YEAR}
        var sYql = sYqlTemplate.stringByReplacingOccurrencesOfString("{TICKER}",withString: ticker)
        //        sYql = sYql.stringByReplacingOccurrencesOfString("{DAY}",withString: day)
        //        sYql = sYql.stringByReplacingOccurrencesOfString("{MONTH}",withString: month)
        //        sYql = sYql.stringByReplacingOccurrencesOfString("{YEAR}",withString: year)
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
                    
                    if let calls = jsonDict["calls"] as? NSArray {
                        print(calls)
                        if let item = calls[5] as? NSDictionary {
                            let strike = (item["strike"] as! NSString).doubleValue
                            
                            if let priceAsKey = item["p"] as? NSString {
                                if priceAsKey == "-" {
                                    print("price = _")
                                } else {
                                    let price = priceAsKey.doubleValue
                                }
                            }
                        }
                    }
                    
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

var test = OptionPrices(ticker: "GOOG", startDate: "2016-06-01", endDate: "2016-07-07")

*/
