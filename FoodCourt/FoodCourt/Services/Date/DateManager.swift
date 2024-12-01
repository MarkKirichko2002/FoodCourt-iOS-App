//
//  DateManager.swift
//  FoodCourt
//
//  Created by Марк Киричко on 03.11.2024.
//

import Foundation

final class DateManager {
    
    let date = Date()
    let dateFormatter = DateFormatter()
    
    var daysOfWeek = ["Вс", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб"]
    
    func convertDate(date: String)-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH-mm"
        let a = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        let formattedDateString = dateFormatter.string(from: a)
        return dateFormatter.string(from: a)
    }

    func getCurrentDate()-> String {
        var currentDate = ""
        dateFormatter.dateFormat = "dd.MM.yyyy"
        currentDate = dateFormatter.string(from: date)
        return currentDate
    }
    
    func getCurrentMonth()-> Int {
        let date = Date()
        let calendar = Calendar.current
        return calendar.component(.month, from: date)
    }
    
    func getCurrentTime(isFullFormat: Bool)-> String {
        let date = Date()
        if isFullFormat {
            dateFormatter.dateFormat = "HH:mm:ss"
        } else {
            dateFormatter.dateFormat = "HH:mm"
        }
        let timeString = dateFormatter.string(from: date)
        return timeString
    }
    
    func getCurrentDayOfWeek(date: String)-> String {
        let calendar = Calendar.current
        dateFormatter.dateFormat = "dd.MM.yyyy"
        if let date = dateFormatter.date(from: date) {
            let dayOfWeek = calendar.component(.weekday, from: date)
            return daysOfWeek[dayOfWeek - 1]
        }
        return ""
    }
    
    func getDate(from weekDay: String)-> String {
        return ""
    }
    
    func getCurrentDayOfWeek(day: Int)-> String {
        let day = daysOfWeek[day]
        return day
    }
    
    func getFormattedDate(date: Date)-> String {
        var currentDate = ""
        dateFormatter.dateFormat = "dd.MM.yyyy"
        currentDate = dateFormatter.string(from: date)
        return currentDate
    }
    
    func getFormattedTime(date: Date)-> String {
        var currentDate = ""
        dateFormatter.dateFormat = "HH:mm"
        currentDate = dateFormatter.string(from: date)
        return currentDate
    }
    
    func isTimeCorrect(time1: Date, time2: Date)-> Bool {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        
        let comparisonResult = time1.compare(time2)
        let interval = time1.timeIntervalSince(time2)
        
        if comparisonResult == .orderedAscending {
            return false
        } else if comparisonResult == .orderedSame {
            return false
        }
        
        return false
    }
    
    func isValidTime(time: Date)-> Bool {
        
        let calendar = Calendar.current
            
        let components = calendar.dateComponents([.hour, .minute], from: time)
        let hour = (components.hour ?? 0)
        let minutes = (components.minute ?? 0)
        
        print("\(abs(hour)):\(abs(minutes))")
        
        if (abs(hour) > 21) || (abs(hour) < 9) {
            return false
        } else if (abs(hour) == 21 && minutes > 30) {
            return false
        } else if (abs(hour) <= 22) {
            return true
        } else {
            return false
        }
    }

    func getDateFromString(str: String, withTime: Bool)-> Date? {
        if withTime {
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        } else {
            dateFormatter.dateFormat = "dd.MM.yyyy"
        }
        if let currentDate = dateFormatter.date(from: str) {
            return currentDate
        }
        return nil
    }
}
