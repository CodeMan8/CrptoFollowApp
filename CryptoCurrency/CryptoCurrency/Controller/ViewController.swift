//
//  ViewController.swift
//  CryptoCurrency
//
//  Created by Bartu akman on 30.09.2018.
//  Copyright © 2018 Bartu akman. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
 import Charts
import CoreData

class ViewController: UIViewController {
    
    //Outlets
      @IBOutlet weak var table: UITableView!
      @IBOutlet weak var searchBar: UISearchBar!

    
 // variables
    public var isSearching = false
    static var  coins = [Crypto]()
    var crypto: Crypto!
    var filteredData = [Crypto]()
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    var results: [EntityTable] = []

    
   
    
    func loadData()   {
 
         let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
         let context:NSManagedObjectContext = appDel.persistentContainer.viewContext
         
         let request = NSFetchRequest<NSFetchRequestResult>(entityName: "EntityTable")
         request.returnsObjectsAsFaults = false
         request.returnsDistinctResults = true
        
        do {
            
            results = try context.fetch(request) as! [EntityTable]
            print(results.count)
            print("şurası")
            
            if results.count > 0 {
                
                for result in results  as [NSManagedObject] {
                    
                    if let coinname = result.value(forKey: "name") as? String, let coinValue = result.value(forKey: "value") as? String, let coinChange = result.value(forKey: "change")  as? String {
                        
                        
                        print(coinname)
                        print(String(coinValue))
                        print(String(coinChange))
                        print("Coinname must be somewhere")
                        
                        let coin = Crypto()
                        coin.name = coinname
                        coin.priceUsd = "\(coinValue)"
                        coin.change  = "\(coinChange)"
                        
                        ViewController.coins.append(coin)
                        
                    }
                    
                    
                }
                
 
            } else {
                
                
                initiliazeCrypto()
               
               

 
             }

        }
        catch {
            print("Could not fetched results ")
            
        }
 
       
        
    }

 

    
     override func viewDidLoad() {
 
         super.viewDidLoad()
       
 
         table.delegate = self
        table.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
 
 
       // initiliazeCrypto()
        initiliazeRefreshControl()
        loadData()
 
 
     }
    @IBAction func refreshButton(_ sender: UIButton) {
        refreshData()
        refreshControl.beginRefreshing()
        
        
    }
 
    func initiliazeCrypto () {
        
        crypto  = Crypto()
        
        // we fetch crypto coins from Crypto class and reload table view
        crypto.getJsonData {
            
            DispatchQueue.main.async {
                
               // self.loadData()
                self.table.reloadData()
            }
 
            
            
        }
        

        
    }
    func initiliazeRefreshControl () {
        
        refreshControl.tintColor =  UIColor.orange
        refreshControl.backgroundColor = UIColor.darkGray
        refreshControl.addTarget(self, action: #selector(ViewController.refreshData), for: UIControlEvents.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Data ..", attributes: [NSAttributedStringKey.foregroundColor : refreshControl.tintColor])
        
        if  #available(iOS 10.0, *) {
            
             table.refreshControl = refreshControl
            
        } else {
            table.addSubview(refreshControl)
        }
        
    }
  
    
    @objc func refreshData() {
        
        ViewController.coins.removeAll()
        
        crypto.getJsonData {
            
            // while refresing data we need to reload table view
 
            DispatchQueue.main.async {
                self.loadData()
            
                self.table.reloadData()
                self.refreshControl.endRefreshing()

            }
            
            
        }
    
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
    

    }
    func updateChangeValue(_ oldValue: Double?, cell: TableViewCell) {
        
        var percent = "0.0%"

        guard let oldValue = oldValue else   {return }
        
        percent = "\( String(format: "%.2f", oldValue))%"
        
        if percent == "inf%"  {
            //   infinity  case
            
            cell.percent.text  = "0.0%"
        } else {
            
            
            cell.percent.text  = percent
        }
        
        if oldValue >= 0 {
            
            cell.changeImage.image = UIImage(named: "arrowUpSoftEdge")
            cell.changeImage.backgroundColor = UIColor.bitcoinGreen
        }
        

        
        /*
         If you want to create your percent change function you can use that
 
        guard let oldValue = oldValue, let newValue = newValue else  { return  }
        var percent = "0.0%"
        let difference = newValue - oldValue
        
        let differentPercent = (difference / oldValue) * 100
 
            percent = "\( String(format: "%.2f", differentPercent))%"
 
        if percent == "inf%"  {
            //   infinity sonsuz  değer
            

            cell.percent.text  = "0.0%"
        } else {

        
         cell.percent.text  = percent
        }
 */

        
    }
    

}

