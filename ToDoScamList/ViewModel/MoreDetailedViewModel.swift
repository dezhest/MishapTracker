//
//  MoreDetailedViewModel.swift
//  ToDoScamList
//
//  Created by Denis Zhesterev on 14.02.2023.
//

import Foundation
import CoreData
import SwiftUI

class MoreDetailedViewModel: ObservableObject {
    @Published var model = MoreDetailedModel()
    @Published var mainViewModel = MainViewModel()
    let fetchRequest = NSFetchRequest<ScamCoreData>(entityName: "ScamCoreData")
    
    func toggleEditIsShown() {
        model.editIsShown.toggle()
    }
    
   
}
