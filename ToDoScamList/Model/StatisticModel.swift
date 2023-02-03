//
//  StatisticModel.swift
//  ToDoScamList
//
//  Created by Denis Zhesterev on 30.01.2023.
//

import Foundation
final class StatisticModel: ObservableObject {
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
}
