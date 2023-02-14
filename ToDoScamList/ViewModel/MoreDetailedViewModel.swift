//
//  MoreDetailedViewModel.swift
//  ToDoScamList
//
//  Created by Denis Zhesterev on 14.02.2023.
//

import Foundation
import CoreData
import SwiftUI

final class MoreDetailedViewModel: ObservableObject {
    @Published var model = MoreDetailedModel()
    @Published var mainViewModel = MainViewModel()
    let fetchRequest = NSFetchRequest<ScamCoreData>(entityName: "ScamCoreData")
    let textLimit = 280
    
    func toggleEditIsShown() {
        model.editIsShown.toggle()
    }
    
   
}
