//
//  BarChartFormetter.swift
//  CryptoCurrency
//
//  Created by Bartu akman on 12.11.2018.
//  Copyright © 2018 Bartu akman. All rights reserved.
//
import UIKit
import Foundation
import Charts

@objc(BarChartFormetter)

public class BarChartFormatter: NSObject, IAxisValueFormatter{
    
 // It's need to convert to times variables to Integer
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        return CryptoDetailController.bitcoinTimes[Int(value)]
}
    
}
