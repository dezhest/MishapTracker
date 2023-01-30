//
//  AddNewScamForm.swift
//  ToDoScamList
//
//  Created by Denis Zhesterev on 30.01.2023.
//

import Foundation
class AddNewScamForm: ObservableObject {
    @Published var name = ""
    @Published var power: Double = 0
    @Published var selectedDate = Date()
    @Published var calendarId: Int = 0
    @Published var description = ""
    @Published var imageData: Data = .init(capacity: 0)
    @Published var types: [String] = [""]
    @Published var type = "Финансовый"
}
