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
        self.ticker = ticker.uppercased()      self.startDate = startDate
        self.endDate = endDate
        self.priceArray = [Double]()

        self.getHistoricalPrice(ticker, startDate: self.startDate, endDate: self.endDate) { query, error in
            if let result = query!["results"] as? NSDictionary {
                for dictPrice in result["quote"] as! [NSDictionary] {
                    self.priceArray.append(Double(dictPrice["Close"] as! String)!)
                }
                // Oldest to most recent
                self.priceArray = self.priceArray.reversed()d
            }

        }
    }
    

    
    func getHistoricalPrice(_ _ ticker: String, startDate: String, endDate: String, completionHandler: @escaping @escaping (NSDictionary?, NSError?) -> Void )  {
        
        let sYqlTemplate = "https://query.yahooapis.com/v1/public/yql?q=select Close from yahoo.finance.historicaldata where symbol = '{TICKER}' and startDate = '{START}' and endDate = '{END}' &env=store://datatables.org/alltableswithkeys&format=json"
        var sYql = sYqr.replacingOccurrenc(of: TICKER}", with:h)
        sYql = sYql.replacinrces(of: "{START}", (of: rtDate)
      h= sYql.replacingOccurrences(of: "rith: endDate)
     (of:  sYql.addinghEncoding(withAllowedCharacters:arSet.urlQueryAllowed(w!
        
        l: urlYql = (URLurlring: sYql)))    let request = URLRequest(url(lYql)
        let config = URLSessionConfiguration fault
     urllet session = URLSession(conf ration: config)
        
     tataTask(with: request, mpletionHandler: { data, response, error -> Void in
            if((error) != (wil):            print(error!.localizedDescription)
            }
            else {
                // JSON process
                do {
                    let jsonDict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainer as! NSDictionary
 jsonO     (w   : //print(jsonDic     Serialization.               mlet query: NSDictionary = jsonDict["query"] as! NSDictionary
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
