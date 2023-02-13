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
    @ObservedObject var stat = StatisticModel()
    let concurrentQueue = DispatchQueue(label: "scam.stat", qos: .userInitiated, attributes: .concurrent)
    let fetchRequest = NSFetchRequest<ScamCoreData>(entityName: "ScamCoreData")
    
    func fetchData() -> [ScamCoreData] {
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            return results.sorted(by: {$0.selectedDate > $1.selectedDate})
        }
        catch {
            print("Error fetching data")
            return []
        }
    }
                                              
    func sortedScams() -> [ScamCoreData] {
        switch model.pickerSelection {
        case(1): return fetchData().sorted(by: {$0.selectedDate > $1.selectedDate})
        case(2): return fetchData().sorted(by: {$0.title < $1.title})
        case(3): return fetchData().sorted(by: {$0.power > $1.power})
        case(4): return fetchData().sorted(by: {$0.type > $1.type})
        default: return []
        }
    }

    
    func onChangeEditScam() {
        sortedScams()[model.indexOfEditScam].title = model.editInput
        sortedScams()[model.indexOfEditScam].power = model.editpower
        CoreDataManager.instance.saveContext()
    }
    
    func placeholderTextField(item: ScamCoreData) {
        model.editInput = item.title
        model.editpower = item.power
        if let unwrapped = sortedScams().firstIndex(of: item) {model.indexOfEditScam = unwrapped}
    }
    
    func deleteScam(item: ScamCoreData) {
        if let unwrapped = sortedScams().firstIndex(of: item) {model.indexOfEditScam = unwrapped}
        CoreDataManager.instance.managedObjectContext.delete(item)
        CoreDataManager.instance.saveContext()
    }
    
    func showImage(item: ScamCoreData) {
        if item.imageD != Data() {
            if let unwrapped = sortedScams().firstIndex(of: item) {model.indexOfImage = unwrapped}
            model.showImage = Image(uiImage: UIImage(data: sortedScams()[model.indexOfImage].imageD ?? Data()) ?? UIImage(imageLiteralResourceName: "Scam"))
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
        if let unwrapped = sortedScams().firstIndex(of: item) {model.indexOfMoreDetailed = unwrapped}
        if let unwrapped = sortedScams()[model.indexOfMoreDetailed].imageD {stat.mDImage = unwrapped}
    }
    
    func computedStatistic() {
        concurrentQueue.async {
            self.stat.globalStat(scam: self.sortedScams(), index: self.model.indexOfMoreDetailed)
        }
        concurrentQueue.async {
            self.stat.monthStat(scam: self.sortedScams(), index: self.model.indexOfMoreDetailed)
        }
        concurrentQueue.async {
            self.stat.weekStat(scam: self.sortedScams(), index: self.model.indexOfMoreDetailed)
        }
    }
}
