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
    init (ticker: String, price: Double, change: String) {
        self.ticker = ticker.uppercaseString
        self.price = price
        self.change = change
        
        super.init()
        //if ticker.isEmpty  {
        //    return nil
        //}
    }
    
    // Take ticker, construct object
    // price and change from YQL
    init (ticker: String) {
        self.ticker = ticker.uppercaseString
        self.price = 0
        self.change = ""
        print(self.ticker)
        
        super.init()
        
        self.getStockJSONDict(ticker) { quote, error in
            if let sPrice = quote!["LastTradePriceOnly"] as? String{
                self.price = Double(sPrice)!
                self.change = quote!["PercentChange"]as! String
                print(self.price)
            } else {
                self.price = 0
                self.change = "NaN"
            }
        }
        
    }
    
    func getStockJSONDict(ticker: String, completionHandler: (NSDictionary?, NSError?) -> Void )  {
        
        let sYqlTemplate = "https://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.quotes where symbol = '{TICKER}' &env=store://datatables.org/alltableswithkeys&format=json"
        var sYql :String = sYqlTemplate.stringByReplacingOccurrencesOfString("{TICKER}",withString: ticker)
        
        sYql = sYql.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let urlYql : NSURL = (NSURL(string: sYql))!
        print(urlYql)

        let request: NSURLRequest = NSURLRequest(URL:urlYql)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            if((error) != nil) {
                print(error!.localizedDescription)
            }
            else {
                // JSON process
                do {
                    let jsonDict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    //print (jsonDict)
                    //var errData : Bool = true
                    if let query: NSDictionary = jsonDict["query"] as? NSDictionary{
                        if let results: NSDictionary = query["results"] as? NSDictionary{
                            if let quote: NSDictionary = results["quote"]as? NSDictionary{
                                //errData = false
                                completionHandler(quote,nil)
                                return
                            }
                        }
                    }
                    //if errData == true{
                    completionHandler(nil,nil)
                    return
                    //}
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
            
        })
        
        //LAUNCH the NSURLSessionDataTask!!!!!!
        task.resume()
        
        usleep(600000)
        //usleep(800000)

    }
    
    func refreshData(){
        self.getStockJSONDict(ticker){quote, error in
            if let sPrice = quote!["LastTradePriceOnly"] as? String{
                
                if let sChange = quote!["PercentChange"] as? String {
                    self.price = Double(sPrice)!
                    self.change = sChange //quote!["PercentChange"]as! String
                }else {
                    self.price = 0
                    self.change = "NaN"
                }
            } else {
                self.price = 0
                self.change = "NaN"
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
    
    
    // TESTTT
    /*func getOptionPrice(ticker: String,completionHandler: (NSDictionary?, NSError?) -> Void )  {
        
        let sYqlTemplate = "https://www.google.com/finance/option_chain?q=AAPL&expd=1&expm=4&expy=2016&strike=110&output=json"
        var sYql = sYqlTemplate
        /*var sYql :String = sYqlTemplate.stringByReplacingOccurrencesOfString("{TICKER}",withString: ticker)
         sYql = sYql.stringByReplacingOccurrencesOfString("{START}",withString: startDate)
         sYql = sYql.stringByReplacingOccurrencesOfString("{END}",withString: endDate)*/
        print(sYql)
        sYql = sYql.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        let urlYql : NSURL = (NSURL(string: sYql))!
        
        let request: NSURLRequest = NSURLRequest(URL:urlYql)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        //let session = NSURLSession(configuration:config, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            if((error) != nil) {
                print(error!.localizedDescription)
                print("1")
            }
            else {
                // JSON process
                do {
                    print("inside session")
                    //print(data(1))
                    data = data.
                    let jsonDict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    print(jsonDict)
                    
                    let query: NSDictionary = jsonDict["query"] as! NSDictionary
                    //let results: NSDictionary = query["results"] as? NSDictionary
                    //let quote: [NSDictionary] = results["quote"]as! [NSDictionary]
                    
                    completionHandler(query,nil)
                    return
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
            
        })
        
        //LAUNCH the NSURLSessionDataTask!!!!!!
        task.resume()
        //sleep()
        usleep(500000)
    }*/
        
}