extension ViewController : UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
     
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // While refreshing data  we changes background Play with -180 values and Strings
        
        let offset = scrollView.contentOffset.y
        
        if offset < -180 {
            
            
            refreshControl.attributedTitle = NSAttributedString(string: "  Stop fetching  ..", attributes: [NSAttributedStringKey.foregroundColor : refreshControl.tintColor])
        } else {
            refreshControl.attributedTitle = NSAttributedString(string: "Fetching Data ..", attributes: [NSAttributedStringKey.foregroundColor : refreshControl.tintColor])
        }
        refreshControl.backgroundColor = UIColor.darkGray
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            
            return filteredData.count
        }
        
        else {
         
            return ViewController.coins.count
        }
     }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // we display data here
        
        if let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell {
            
            if isSearching {
                
                let    text  = filteredData[indexPath.row].name
                  cell.coin.text = text
 
                return cell
                
            } else {
                
                let coin = ViewController.coins[indexPath.row]
                
                cell.updateUI(p: coin)
                
                updateChangeValue(Double(coin.change)!, cell: cell)
                print("here")
                
                return cell
                
      
  
            }
       
           
        }
        return UITableViewCell()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // When the user search anything we Set section name to "Search" but you can play with that.
        
        let label = UILabel()
         label.backgroundColor = UIColor.blue
        if isSearching {
            label.text = "Search"
            
            return label
        }
        else {
            label.text =  "Today Coins"

        }
        return label
    }
 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text  == nil || searchBar.text == "" {
            
            isSearching = false
            view.endEditing(true)
            
            DispatchQueue.main.async {
                
                self.table.reloadData()
            }
        }
        else {
            
            isSearching = true
          
             let coins = ViewController.coins.filter({ $0.name.lowercased()  == searchBar.text?.lowercased()  })
            

 
            filteredData = coins
            
            
            DispatchQueue.main.async {
                
                self.table.reloadData()
             }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // When the user  click  Coins we goes to  display Charts
        
        switch indexPath.row {
        case 0:
            let coin = "BTCUSD"
            CryptoDetailController.coinType = coin
            
            performSegue(withIdentifier: "New", sender: nil)

         case 1 :
            let coin = "ETHUSD"
            CryptoDetailController.coinType = coin
            performSegue(withIdentifier: "New", sender: nil)
         
         case 2 :
            let coin = "XRPUSD"
            CryptoDetailController.coinType = coin

            performSegue(withIdentifier: "New", sender: nil)

         case 3 :
            let coin =  "BCHUSD"
             CryptoDetailController.coinType = coin
            performSegue(withIdentifier: "New", sender: nil)
        case 4 :
            let coin =  "XLMUSD"
            CryptoDetailController.coinType = coin
            performSegue(withIdentifier: "New", sender: nil)
        case 5 :
            let coin =  "LTCUSD"
            CryptoDetailController.coinType = coin
            performSegue(withIdentifier: "New", sender: nil)
        case 6 :
            let coin =  "ADAUSD"
            CryptoDetailController.coinType = coin
            performSegue(withIdentifier: "New", sender: nil)
        case 7 :
            let coin =  "XMRUSD"
            CryptoDetailController.coinType = coin
            performSegue(withIdentifier: "New", sender: nil)
            
         case 8:
            let coin = "IOTAUSD" 
            CryptoDetailController.coinType = coin
            performSegue(withIdentifier: "New", sender: nil)
        case 9:
            let coin = "DASHUSD"
            CryptoDetailController.coinType = coin
            performSegue(withIdentifier: "New", sender: nil)
        
        default:
            
            return
        }
        
        }
    
   
    
}

