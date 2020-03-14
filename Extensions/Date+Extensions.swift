//
//  Date+Extensions.swift
//  Key for Tesla Purchases
//
//  Created by Luke Allen on 2/17/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import Foundation

extension Date {
    
    var timeDateFormat: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "h:mm a"
        let time = fmt.string(from: self)
        let day = fmt.weekdaySymbols[Calendar.current.component(.weekday, from: self) - 1]
        let month = fmt.monthSymbols[Calendar.current.component(.month, from: self) - 1]
        fmt.dateFormat = "d"
        let dayNum = fmt.string(from: self)
        return "\(time), \(day), \(month) \(dayNum)"
    }
    
}
