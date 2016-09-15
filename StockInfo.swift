//
//  StockInfo.swift
//  Portfolio Rebalancing
//
//  Created by Weirui Kong on 2016-07-28.
//  Copyright © 2016 uwaterloo. All rights reserved.
//

import UIKit

class StockInfo: NSObject, NSCoding {
    // MARK: Properties
    
    var ticker: String
    var price: Double
    var priceArray: [Double]
    var change: String
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("StockInfo")
    // MARK: Types
    
    struct PropertyKey {
        static let tickerKey = "ticker"
        static let priceKey = "price"
        static let changeKey = "change"
    }
    
    // MARK: Initialization
    init(ticker: String, price: Double, change: String) {
        self.ticker = ticker.uppercaseString
        self.price = price
        self.change = change
        self.priceArray = [Double]()
        super.init()
    }
    
    // Take ticker, construct object
    // price and change from YQL
    init(ticker: String) {
        self.ticker = ticker.uppercaseString
        self.price = 0
        self.change = ""
        self.priceArray = [Double]()
        print(self.ticker)
        
        super.init()
        
        self.getStockJSONDict(ticker) { quote, error in
            if let sPrice = quote!["LastTradePriceOnly"] as? String {
                self.price = Double(sPrice)!
                self.change = quote!["PercentChange"]as! String
                print(self.price)
            } else {
                self.price = 0
                self.change = "NaN"
            }

        }
        
        self.getHistoricalPrice(ticker) { query, error in
            if let result = query!["results"] as? NSDictionary {
                for dictPrice in result["quote"] as! [NSDictionary] {
                    self.priceArray.append(Double(dictPrice["Close"] as! String)!)
                }
            // Oldest to most recent
            self.priceArray = self.priceArray.reverse()
            }
        }
        
    }
    
    func dateToString(dDate:NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let sDate : String = dateFormatter.stringFromDate(dDate)
        
        return sDate
    }
    
    func getStockJSONDict(ticker: String, completionHandler: (NSDictionary?, NSError?) -> Void ) {

        let sYqlTemplate = "https://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.quotes where symbol = '{TICKER}' &env=store://datatables.org/alltableswithkeys&format=json"
        var sYql = sYqlTemplate.stringByReplacingOccurrencesOfString("{TICKER}", withString: ticker)

        sYql = sYql.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let urlYql = (NSURL(string: sYql))!
        let request = NSURLRequest(URL: urlYql)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
            
            if((error) != nil) {
                print(error!.localizedDescription)
            }
            else {
                // JSON process
                do {
                    let jsonDict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    //print (jsonDict)
                    if let query = jsonDict["query"] as? NSDictionary {
                        if let results = query["results"] as? NSDictionary {
                            if let quote = results["quote"]as? NSDictionary {
                                completionHandler(quote, nil)
                                return
                            }
                        }
                    } else {
                        completionHandler(nil, nil)
                        return
                    }
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
            
        })
        
        //LAUNCH the NSURLSessionDataTask!!!!!!
        task.resume()
        
        usleep(600000)
    }
    
    func getHistoricalPrice(ticker: String, completionHandler: (NSDictionary?, NSError?) -> Void )  {
        
        let sYqlTemplate = "https://query.yahooapis.com/v1/public/yql?q=select Close from yahoo.finance.historicaldata where symbol = '{TICKER}' and startDate = '{START}' and endDate = '{END}' &env=store://datatables.org/alltableswithkeys&format=json"
        let endDate = dateToString(NSDate().dateByAddingTimeInterval(-60*60*24*1))
        let startDate = dateToString(NSDate().dateByAddingTimeInterval(-60*60*24*31))
        var sYql = sYqlTemplate.stringByReplacingOccurrencesOfString("{TICKER}", withString: ticker)
        sYql = sYql.stringByReplacingOccurrencesOfString("{START}", withString: startDate)
        sYql = sYql.stringByReplacingOccurrencesOfString("{END}", withString: endDate)
        sYql = sYql.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        let urlYql = (NSURL(string: sYql))!
        
        let request = NSURLRequest(URL:urlYql)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
            if((error) != nil) {
                print(error!.localizedDescription)
            }
            else {
                // JSON process
                do {
                    let jsonDict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    let query: NSDictionary = jsonDict["query"] as! NSDictionary
                    completionHandler(query, nil)
                    return
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
            
        })
        
        //LAUNCH the NSURLSessionDataTask!!!!!!
        task.resume()
        //sleep()
        usleep(600000)
    }
    
    func refreshData(){
        self.getStockJSONDict(ticker) { quote, error in
            if let sPrice = quote!["LastTradePriceOnly"] as? String {
                if let sChange = quote!["PercentChange"] as? String {
                    self.price = Double(sPrice)!
                    self.change = sChange //quote!["PercentChange"]as! String
                } else {
                    self.price = 0
                    self.change = "NaN"
                }
            } else {
                self.price = 0
                self.change = "NaN"
            }
        }
        
        self.getHistoricalPrice(ticker) { query, error in
            if let result = query!["results"] as? NSDictionary {
                for dictPrice in result["quote"] as! [NSDictionary] {
                    self.priceArray.append(Double(dictPrice["Close"] as! String)!)
                }
                // Oldest to most recent
                self.priceArray = self.priceArray.reverse()
            }
        }
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(ticker, forKey: PropertyKey.tickerKey)
        aCoder.encodeDouble(price, forKey: PropertyKey.priceKey)
        aCoder.encodeObject(change, forKey: PropertyKey.changeKey)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        let ticker = aDecoder.decodeObjectForKey(PropertyKey.tickerKey) as! String
        let price = aDecoder.decodeDoubleForKey(PropertyKey.priceKey)
        let change = aDecoder.decodeObjectForKey(PropertyKey.changeKey) as! String
        
        // Must call designated initilizer.
        self.init(ticker: ticker, price: price, change: change)
    }
    
}