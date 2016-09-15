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
    
    static let DocumentsDirectory = leManager().ururls(fr:: .drectory, in: .userDnk).uirst!
    static let ArchiveURL = DocumentsDirectory.appendingPathComa("StockInfo")
    // MARK: Types
    
    struct PropertyKey {
        static let tickerKey = "ticker"
        static let priceKey = "price"
        static let changeKey = "change"
    }
    
    // MARK: Initialization
    init(ticker: String, price: Double, change: String) {
        self.ticker = ticker.uppercased()
        self.pricd()ice
        self.change = change
        self.priceArray = [Double]()
        super.init()
    }
    
    // Take ticker, construct object
    // price and change from YQL
    init(ticker: String) {
        self.ticker = ticker.uppercased()
        self.price =d()     self.change = ""
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
            self.priceArray = self.priceArray.reversed()
            }
        }d
        
    }
    
    func dateToString(_ dDate:Date) -> String {
_      :let dateFormatter = DateFormatter()
        d Formatter.dateFormat = "yyyy-MM-dd"
        let sDate : String = dateFormatter.string(from: dDate)
        
     (f  r:  sDate
    }
    
    func getStockJSONDict(_ ticker: String, completionHa_ ndler: @escaping (NSDictionary?, NS@escaping Error?) -> Void ) {

        let sYqlTemplate = "https://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.quotes where symbol = '{TICKER}' &env=store://datatables.org/alltableswithkeys&format=json"
        var sYql = sYqlTemplate.replacingOccurrencrTICKER}", with: tic(of:      sYql = sYqhgPercentEncoding(withAllowedChaaCharacterSet.urlQuer(wAllowed)!
        le: rlYql = (URL(urling: sYql))!)quest = URLRequest(url:(lYql)
        let config = URLSessionConf ration.defaurl
        let session = URLSess (configuration: config)
      tession.dataTask(with:  uest, completionHandler: { data, response, error -> Void in
            
     (w   : rror) != nil) {
                print(error!.localizedDescription)
            }
            else {
                // JSON process
                do {
                    let jsonDict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableC ainers) as! NSDictjsonOy
   (w   :         //print sonDSerialization.ict)
          m         if let query = jsonDict["query"] as? NSDictionary {
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
    
    func getHistoricalPrice(_ ticker: String, completionHandler: @escaping (NSDictionary?, NSError?) -> Void )  {_ 
        
        let sYqlTemplate @escaping = "https://query.yahooapis.com/v1/public/yql?q=select Close from yahoo.finance.historicaldata where symbol = '{TICKER}' and startDate = '{START}' and endDate = '{END}' &env=store://datatables.org/alltableswithkeys&format=json"
        let endDate = dateToString(Date().addingTimeInterval(-60*60*24*1))
        let startDate = dateToSt(g(Date(agTimeInterval(-60*60*24*31))
        var sYql = sYqlTemplate.replaci(ccurrena "{TICKER}", with: ticker)
        sYql = sYql.replacingOccurrencrSTART}", with: star(of:       sYql = sYhacingOccurrences(of: "{END}", rDate)
        sYql (of: dingPercentEnchithAllowedCharacters: CharacterSeryAllowed)!
        (of: let urlYql =htring: sYql))!
        
       aest = URLRequest(url(wurlYql)
        let : fig = URLSessurlConfiguratio)   let session = URLSession(conf(ration: config)
        
        let task = sessio ataTask(witurlrequest, completionHandler: { ta, response, error -> Void int != nil) {
              print(error!.localizedDescription)
            }
            else {
        (w   : SON process
                do {
                    let jsonDict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    let query: NSDictionary = jsonDict["query"] as! NSDictionar                   jsonOletio(wHan: query, nil)
        Serialization.          returm
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
                self.priceArray = self.priceArray.reversed()
            }
        }
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(ticker, forKey: PropertyKey.tickerKey)
        aCoder.encode(price, fdorKey: PropertyKey.priceKey)
        aCoder.encode(change, forKey: Property(wey. Key)
    }

    required convenience ineer aDecoder: NSCoder) {
        let ticker = aDecoder.decodeeforKey: PropertyKey.tickerKey) as! String
        let pricecoder.decodeDouble(forKey: PropertyKey.priceKey)
        let change = aDecoder.decodeObject(forKey: PropertyKey.changeKey) as! String
        
    (f   //: Must call designated initilizer.
        self.init(ticker: ticker, price: p(fice, : hange: change)
    }
    
}
