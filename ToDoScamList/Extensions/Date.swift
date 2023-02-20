//
//  Calendar.swift
//  ToDoScamList
//
//  Created by Денис Жестерев on 18.01.2023.
//

import Foundation

extension Date {
    func localDate() -> Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}
        return localDate
    }
    
    static func today() -> Date {
        return Date().localDate().startOfDay
    }
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.next,
                   weekday,
                   considerToday: considerToday)
    }
    
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.previous,
                   weekday,
                   considerToday: considerToday)
    }
    
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {
        
        let dayName = weekDay.rawValue
        
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1
        
        let calendar = Calendar(identifier: .gregorian)
        
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }
        
        var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
        nextDateComponent.weekday = searchWeekdayIndex
        
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)
        
        return date!
    }
    
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
    
    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }
    
    enum SearchDirection {
        case next
        case previous
        
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .next:
                return .forward
            case .previous:
                return .backward
            }
        }
    }
    static let todayDate = Date().localDate().getFormattedDate(format: "dd/MM")
    static let lastSunday = Date.today().previous(.sunday).getFormattedDate(format: "dd/MM")
    static let oneSundayAgo = Date.today().previous(.sunday).previous(.sunday).getFormattedDate(format: "dd/MM")
    static let twoSundayAgo = Date.today().previous(.sunday).previous(.sunday).previous(.sunday).getFormattedDate(format: "dd/MM")
    static let threeSundayAgo = Date.today().previous(.sunday).previous(.sunday).previous(.sunday).previous(.sunday).getFormattedDate(format: "dd/MM")
    static let fourSundayAgo = Date.today().previous(.sunday).previous(.sunday).previous(.sunday).previous(.sunday).previous(.sunday).getFormattedDate(format: "dd/MM")
    static let fiveSundayAgo = Date.today().previous(.sunday).previous(.sunday).previous(.sunday).previous(.sunday).previous(.sunday).previous(.sunday).getFormattedDate(format: "dd/MM")
    static let lastMonday = Date.today().previous(.monday).getFormattedDate(format: "dd/MM")
    static let oneMondayAgo = Date.today().previous(.monday).previous(.monday).getFormattedDate(format: "dd/MM")
    static let twoMondayAgo = Date.today().previous(.monday).previous(.monday).previous(.monday).getFormattedDate(format: "dd/MM")
    static let threeMondayAgo = Date.today().previous(.monday).previous(.monday).previous(.monday).previous(.monday).getFormattedDate(format: "dd/MM")
    static let fourMondayAgo = Date.today().previous(.monday).previous(.monday).previous(.monday).previous(.monday).previous(.monday).getFormattedDate(format: "dd/MM")
    static let fiveMondayAgo = Date.today().previous(.monday).previous(.monday).previous(.monday).previous(.monday).previous(.monday).previous(.monday).getFormattedDate(format: "dd/MM")
    static let oneWeekAgoDate = Date.today().previous(.monday).previous(.monday)
    static let twoWeeksAgoDate = oneWeekAgoDate.previous(.monday)
    static let threeWeeksAgoDate = twoWeeksAgoDate.previous(.monday)
    static let fourWeeksAgoDate = threeWeeksAgoDate.previous(.monday)
    static let fiveWeeksAgoDate = fourWeeksAgoDate.previous(.monday)
    static let monthAgoDate = Calendar(identifier: .iso8601).date(byAdding: .day, value: -30, to: Date())!
}
