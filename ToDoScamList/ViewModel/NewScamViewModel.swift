//
//  NewScamViewModel.swift
//  ToDoScamList
//
//  Created by Denis Zhesterev on 08.02.2023.
//

import Foundation
import CoreData
import Combine

final class NewScamViewModel: ObservableObject {
   @Published var newScamModel = NewScamModel()
    var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    let textLimit = 280
    
    func customTypeOnDone() {
        if newScamModel.types.filter({$0 == newScamModel.alertInput}).count == 0 {
            newScamModel.types.insert(newScamModel.alertInput, at: 0)
            newScamModel.type = newScamModel.alertInput
        } else {
            newScamModel.type = newScamModel.alertInput
        }
    }
    func saveScam() -> Bool {
        if newScamModel.name.count >= 30 || newScamModel.name.isEmpty {
            newScamModel.showsAlertNameCount.toggle()
            return false
        } else {
            let scamInfo = Scam(context: viewContext)
            scamInfo.type = newScamModel.type
            scamInfo.power = newScamModel.power
            scamInfo.selectedDate = newScamModel.selectedDate
            scamInfo.imageD = newScamModel.imageData
            scamInfo.title = newScamModel.name
            scamInfo.scamDescription = newScamModel.description
            do {
                try viewContext.save()
            } catch {
                print("whoops \(error.localizedDescription)")
            }
             return true
        }
    }
    func limitText(_ upper: Int) {
        if newScamModel.description.count > upper {
            newScamModel.description = String(newScamModel.description.prefix(upper))
        }
    }
}
