//
//  CryptoDetailController.swift
//  CryptoCurrency
//
//  Created by Bartu akman on 13.11.2018.
//  Copyright © 2018 Bartu akman. All rights reserved.
//

import UIKit
import Charts
import ChartsRealm
import Alamofire

class CryptoDetailController: UIViewController {
    
    @IBOutlet weak var lineChart: LineChartView!
 
    
    var months: [String]!
    var dataEntries: [ChartDataEntry] = []
    var crypto: Crypto!
 
    static var bitcoinaverages = [Double]()
    static var  bitcoinTimes = [String]()
    static var coinType : String?

 
   
    static  var selectedSegmentIndex: String =   Interval.Day.rawValue
        
    
    
 
    @IBAction func BackButton(_ sender: UIButton) {
        // go back to main Class
        dismiss(animated: true, completion: nil)
        clearChart()
        
    }
    
    @IBAction func chooseType(_ sender: Any) {
        
        let index =   (sender as AnyObject).selectedSegmentIndex!
        
        if index == 0 {
          
            
            CryptoDetailController.selectedSegmentIndex =     Interval.Day.rawValue
            
        }
        
       if index == 1 {
                    CryptoDetailController.selectedSegmentIndex =    Interval.Month.rawValue
 
        }
        if index == 2 {
            CryptoDetailController.selectedSegmentIndex =   Interval.All.rawValue
 

        }
  
      clearChart()
        
      crypto.get {
        
                DispatchQueue.main.async(execute: { () -> Void in
 
                    self.setChart(dataPoints: CryptoDetailController.bitcoinTimes, values: CryptoDetailController.bitcoinaverages)
                    
 
                })
                
         }
        
 
    }
    func clearChart() {
        
         dataEntries.removeAll()
        CryptoDetailController.bitcoinaverages.removeAll()
        CryptoDetailController.bitcoinTimes.removeAll()
        
    }

    

    
    override func viewDidLoad() {
        
         super.viewDidLoad()
        lineChart.delegate = self
 
         crypto = Crypto()
 
 
  
        crypto.get {
 
            DispatchQueue.main.async(execute: { () -> Void in
                
                self.setChart(dataPoints: CryptoDetailController.bitcoinTimes, values: CryptoDetailController.bitcoinaverages)


            })
 
                
        }
       
  
     }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
     }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        // In order to display Chart we need this function
        // change with  chartDataSet values whatever you want
        // With BalloonMarker user can  click the coin values and show that. You can change the color font size or dimension
        // with Target you can add line to your chart
         
        let formato: BarChartFormatter = BarChartFormatter()
        let xaxis:XAxis = XAxis()
        
        lineChart.noDataText = "Please wait for loading chart ."
        var position = 0.0
 
        
        for i in(0..<dataPoints.count){
            
            let  dataEntry =   ChartDataEntry(x:Double(position) , y: values[i])
            dataEntries.append(dataEntry)
            formato.stringForValue(Double(position), axis: xaxis)
            position += 1.0
 
 
            
        }
        
        xaxis.valueFormatter = formato
        lineChart.xAxis.valueFormatter = xaxis.valueFormatter
        
        
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Units Sold")
        let chartData = LineChartData(dataSet: chartDataSet)
        
        lineChart.data = chartData
        chartDataSet.colors = [UIColor.bitcoinRed]
        
         chartDataSet.highlightLineDashLengths = [2.5, 2.5]
        chartDataSet.highlightColor = NSUIColor.black
        chartDataSet.highlightLineWidth = 1.0
        
        lineChart.xAxis.labelPosition = .bothSided
        lineChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        
        let marker: BalloonMarker = BalloonMarker(color: UIColor.bitcoinRed, font: UIFont.systemFont(ofSize: 14.0), textColor: UIColor.bitcoinGreen, insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0))
        marker.minimumSize = CGSize(width: 40.0, height: 40.0)
        lineChart.marker = marker
        
        let line = ChartLimitLine(limit: 6350, label: "Target")
        lineChart.rightAxis.addLimitLine(line)
       
        
         lineChart.rightAxis.drawGridLinesEnabled = false
 
 
     }
   

    

}
extension   CryptoDetailController:    ChartViewDelegate   {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
         // print(highlight.y)
        
        // When the user click chart
    }
 
}

