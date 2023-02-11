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
    let viewContext = PersistenceController.shared.container.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Scam")
    
    func unsortedScams() -> [Scam] {
        do {
            let results = try viewContext.fetch(fetchRequest)
            let entities = results as! [Scam]
            return entities
        } catch let error as NSError {
            print("Fetch request failed: \(error), \(error.userInfo)")
            return []
        }
    }
    var sortedScams : [Scam] {
        switch pickerSelection {
        case(1): return unsortedScams().sorted(by: {$0.selectedDate > $1.selectedDate})
        case(2): return unsortedScams().sorted(by: {$0.title < $1.title})
        case(3): return unsortedScams().sorted(by: {$0.power > $1.power})
        case(4): return unsortedScams().sorted(by: {$0.type > $1.type})
        default: return []
        }
    }
    func onChangeEditScam() {
        sortedScams[indexOfEditScam].title = editInput
        sortedScams[indexOfEditScam].power = editpower
        try? viewContext.save()
    }
}
