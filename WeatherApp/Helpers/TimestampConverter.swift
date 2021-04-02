//
//  TimestampConverter.swift
//  WeatherApp
//
//  Created by Ilya Kharebashvili on 31.03.2021.
//

import Foundation

class TimestampConverter {
    
    
    static func convertToDate(dateFormat: String, timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.short //Set date style
        dateFormatter.timeZone = .current
        
        return dateFormatter.string(from: date)
    }
    
    static func getDayOfWeek(timestamp: Double)->String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "Y-m-d"
        let todayDate = Date(timeIntervalSince1970: timestamp)
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: todayDate)
        let weekDay = myComponents.weekday
        switch weekDay {
        case 1:
            return "Sun"
        case 2:
            return "Mon"
        case 3:
            return "Tue"
        case 4:
            return "Wed"
        case 5:
            return "Thu"
        case 6:
            return "Fri"
        case 7:
            return "Sat"
        default:
            print("Error fetching days")
            return "Day"
        }
    }
    
    static func getFormatedDate(format: String, timestamp: Double?) -> String {
        if (timestamp != nil) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format
            let date = Date(timeIntervalSince1970: timestamp!)
            
            return dateFormatter.string(from: date)
        } else {
            return "Hour"
        }
        
    }
    
}
