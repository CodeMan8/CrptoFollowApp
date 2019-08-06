//
//  Crypto.swift
//  CryptoCurrency
//
//  Created by Bartu akman on 30.09.2018.
//  Copyright © 2018 Bartu akman. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreData

class  Crypto {
    
    // we set our coin  property
    
    private var _name: String!
    private var _priceUsd: String!
    private var _change: String!
 
      var name: String {

      get {
        
       return _name
        
         }
        
        set(newValue) {
            
            _name = newValue

        }
       
    }
         var priceUsd: String {
               get {
                
                  return _priceUsd

                 }
            set(newValue) {

            _priceUsd = newValue
        }
    }

        var change: String {
             get {
         return _change
                 }
        set (newValue) {
        _change = newValue
            
        }
 
}
    


func get(completed: @escaping DownloadComplete)  {
        
// With query we send request to our API for chart values
    
        let value = CryptoDetailController.coinType!
        var select = CryptoDetailController.selectedSegmentIndex
        var query = "https://apiv2.bitcoinaverage.com/indices/local/history/"+value+"?period=\(select)&?format=json"
        print(query)
    
          Alamofire.request(query).responseJSON { response in
            
            if response.result.isSuccess {
           
                
                let result = response.result
                let jsonData:JSON = JSON(result.value!)
 
                                 for json in jsonData.arrayValue {
 
                     CryptoDetailController.bitcoinaverages.append(Double("\(json["average"])")!)
                     CryptoDetailController.bitcoinTimes.append("\(json["time"])")
  
                                    
                }
                 self.calculateShowInterval(select: select)
                
 
 
                completed()
  
                    

}
    }


}
func calculateShowInterval (select: String) {
    
    // As you can see we pick Interval  and show the time values on chart that way
    // If you need to change X values on chart you can come here
    
      switch select {

    case "daily":

        for i in 0..<CryptoDetailController.bitcoinTimes.count {
            CryptoDetailController.bitcoinTimes[i] = "\(CryptoDetailController.bitcoinTimes[i].suffix(8))"
            print("tamamlam")
            print(CryptoDetailController.bitcoinTimes[i])
        }
    case "monthly" :
        
        for i in 0..<CryptoDetailController.bitcoinTimes.count {
          let nowtimes =    CryptoDetailController.bitcoinTimes[i]
          let range = 5..<10
          let     slice =  String(nowtimes[range])
           
            CryptoDetailController.bitcoinTimes[i] = "\(slice)"
            
        }
    default:

        for i in 0..<CryptoDetailController.bitcoinTimes.count {
           CryptoDetailController.bitcoinTimes[i] = "\(CryptoDetailController.bitcoinTimes[i].prefix(10))"
        }
        
 
    }

CryptoDetailController.bitcoinaverages =  CryptoDetailController.bitcoinaverages.reversed()
    CryptoDetailController.bitcoinTimes =  CryptoDetailController.bitcoinTimes.reversed()
    
 
    
    
    
}
    
    
    
    func getData(completed: @escaping DownloadComplete)  {
        
        // We don't need to this func But if you want to use  only bitcoin  chart I advice you to use that class instead of getJsonData function
        
        var queryLink = "https://api.coindesk.com/v1/bpi/historical/close.json?start=\(daysAgoFormatted)&end=\(todayFormatted)&currency=\(CryptoDetailController.selectedSegmentIndex)"
        
 
        Alamofire.request(queryLink).responseJSON { response in
            
            if response.result.isSuccess {
           

                
                let result = response.result

                // let jsonData:JSON = JSON(response.result.value!)
 
                if let  json =  result.value as? Dictionary<String,AnyObject>  {

                     if let jsonveri = json["bpi"] as? Dictionary<String,AnyObject> {
                              print(jsonveri)
                                let sortedJson = jsonveri.sorted { $0.0 < $1.0 }
                             print(sortedJson)
                        for(key, value) in sortedJson  {
                            print(key)
                            print(value)
 
                        CryptoDetailController.bitcoinaverages.append(Double(value as! NSNumber))
                            CryptoDetailController.bitcoinTimes.append(key)
                            print(key)
 
                        }
                         
  
                       
                    }
 
                }
  
  
            }
            else {
                print("Error: \(String(describing: response.result.error))")
            }
            
            completed()
 

}
}
    
    func insertValuesInDataStore(name: String, value: String, change: String) {
 
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.persistentContainer.viewContext
         let newEntry = NSEntityDescription.insertNewObject(forEntityName: "EntityTable", into: context) as NSManagedObject
      
        
 
         do {
            
            newEntry.setValue(name, forKey: "name")
            newEntry.setValue(value, forKey: "value")
            newEntry.setValue(change, forKey: "change")
 
            try context.save()
         }
        catch {
            
            errorMessage()
        }
    }
    
  
func errorMessage(){

   print("error has been occured")

}
   
