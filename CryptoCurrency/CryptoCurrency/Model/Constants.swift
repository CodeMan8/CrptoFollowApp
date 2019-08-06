//
//  Constants.swift
//  CryptoCurrency
//
//  Created by Bartu akman on 30.09.2018.
//  Copyright © 2018 Bartu akman. All rights reserved.
//

import Foundation
// we use baseURL for fetch crypto data  and    display on table view 
 let baseUrl = "https://api.coinmarketcap.com/v1/ticker/?convert=TRY&limit=14"

// let url = "https://apiv2.bitcoinaverage.com/indices/global/history/ETHUSD?period=alltime&?format=json"
  typealias DownloadComplete = () -> ()

let today = Date()
let date : Date = Date()
let daysAgo = date.dateBySubtractingDays(today, numberOfDays: -(4 * 1)-3)

let todayFormatted: String = date.dateFormattedString(today)
let daysAgoFormatted: String = date.dateFormattedString(daysAgo)

 



