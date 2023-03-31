//
//  Sorting.swift
//  ToDoScamList
//
//  Created by Denis Zhesterev on 12.02.2023.
//

import Foundation
import SwiftUI
import CoreData
import SwiftUICharts


class MainViewModel: ObservableObject {
    @Published var model = MainModel()
    @Published var statisticModel = StatisticModel()
    let concurrentQueue = DispatchQueue(label: "scam.stat", qos: .userInitiated, attributes: .concurrent)
    let fetchRequest = NSFetchRequest<ScamCoreData>(entityName: "ScamCoreData")
    @Published var editIsShown = false {
        didSet {
            if !editIsShown {
                saveToDataEditScam()
            }
        }
    }
    @Published var mDeditIsShown = false {
        didSet {
            model.description = model.mDeditInput
            if !mDeditIsShown {
                saveToDataEditDescription()
            }
        }
    }
    
    func getImage() -> Image {
        if model.image != Data() {
            return Image(uiImage: UIImage(data: model.image) ?? UIImage())
        } else {
            return Image("Scam")
        }
    }
    
    
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
    
    func mDtoggleEditIsShown() {
        mDeditIsShown.toggle()
    }
    
    var sortedScams: [ScamCoreData] {
        switch model.pickerSelection {
        case(SortType.date): return fetchData().sorted(by: {$0.selectedDate > $1.selectedDate})
        case(SortType.name): return fetchData().sorted(by: {$0.title < $1.title})
        case(SortType.power): return fetchData().sorted(by: {$0.power > $1.power})
        case(SortType.type): return fetchData().sorted(by: {$0.type > $1.type})
        }
    }
    
        func toggleNewScamIsShown() {
            model.newScamIsShown.toggle()
        }


    func saveToDataEditScam() {
            let editScam = sortedScams[model.indexOfEditScam] as NSManagedObject
            editScam.setValue(model.editInput, forKey: "title")
            editScam.setValue(model.editpower, forKey: "power")
            CoreDataManager.instance.saveContext()
    }
    
    func saveToDataEditDescription() {
        let editDescription = sortedScams[model.indexOfMoreDetailed] as NSManagedObject
        editDescription.setValue(model.description, forKey: "scamDescription")
                CoreDataManager.instance.saveContext()
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
    
    func toggleEditIsShown() {
        editIsShown.toggle()
    }
    
    func toggleMdIsShown() {
        model.mdIsShown.toggle()
    }
    
    func findIndexForMdView(item: ScamCoreData) {
        if let unwrapped = sortedScams.firstIndex(of: item) {model.indexOfMoreDetailed = unwrapped}
        if let unwrapped = sortedScams[model.indexOfMoreDetailed].imageD {model.image = unwrapped}
    }
    
    func computeStatistic() {
        concurrentQueue.async {
            self.computeGlobalStatistic(scam: self.sortedScams, index: self.model.indexOfMoreDetailed)
        }
        concurrentQueue.async {
            self.computeWeekStatistic(scam: self.sortedScams, index: self.model.indexOfMoreDetailed)
        }
        concurrentQueue.async {
            self.computeWeekStatistic(scam: self.sortedScams, index: self.model.indexOfMoreDetailed)
        }
    }
    
    func computeMonthStatistic(scam: [ScamCoreData], index: Int) {
        let last30DayScams = scam.filter({$0.selectedDate > Date.monthAgoDate})
        let last30dayPower = last30DayScams.map({Int($0.power)}).reduce(0, +)
        let last30daySameTypeCount = last30DayScams.filter({$0.type == scam[index].type}).count
        let averagePowerOfLast30day = (Double(last30dayPower) / Double(last30DayScams.count)*100).rounded()/100
        DispatchQueue.main.async {
            self.statisticModel.last30dayPower = last30dayPower
            self.statisticModel.last30daySameTypeCount = last30daySameTypeCount
            self.statisticModel.averagePowerOfLast30day = averagePowerOfLast30day
        }
    }
    
    func computeGlobalStatistic(scam: [ScamCoreData], index: Int) {
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
            var funceachTypeCount = [Int]()
            for item in allTypes.removingDuplicates() {
                funceachTypeCount.append(scam.map({$0.type}).filter({$0 == item}).count)
            }
            return(funceachTypeCount)
        }
        
        DispatchQueue.main.async{
            self.statisticModel.id = iD
            self.model.title = title
            self.statisticModel.type = type
            self.model.description = description
            self.statisticModel.sameTypeCount = sameTypeCount
            self.statisticModel.allPower = allPower
            self.statisticModel.averagePowerOfAll = averagePowerOfAll
            self.statisticModel.averagePowerSameType = averagePowerSameType
            self.statisticModel.mostFrequentTypeCount = mostFrequentTypeCount
            self.statisticModel.mostFrequentType = mostFrequentType
            self.statisticModel.eachTypeCount = eachTypeCount
            self.statisticModel.allTypes = allTypes
        }
    }
  
    func computeWeekStatistic(scam: [ScamCoreData], index: Int) {
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
            self.statisticModel.currentWeekSameTypeCount = currentWeekSameTypeCount
            self.statisticModel.currentWeekPower = currentWeekPower
            self.statisticModel.oneWeekAgoPower = oneWeekAgoPower
            self.statisticModel.twoWeeksAgoPower = twoWeeksAgoPower
            self.statisticModel.threeWeeksAgoPower = threeWeeksAgoPower
            self.statisticModel.fourWeeksAgoPower = fourWeeksAgoPower
            self.statisticModel.fiveWeeksAgoPower = fiveWeeksAgoPower
        }
    }

    
    func findPieChartData() -> [PieChartData] {
        var pieChartData = [PieChartData]()
        var item = 0
        repeat {
            pieChartData.append(PieChartData(label: statisticModel.allTypes[item], value: Double(statisticModel.eachTypeCount[item])))
            item += 1
        }
        while statisticModel.allTypes.count > item
                return pieChartData
    }
}
