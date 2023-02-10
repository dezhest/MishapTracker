//
//  NewScamViewModel.swift
//  ToDoScamList
//
//  Created by Denis Zhesterev on 08.02.2023.
//

import Foundation
import CoreData
import Combine
import SwiftUI

final class NewScamViewModel: ObservableObject {
    @Published var newScamModel = NewScamModel()
    private var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    let textLimit = 280
    var viewDismissal = PassthroughSubject<Bool, Never>()
    private var shouldDismissView = false {
        didSet {
            viewDismissal.send(shouldDismissView)
        }
    }
    
    func dismissView() {
            self.shouldDismissView = true
    }
    
    func toggleNewScamIsShown() {
        newScamModel.newScamIsShown.toggle()
    }
    
    func toggleAddCustomTypeIsShown() {
        newScamModel.showsAddCustomType.toggle()
        newScamModel.type = "Финансовый"
    }
    
    func onAppearSavedOrDefaultTypes() {
        newScamModel.types = UserDefaults.standard.stringArray(forKey: "typess") ?? ["Эмоциональный", "Финансовый", "Свой тип", "Очистить типы"]
    }
    
    func customTypeTapped() {
        if newScamModel.type == "Свой тип" {
            withAnimation(.spring()) {
                newScamModel.showsAddCustomType.toggle()
            }
        }
    }
    
    func clearTypeTapped() {
        if newScamModel.type == "Очистить типы" {
            newScamModel.types = ["Эмоциональный", "Финансовый", "Свой тип", "Очистить типы"]
            UserDefaults.standard.set(newScamModel.types, forKey: "typess")
            newScamModel.type = "Финансовый"
        }
    }
    
    func checkSameTypes() {
        if newScamModel.types.filter({$0 == newScamModel.alertInput}).count == 0 {
            newScamModel.types.insert(newScamModel.alertInput, at: 0)
            newScamModel.type = newScamModel.alertInput
            UserDefaults.standard.set(newScamModel.types, forKey: "typess")
        } else {
            newScamModel.type = newScamModel.alertInput
        }
    }
    
    func saveToCoreData() {
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
    }
    
    func checkNameCount() -> Bool {
        if newScamModel.name.count >= 30 || newScamModel.name.isEmpty {
            newScamModel.showsAlertNameCount.toggle()
            return true
        } else {
            return false
        }
    }
    
    func tryToSave() {
        if checkNameCount() {
        } else {
            saveToCoreData()
            UserDefaults.standard.set(newScamModel.types, forKey: "typess")
            self.shouldDismissView = true
        }
    }
    
    func limitText(_ upper: Int) {
        if newScamModel.description.count > upper {
            newScamModel.description = String(newScamModel.description.prefix(upper))
        }
    }
}