    func getJsonData(completed: @escaping DownloadComplete)  {
        
        // Receive Crypto's Currency and  push these coins  to our table view
        // If you want to change coin names or coin prices whatever you want just need to do remove (json"[name"] part
        // and add your wish to inside "" line
        // Also you would show another crypto coin  inside  if statement

        
        
        Alamofire.request(baseUrl).responseJSON { response in
            
            if response.result.isSuccess {
             
                
                let result = response.result
                let jsonData:JSON = JSON(response.result.value!)
                 /*
                if let  json =  result.value as? [Dictionary<String,AnyObject>]  {
                    print("tamam")
                         if let jsonveri = json[0]["price_try"] as? String {
                            print("json\(jsonveri)")
                 
                    }
                    }
 */
                 for json in jsonData.arrayValue {
 

                    print("\(json["name"]) : \(json["price_try"]) ₺ , \(json["price_usd"]) $")
                    
                  
                    
                        let bitcoin = Crypto()
                        bitcoin.name = "\(json["name"])"
                        bitcoin.priceUsd = "\(json["price_usd"])"
                        bitcoin.change  = "\(json["percent_change_24h"])"
 
                        self.insertValuesInDataStore(name: "\(bitcoin.name)", value: String(bitcoin.priceUsd), change:String(bitcoin.change))
                        print("offff")

                    
  
                           ViewController.coins.append(bitcoin)
 

 

                        print("\(bitcoin.name)")
                         print("ohaaa")
                    

                   

                      
                    /*
                    if  "\( json["name"])" == "XRP" {
                        
                        let ripple =   Crypto()
                        ripple.name = "\(json["name"])"
                        ripple.priceUsd = "\(json["price_usd"])"
                        ripple.change = "\(json["percent_change_24h"])"
                        
                        ViewController.coins.append(ripple)
                    //        self.insertValuesInDataStore(name: ripple.name, value: Int(ripple.priceUsd)!, change: Int(ripple.change)!)

                        
                        
                    }
                    if  "\( json["name"])" == "Ethereum" {
                        
                        let ether =   Crypto()
                        ether.name = "\(json["name"])"
                        ether.priceUsd = "\(json["price_usd"])"
                        ether.change = "\(json["percent_change_24h"])"

                         ViewController.coins.append(ether)
                        // self.insertValuesInDataStore(name: ether.name, value: Int(ether.priceUsd)!, change: Int(ether.change)!)


                        
                    }
                         if  "\( json["name"])" ==  "Bitcoin Cash" {

                        
                        let bitcoinCash =   Crypto()
                        bitcoinCash.name = "BTCCash"
                        bitcoinCash.priceUsd = "\(json["price_usd"])"
                        bitcoinCash.change = "\(json["percent_change_24h"])"

                         ViewController.coins.append(bitcoinCash)
                          //  self.insertValuesInDataStore(name: bitcoinCash.name, value: Int(bitcoinCash.priceUsd)!, change: Int(bitcoinCash.change)!)


                    }
                    if  "\( json["name"])" ==  "Stellar" {
                        
                        
                        let Stellar =   Crypto()
                        Stellar.name = "\(json["name"])"
                        Stellar.priceUsd = "\(json["price_usd"])"
                        Stellar.change = "\(json["percent_change_24h"])"
                        
                        ViewController.coins.append(Stellar)
                                              //  self.insertValuesInDataStore(name: Stellar.name, value: Int(Stellar.priceUsd)!, change: Int(Stellar.change)!)

                        
                    }
                    
                    
                    if  "\( json["name"])" ==  "Litecoin" {
                        
                        
                        let litcoin =   Crypto()
                        litcoin.name = "\(json["name"])"
                        litcoin.priceUsd = "\(json["price_usd"])"
                        litcoin.change = "\(json["percent_change_24h"])"
                        
                        ViewController.coins.append(litcoin)
                       // self.insertValuesInDataStore(name: litcoin.name, value: Int(litcoin.priceUsd)!, change: Int(litcoin.change)!)

                        
                    }
                    
                    if  "\( json["name"])" ==  "Cardano" {
                        
                        
                        let Cardano =   Crypto()
                        Cardano.name = "\(json["name"])"
                        Cardano.priceUsd = "\(json["price_usd"])"
                        Cardano.change = "\(json["percent_change_24h"])"
                        
                        ViewController.coins.append(Cardano)
                   //     self.insertValuesInDataStore(name: Cardano.name, value: Int(Cardano.priceUsd)!, change: Int(Cardano.change)!)


                        
                    }
                    if  "\( json["name"])" ==  "Monero" {
                        
                        
                        let Monero =   Crypto()
                        Monero.name = "\(json["name"])"
                        Monero.priceUsd = "\(json["price_usd"])"
                        Monero.change = "\(json["percent_change_24h"])"
                        
                        ViewController.coins.append(Monero)
                      //  self.insertValuesInDataStore(name: Monero.name, value: Int(Monero.priceUsd)!, change: Int(Monero.change)!)

                        
                    }
                    
                    
      
                    
                         if  "\( json["name"])" ==  "IOTA" {
                        
                        
                        let IOTA =   Crypto()
                        IOTA.name = "\(json["name"])"
                        IOTA.priceUsd = "\(json["price_usd"])"
                        IOTA.change = "\(json["percent_change_24h"])"
                        
                        ViewController.coins.append(IOTA)
                        //    self.insertValuesInDataStore(name: IOTA.name, value: Int(IOTA.priceUsd)!, change: Int(IOTA.change)!)

                        
                    }
                     if  "\( json["name"])" ==  "Dash" {
                        
                        
                        let Dash =   Crypto()
                        Dash.name = "\(json["name"])"
                        Dash.priceUsd = "\(json["price_usd"])"
                        Dash.change = "\(json["percent_change_24h"])"
                        
                        ViewController.coins.append(Dash)
                      //  self.insertValuesInDataStore(name: Dash.name, value: Int(Dash.priceUsd)!, change: Int(Dash.change)!)
 
                        
                    }
*/
 
               
 
                 }
                
 
             } else {
                print("Error: \(String(describing: response.result.error))")
            }
            
        completed()

       }

        
    
    }

}
