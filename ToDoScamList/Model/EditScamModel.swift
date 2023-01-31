//
//  EditScamModel.swift
//  ToDoScamList
//
//  Created by Denis Zhesterev on 30.01.2023.
//

import Foundation
final class EditScamModel: ObservableObject {
    @Published var editIsCanceled = false
    @Published var editInput = ""
    @Published var editpower: Double = 0
    @Published var indexOfEditScam = 0
}
