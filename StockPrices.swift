//
//  StockPrices.swift
//  Portfolio Rebalancing
//
//  Created by Weirui Kong on 2016-07-28.
//  Copyright © 2016 uwaterloo. All rights reserved.
//

import UIKit

class StockPrices {
    
    // MARK: Properties
    var ticker: String
    var priceArray: [Double]
    var startDate: String
    var endDate: String
    
    // MARK: Initialization
    init (ticker: String, startDate: String, endDate: String) {
        self.ticker = ticker.uppercaseString
        self.startDate = startDate
        self.endDate = endDate
        self.priceArray = [Double]()

        self.getHistoricalPrice(ticker, startDate: self.startDate, endDate: self.endDate) { query, error in
            if let result = query!["results"] as? NSDictionary {
                for dictPrice in result["quote"] as! [NSDictionary] {
                    self.priceArray.append(Double(dictPrice["Close"] as! String)!)
                }
                // Oldest to most recent
                self.priceArray = self.priceArray.reverse()
            }

        }
    }
    

    
    func getHistoricalPrice(ticker: String, startDate: String, endDate: String, completionHandler: (NSDictionary?, NSError?) -> Void )  {
        
        let sYqlTemplate = "https://query.yahooapis.com/v1/public/yql?q=select Close from yahoo.finance.historicaldata where symbol = '{TICKER}' and startDate = '{START}' and endDate = '{END}' &env=store://datatables.org/alltableswithkeys&format=json"
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
                    //print(jsonDict)
                    let query: NSDictionary = jsonDict["query"] as! NSDictionary
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
        usleep(600000)
    }
    
}
