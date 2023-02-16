//
//  Sorting.swift
//  ToDoScamList
//
//  Created by Denis Zhesterev on 12.02.2023.
//

import Foundation
import SwiftUI
import CoreData


class MainViewModel: ObservableObject {
    @Published var model = MainModel()
    let concurrentQueue = DispatchQueue(label: "scam.stat", qos: .userInitiated, attributes: .concurrent)
    let fetchRequest = NSFetchRequest<ScamCoreData>(entityName: "ScamCoreData")
    
    func fetchData() -> [ScamCoreData] {
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            return results
        }
        catch {
            print("Error fetching data")
            return []
        }
    }
    var sortedScams: [ScamCoreData] {
        switch model.pickerSelection {
        case(1): return fetchData().sorted(by: {$0.selectedDate > $1.selectedDate})
        case(2): return fetchData().sorted(by: {$0.title < $1.title})
        case(3): return fetchData().sorted(by: {$0.power > $1.power})
        case(4): return fetchData().sorted(by: {$0.type > $1.type})
        default: return []
        }
    }
    func updateView() {
        model.pickerSelection += 1
        model.pickerSelection -= 1
    }

    func onChangeEditScam() {
            let editScam = sortedScams[model.indexOfEditScam] as NSManagedObject
            editScam.setValue(model.editInput, forKey: "title")
            editScam.setValue(model.editpower, forKey: "power")
            CoreDataManager.instance.saveContext()
            updateView()
    }
    
    func placeholderTextField(item: ScamCoreData) {
        model.editInput = item.title
        model.editpower = item.power
        if let unwrapped = sortedScams.firstIndex(of: item) {model.indexOfEditScam = unwrapped}
    }
    
    func deleteScam(item: ScamCoreData) {
        if let unwrapped = sortedScams.firstIndex(of: item) {model.indexOfEditScam = unwrapped}
        CoreDataManager.instance.managedObjectContext.delete(item)
        CoreDataManager.instance.saveContext()
    }
    
    func showImage(item: ScamCoreData) {
        if item.imageD != Data() {
            if let unwrapped = sortedScams.firstIndex(of: item) {model.indexOfImage = unwrapped}
            model.showImage = Image(uiImage: UIImage(data: sortedScams[model.indexOfImage].imageD ?? Data()) ?? UIImage(imageLiteralResourceName: "Scam"))
            model.imageIsShown.toggle()
        }
    }
    
    func newOrSystemImage(item: ScamCoreData) -> Image {
        if item.imageD != Data() {
            return Image(uiImage: UIImage(data: item.imageD ?? Data()) ?? UIImage())
        } else {
            return Image("Scam")
        }
    }
    
    func prinWillSet() {
        print("willset works")
    }
    
    func toggleEditIsShown() {
        model.editIsShown.toggle()
    }
    
    func toggleMdIsShown() {
        model.mdIsShown.toggle()
    }
    
    func findIndexForMdView(item: ScamCoreData) {
        if let unwrapped = sortedScams.firstIndex(of: item) {model.indexOfMoreDetailed = unwrapped}
        if let unwrapped = sortedScams[model.indexOfMoreDetailed].imageD {model.image = unwrapped}
    }
    
    func computedStatistic() {
        concurrentQueue.async {
            self.globalStat(scam: self.sortedScams, index: self.model.indexOfMoreDetailed)
        }
        concurrentQueue.async {
            self.monthStat(scam: self.sortedScams, index: self.model.indexOfMoreDetailed)
        }
        concurrentQueue.async {
            self.weekStat(scam: self.sortedScams, index: self.model.indexOfMoreDetailed)
        }
    }
    
    func monthStat(scam: [ScamCoreData], index: Int) {
        let last30DayScams = scam.filter({$0.selectedDate > Date.monthAgoDate})
        let last30dayPower = last30DayScams.map({Int($0.power)}).reduce(0, +)
        let last30daySameTypeCount = last30DayScams.filter({$0.type == scam[index].type}).count
        let averagePowerOfLast30day = (Double(last30dayPower) / Double(last30DayScams.count)*100).rounded()/100
        DispatchQueue.main.async {
            self.model.last30dayPower = last30dayPower
            self.model.last30daySameTypeCount = last30daySameTypeCount
            self.model.averagePowerOfLast30day = averagePowerOfLast30day
        }
    }
    
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
        let averagePowerOfAll = (allPower / Double(scam.count)*100).rounded()/100
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
            self.model.id = iD
            self.model.title = title
            self.model.type = type
            self.model.description = description
            self.model.sameTypeCount = sameTypeCount
            self.model.allPower = allPower
            self.model.averagePowerOfAll = averagePowerOfAll
            self.model.averagePowerSameType = averagePowerSameType
            self.model.mostFrequentTypeCount = mostFrequentTypeCount
            self.model.mostFrequentType = mostFrequentType
            self.model.eachTypeCount = eachTypeCount
            self.model.allTypes = allTypes
        }
    }
  
    func weekStat(scam: [ScamCoreData], index: Int) {
        let currentWeekScams = scam.filter({$0.selectedDate > Date.today().previous(.monday)})
        let oneWeekAgoScams = scam.filter({($0.selectedDate > Date.oneWeekAgoDate) && ($0.selectedDate < Date.today().previous(.monday))})
        let twoWeeksAgoScams = scam.filter({($0.selectedDate > Date.twoWeeksAgoDate) && ($0.selectedDate < Date.oneWeekAgoDate)})
        let threeWeeksAgoScams = scam.filter({($0.selectedDate > Date.threeWeeksAgoDate) && ($0.selectedDate < Date.twoWeeksAgoDate)})
        let fourWeeksAgoScams = scam.filter({($0.selectedDate > Date.fourWeeksAgoDate) && ($0.selectedDate < Date.threeWeeksAgoDate)})
        let fiveWeeksAgoScams = scam.filter({($0.selectedDate > Date.fiveWeeksAgoDate) && ($0.selectedDate < Date.fourWeeksAgoDate)})
        let currentWeekSameTypeCount = currentWeekScams.filter({$0.type == scam[index].type}).count
        let currentWeekPower = currentWeekScams.map({Int($0.power)}).reduce(0, +)
        let oneWeekAgoPower = oneWeekAgoScams.map({Int($0.power)}).reduce(0, +)
        let twoWeeksAgoPower = twoWeeksAgoScams.map({Int($0.power)}).reduce(0, +)
        let threeWeeksAgoPower = threeWeeksAgoScams.map({Int($0.power)}).reduce(0, +)
        let fourWeeksAgoPower = fourWeeksAgoScams.map({Int($0.power)}).reduce(0, +)
        let fiveWeeksAgoPower = fiveWeeksAgoScams.map({Int($0.power)}).reduce(0, +)
        DispatchQueue.main.async {
            self.model.currentWeekSameTypeCount = currentWeekSameTypeCount
            self.model.currentWeekPower = currentWeekPower
            self.model.oneWeekAgoPower = oneWeekAgoPower
            self.model.twoWeeksAgoPower = twoWeeksAgoPower
            self.model.threeWeeksAgoPower = threeWeeksAgoPower
            self.model.fourWeeksAgoPower = fourWeeksAgoPower
            self.model.fiveWeeksAgoPower = fiveWeeksAgoPower
        }
    }
    
    func mDtoggleEditIsShown() {
        model.mDeditIsShown.toggle()
    }
}
