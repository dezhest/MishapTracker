//
//  StatisticModel.swift
//  ToDoScamList
//
//  Created by Denis Zhesterev on 30.01.2023.
//

import Foundation

final class StatisticComputing: ObservableObject {
    @Published var name = ""
    @Published var power: Double = 0
    @Published var selectedDate = Date()
    @Published var calendarId: Int = 0
    @Published var description = ""
    @Published var imageData: Data = .init(capacity: 0)
    @Published var types: [String] = [""]
    @Published var type = "Финансовый"
    @Published var mDID = ObjectIdentifier(AnyObject.self)
    @Published var mDTitle = ""
    @Published var mDType = ""
    @Published var mDImage = Data()
    @Published var mDDescription = ""
    @Published var mDSameTypeCount = 0
    @Published var mDaveragePowerSameType = 0.0
    @Published var mDallPower = 0.0
    @Published var mDaveragePowerOfAll = 0.0
    @Published var mDmostFrequentTypeCount = 0
    @Published var mDmostFrequentType = ""
    @Published var mDlast30dayPower = 0
    @Published var mDlast30daySameTypeCount = 0
    @Published var mDaveragePowerOfLast30day = 0.0
    @Published var mDcurrentWeekSameTypeCount = 0
    @Published var mDcurrentWeekPower = 0
    @Published var mDoneWeekAgoPower = 0
    @Published var mDtwoWeeksAgoPower = 0
    @Published var mDthreeWeeksAgoPower = 0
    @Published var mDfourWeeksAgoPower = 0
    @Published var mDfiveWeeksAgoPower = 0
    @Published var mDeachTypeCount = [Int]()
    @Published var mDallTypes = [String]()
    
    func globalStat(scam: [ScamCoreData], index: Int) {
        let allTypes = scam.map({$0.type}).removingDuplicates()
        let arrayallPower = scam.map({Int($0.power)})
        let sameTypeScams = scam.filter({$0.type == scam[index].type})
        let sameTypeAllPower = (Double(sameTypeScams.map({Int($0.power)}).reduce(0, +))*100).rounded()/100
        let arrayAllType = scam.map({$0.type})
        let iD = scam[index].id
        let title = scam[index].title
        let type = scam[index].type
        let description = scam[index].scamDescription
        let sameTypeCount = scam.filter({$0.type == scam[index].type}).count
        let allPower = (Double(arrayallPower.reduce(0, +))*100).rounded()/100
        let averagePowerOfAll = (mDallPower / Double(scam.count)*100).rounded()/100
        let averagePowerSameType = (sameTypeAllPower / Double(sameTypeScams.count)*100).rounded()/100
        let eachTypeCount = findEachTypeCount()
        var mostFrequentTypeCount = 0
        var mostFrequentType = ""
        func mostFrequent<T: Hashable>(array: [T]) -> (value: T, count: Int)? {
            let counts = array.reduce(into: [:]) { $0[$1, default: 0] += 1 }
            if let (value, count) = counts.max(by: { $0.1 < $1.1 }) {
                return (value, count)
            }
            return nil
        }
        if let result = mostFrequent(array: arrayAllType) {
            if result.count == 1 && arrayAllType.count != 1 {
                mostFrequentType = "-"
                mostFrequentTypeCount = 0
            } else {
                mostFrequentType = result.value
                mostFrequentTypeCount = result.count
            }
        }
        func findEachTypeCount() -> [Int] {
            var eachTypeCount = [Int]()
            for item in allTypes.removingDuplicates() {
                eachTypeCount.append(allTypes.filter({$0 == item}).count)
            }
            return(eachTypeCount)
        }
        DispatchQueue.main.async{
            self.mDID = iD
            self.mDTitle = title
            self.mDType = type
            self.mDDescription = description
            self.mDSameTypeCount = sameTypeCount
            self.mDallPower = allPower
            self.mDaveragePowerOfAll = averagePowerOfAll
            self.mDaveragePowerSameType = averagePowerSameType
            self.mDmostFrequentTypeCount = mostFrequentTypeCount
            self.mDmostFrequentType = mostFrequentType
            self.mDeachTypeCount = eachTypeCount
            self.mDallTypes = allTypes
        }
    }
    func monthStat(scam: [ScamCoreData], index: Int) {
        let last30DayScams = scam.filter({$0.selectedDate > CalendarWeeksAgo().monthAgoDate})
        let last30dayPower = last30DayScams.map({Int($0.power)}).reduce(0, +)
        let last30daySameTypeCount = last30DayScams.filter({$0.type == scam[index].type}).count
        let averagePowerOfLast30day = (Double(last30dayPower) / Double(last30DayScams.count)*100).rounded()/100
        DispatchQueue.main.async {
            self.mDlast30dayPower = last30dayPower
            self.mDlast30daySameTypeCount = last30daySameTypeCount
            self.mDaveragePowerOfLast30day = averagePowerOfLast30day
        }
    }
    func weekStat(scam: [ScamCoreData], index: Int) {
        let currentWeekScams = scam.filter({$0.selectedDate > Date.today().previous(.monday)})
        let oneWeekAgoScams = scam.filter({($0.selectedDate > CalendarWeeksAgo().oneWeekAgoDate) && ($0.selectedDate < Date.today().previous(.monday))})
        let twoWeeksAgoScams = scam.filter({($0.selectedDate > CalendarWeeksAgo().twoWeeksAgoDate) && ($0.selectedDate < CalendarWeeksAgo().oneWeekAgoDate)})
        let threeWeeksAgoScams = scam.filter({($0.selectedDate > CalendarWeeksAgo().threeWeeksAgoDate) && ($0.selectedDate < CalendarWeeksAgo().twoWeeksAgoDate)})
        let fourWeeksAgoScams = scam.filter({($0.selectedDate > CalendarWeeksAgo().fourWeeksAgoDate) && ($0.selectedDate < CalendarWeeksAgo().threeWeeksAgoDate)})
        let fiveWeeksAgoScams = scam.filter({($0.selectedDate > CalendarWeeksAgo().fiveWeeksAgoDate) && ($0.selectedDate < CalendarWeeksAgo().fourWeeksAgoDate)})
        let currentWeekSameTypeCount = currentWeekScams.filter({$0.type == scam[index].type}).count
        let currentWeekPower = currentWeekScams.map({Int($0.power)}).reduce(0, +)
        let oneWeekAgoPower = oneWeekAgoScams.map({Int($0.power)}).reduce(0, +)
        let twoWeeksAgoPower = twoWeeksAgoScams.map({Int($0.power)}).reduce(0, +)
        let threeWeeksAgoPower = threeWeeksAgoScams.map({Int($0.power)}).reduce(0, +)
        let fourWeeksAgoPower = fourWeeksAgoScams.map({Int($0.power)}).reduce(0, +)
        let fiveWeeksAgoPower = fiveWeeksAgoScams.map({Int($0.power)}).reduce(0, +)
        DispatchQueue.main.async {
            self.mDcurrentWeekSameTypeCount = currentWeekSameTypeCount
            self.mDcurrentWeekPower = currentWeekPower
            self.mDoneWeekAgoPower = oneWeekAgoPower
            self.mDtwoWeeksAgoPower = twoWeeksAgoPower
            self.mDthreeWeeksAgoPower = threeWeeksAgoPower
            self.mDfourWeeksAgoPower = fourWeeksAgoPower
            self.mDfiveWeeksAgoPower = fiveWeeksAgoPower
        }
    }


}
