//
//  CurrentDate.swift
//  CryptoCurrency
//
//  Created by Bartu akman on 13.11.2018.
//  Copyright © 2018 Bartu akman. All rights reserved.
//

import UIKit
extension Date {
    // calculate date
    func years() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd"
        return dateFormatter.string(from: self)
    }
    
    func dateFormattedString(_ date: Date) -> String {
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: date)
    }
    
    func dateBySubtractingDays(_ currentDate: Date, numberOfDays: Int) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.day = numberOfDays
        return (Calendar.current as NSCalendar).date(byAdding: .day, value: numberOfDays, to: currentDate, options: NSCalendar.Options(rawValue: 0))!
    }
    
}
