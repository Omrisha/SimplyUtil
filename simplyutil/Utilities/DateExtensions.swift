//
//  DateExtensions.swift
//  simplyutil
//
//  Created by Omri Shapira on 23/03/2024.
//

import Foundation

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    
}

extension DateFormatter {

    convenience init (format: String) {
        self.init()
        dateFormat = format
        locale = Locale.current
    }
}

extension String {
    func toDate (dateFormatter: DateFormatter) -> Date? {
        return dateFormatter.date(from: self)
    }

    func toDateString (dateFormatter: DateFormatter, outputFormat: String) -> String? {
        guard let date = toDate(dateFormatter: dateFormatter) else { return nil }
        return DateFormatter(format: outputFormat).string(from: date)
    }
}

extension Date {
    func getTodayWeekDay()-> String{
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "EEE"
       let weekDay = dateFormatter.string(from: self)
       return weekDay
     }

    func toString (dateFormatter: DateFormatter) -> String? {
        return dateFormatter.string(from: self)
    }
}
