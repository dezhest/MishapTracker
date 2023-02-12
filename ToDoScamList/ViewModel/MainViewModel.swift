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
    @Published var editIsCanceled = false
    @Published var editInput = ""
    @Published var editpower: Double = 0
    @Published var indexOfEditScam = 0
    @Published var pickerSelection = 1
    @Published var indexOfImage = 0
    @Published var showImage = Image("Scam")
    @Published var imageIsShown = false
    @Published var model = MainModel()
    @ObservedObject var stat = StatisticModel()
    let concurrentQueue = DispatchQueue(label: "scam.stat", qos: .userInitiated, attributes: .concurrent)
    
    
    let viewContext = PersistenceController.shared.container.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Scam")
    func unsortedScams() -> [Scam] {
        do {
            let results = try viewContext.fetch(fetchRequest)
            let entities = results as! [Scam]
            switch pickerSelection {
            case(1): return entities.sorted(by: {$0.selectedDate > $1.selectedDate})
            case(2): return entities.sorted(by: {$0.title < $1.title})
            case(3): return entities.sorted(by: {$0.power > $1.power})
            case(4): return entities.sorted(by: {$0.type > $1.type})
            default: return []
            }
        }
        catch {
            print("error")
            return []
        }
    }
    
    func onChangeEditScam() {
        unsortedScams()[indexOfEditScam].title = editInput
        unsortedScams()[indexOfEditScam].power = editpower
        try? viewContext.save()
    }
    
    func placeholderTextField(item: Scam) {
        editInput = item.title
        editpower = item.power
        if let unwrapped = unsortedScams().firstIndex(of: item) {indexOfEditScam = unwrapped}
    }
    
    func deleteScam(item: Scam) {
        if let unwrapped = unsortedScams().firstIndex(of: item) {indexOfEditScam = unwrapped}
        viewContext.delete(item)
        try? viewContext.save()
    }
    
    func showImage(item: Scam) {
        if item.imageD != Data() {
            if let unwrapped = unsortedScams().firstIndex(of: item) {indexOfImage = unwrapped}
            showImage = Image(uiImage: UIImage(data: unsortedScams()[indexOfImage].imageD ?? Data()) ?? UIImage(imageLiteralResourceName: "Scam"))
            self.imageIsShown.toggle()
        }
    }
    
    func newOrSystemImage(item: Scam) -> Image {
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
    
    func findIndexForMdView(item: Scam) {
        if let unwrapped = unsortedScams().firstIndex(of: item) {model.indexOfMoreDetailed = unwrapped}
        if let unwrapped = unsortedScams()[model.indexOfMoreDetailed].imageD {stat.mDImage = unwrapped}
    }
    
    func computedStatistic() {
        concurrentQueue.async {
            self.stat.globalStat(scam: self.unsortedScams(), index: self.model.indexOfMoreDetailed)
        }
        concurrentQueue.async {
            self.stat.monthStat(scam: self.unsortedScams(), index: self.model.indexOfMoreDetailed)
        }
        concurrentQueue.async {
            self.stat.weekStat(scam: self.unsortedScams(), index: self.model.indexOfMoreDetailed)
        }
    }
}
