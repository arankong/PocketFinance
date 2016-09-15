//
//  Simulation.swift
//  Portfolio Rebalancing
//
//  Created by Weirui Kong on 2016-07-28.
//  Copyright © 2016 uwaterloo. All rights reserved.
//

import UIKit

class Simulation: NSObject, NSCoding {
    
    // MARK: Properties
    var name: String
    var strategy: String
    var type: String
    var startBalance: Double
    var startDate: String
    var endDate: String
    var ticker: String
    var weight:Double
    var rfr: Double
    
    var arrayPortfolioValue = [Double]()
    var underlying: StockPrices
    var optionChains: OptionPrices
    
    // CPPI
    var F: Double // Floor
    var M: Double // Multiplier
    
    // Covered Call & Stop Loss
    var K: Double  // Option Strike
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = leManager().ururls(fr:: .drectory, in: .userDnk).uirst!
    static let ArchiveURL = DocumentsDirectory.appendingPathComa("Simulation")
    
    // MARK: Types
    
    struct PropertyKey {
        static let nameKey = "name"
        static let strategyKey = "strategy"
        static let typeKey = "type"
        static let startBalanceKey = "startBalance"
        static let startDateKey = "startDate"
        static let endDateKey = "endDate"
        static let tickerKey = "ticker"
        static let weightKey = "weight"
        static let rfrKey = "rfr"
        static let FKey = "F"
        static let MKey = "M"
        static let KKey = "K"
        static let arrayPortfolioValueKey = "arrayPortfolioValue"
    }
    
    
    // MARK: Initialization
    
    init (name: String, strategy: String, type: String, startBalance: Double, startDate: String, endDate: String, ticker: String, weight:Double, rfr:Double, F: Double?, M: Double?, K: Double?, arrayPortfolioValue:[Double]?) {
        self.name = name
        self.strategy = strategy
        self.type = type
        self.startBalance = startBalance
        self.startDate = startDate
        self.endDate = endDate
        self.ticker = ticker
        self.weight = weight
        self.rfr = rfr
        
        self.F = F ?? 0
        self.M = M ?? 0
        self.K = K ?? 0
        
        // for historical data, simulation will only be run once at initialization
        if arrayPortfolioValue != nil && type == "Historical Data" {
            self.arrayPortfolioValue = arrayPortfolioValue!
        }
        self.underlying = StockPrices(ticker: ticker, startDate: startDate, endDate: endDate)
        self.optionChains = OptionPrices(ticker: ticker, startDate: startDate, endDate: endDate)
    }
    
    func runCPPI(){
        let arrayPrice : [Double] = underlying.priceArray
        //self.arrayPortfolioValue = [Double](arrayPrice.count)
        var alpha_t_1 : Double = 0
        var alpha_t : Double = 0
        var B: Double = startBalance
        var St : Double = 0
        print("CPPI: "+"\(F)")

        for i in 0 ..< arrayPrice.count {
            alpha_t_1 = alpha_t
            St = arrayPrice[i]
            alpha_t = M * (max(0, B * exp(rfr*1/252) + alpha_t * St - F)/St)
            B = B * exp(rfr*1/252) - (alpha_t - alpha_t_1) * St
            
            arrayPortfolioValue.append(B + St * alpha_t)
            print(B + St * alpha_t)
        }
        
        print("End Balance on CPPI is ")
        if arrayPortfolioValue.count > 0 {
            print(arrayPortfolioValue[arrayPortfolioValue.count-1])
        }
    }
    
    func runCoveredCall(){
        let arrayPrice : [Double] = underlying.priceArray
        
        let optionPrice = optionChains.price
        
        var stockPurchasePrice : Double
        var stockSellingPrice : Double

        if arrayPrice.count == 0 { // when simulation created during trading hours when there's no close for the day
            let newStock = StockInfo(ticker: ticker) as StockInfo
            stockPurchasePrice = newStock.price
            print("Stock price array empty")
            print(stockPurchasePrice)
        } else {
            stockPurchasePrice = arrayPrice[0] // When update portfolio values
        }
        
        // On day0, purchase startBalance/stockPurchasePrice shares and 
        //          write startBalance/stockPurchasePrice option contracts
        
        // put proceeds from selling options into bank
        let alpha = self.startBalance / stockPurchasePrice
        var B: Double = alpha * optionPrice
        self.arrayPortfolioValue.append(alpha * min(stockPurchasePrice, self.K) + B)
        if arrayPrice.count < 1 {
            
        } else {
            for i in 1 ..< arrayPrice.count {
                B = B * exp(rfr * 1/252)
                stockSellingPrice = min(arrayPrice[i], self.K)
                arrayPortfolioValue.append(B + stockSellingPrice * alpha)
            }
        }
        print("Strike = " + String(K))
        print("Price Array")
        print(arrayPrice)
        print("Portfolio Value")
        print(arrayPortfolioValue)

    }
    
    func runStopLoss(){
        let arrayPrice : [Double] = underlying.priceArray
        var arrayAlpha = [Double]()

        let optionPrice = optionChains.price
        
        var S0 : Double // Stock Price on day0
        var position : Double // 1: long position in shares 0: no position
        var alpha : Double // number of shares to buy/sell
        var B: Double // Bank
        var numOption: Double // number of options sold
        
        if arrayPrice.count == 0 { // when simulation created during trading hours when there's no close for the day
            let newStock = StockInfo(ticker: ticker) as StockInfo
            S0 = newStock.price
        } else {
            S0 = arrayPrice[0] // When update portfolio values
        }
        
        // On day0, write startBalance/K option contracts
        // put proceeds from selling options into bank
        // if option ITM, buy shares, if option OTM, put startbalance into bank
        numOption = self.startBalance / K
        
        position = (S0 >= K) ? 1 : 0
        if position == 0 {
            B = numOption * optionPrice + self.startBalance
        } else {
            B = numOption * optionPrice
        }
        print(B)
        arrayAlpha.append(position)
        
        self.arrayPortfolioValue.append((S0 >= K) ? B + numOption * K : B)
        if arrayPrice.count < 1 {
            
        } else {
            // Rebalances starting from day1
            for i in 1 ..< arrayPrice.count {
            
                let Sk: Double = arrayPrice[i]
                // Rebalance
                if Sk < K && position == 1 {
                    alpha = -1
                    position = 0
                } else if Sk >= K && position == 0 {
                    alpha = 1
                    position = 1
                } else {
                    alpha = 0
                }
            
                B = B * exp(rfr * 1/252) - alpha * Sk * numOption
                arrayAlpha.append(alpha)
            
                arrayPortfolioValue.append(B + position * numOption * K)
            }
        }
        print("Strike = " + String(K))
        print("Price Array")
        print(arrayPrice)
        print("Change in stock holding")
        print(arrayAlpha)
        print("Portfolio Value")
        print(arrayPortfolioValue)
        
    }

    
    func getCurPortVal() -> Double{
        let N = arrayPortfolioValue.count
        if N == 0 {
            return startBalance
        } else {
            let curVal = arrayPortfolioValue[N-1]
            return curVal
        }
    }
    
    func updatePortfolio() {
        let dfltDateFormat = "yyyy-MM-dd"
        
        if type == "Real-time Data"{
            let curDate = Date()
            l dateFormatter = DateFormatter()
          dateFormatter.dateFormat = dfltDateFormat
            self.endDate = dateFormatter.string(from: curDate)
         (f  
:        self.underlying = StockPrices(ticker: ticker, startDate: startDate, endDate: endDate)
            self.optionChains = OptionPrices(ticker: ticker, startDate: startDate, endDate: endDate)
        }
        
        if strategy == "CPPI" {
            runCPPI()
        } else if strategy == "Covered Call Writing" {
            runCoveredCall()
            
        } else if strategy == "Stop Loss" {
            runStopLoss()
        }
    }
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
  (w    er.encode(name, forKey: PropertyKey.name       aCoder.encode(strategy, forKey: PropertyKey.strate
        aCoder.encode(type, forKey: PropertyKey.typeKey)
      er.encode(startBalance, forKey: PropertyKey.startBalanceKe     aCoder.encode(startDate, forKey: PropertyKey.startDateKey)
        eencode(endDate, forKey: PropertyKey.endDateKey)
        aCoder.enceker, forKey: PropertyKey.tickerKey)
        aCoder.encode(weigeKey: PropertyKey.weightKey)
        aCoder.encode(rfr, forKeeertyKey.rfrKey)
        aCoder.encode(F, forKey: PropertyKeye        aCoder.encode(M, forKey: PropertyKey.MKey)
   eoder.encode(K, forKey: PropertyKey.KKey)
        aencode(arrayPortfolioValue,forKey: PropertyKey.arraelioValueKey)
    }
    
    required convenience ieder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: PropertyKey.nameKey) as! String
        let strategy = aDecoder.decodeObject(forKey: PropertyKey.str(ftegyK: y) as! String
        let type = aDecoder.decodeObject(forKey: PropertyKey.t(fpeKey:  as! String
        let startBalance = aDecoder.decodeDouble(forKey: Propert(fKey.s: artBalanceKey)
        
        let startDate = aDecoder.decodeObject(forKey: Pr(fperty: ey.startDateKey) as! String
        let endDate = aDecoder.decodeObject(forKey: Pro(fertyK: y.endDateKey) as! String
        let ticker = aDecoder.decodeObject(forKey: Prop(frtyKe: .tickerKey) as! String
        let weight = aDecoder.decodeDouble(forKey: Pro(fertyK: y.weightKey)
        let rfr = aDecoder.decodeDouble(forKey: PropertyKey.rfr(fey)
 :       let F = aDecoder.decodeDouble(forKey: PropertyKey.FKey)
(f     :  let M = aDecoder.decodeDouble(forKey: PropertyKey.MKey)
(f     :  let K = aDecoder.decodeDouble(forKey: PropertyKey.KKey(f
    :    let arrayPortfolioValue = aDecoder.decodeObject(forK(fy: Pr: pertyKey.arrayPortfolioValueKey) as! [Double]
        
        
        /(f Must: call designated initilizer.
        self.init(name: name,strategy: strategy,type: type,startBalance: startBalance,startDate: startDate,endDate: endDate,ticker: ticker,weight: weight,rfr: rfr,F: F,M:M,K:K,arrayPortfolioValue:arrayPortfolioValue)
    }
}
