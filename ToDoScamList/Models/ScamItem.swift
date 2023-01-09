//
//  ScamItem.swift
//  ToDoScamList
//
//  Created by Денис Жестерев on 05.01.2023.
//

import Foundation

struct ScamItem: Identifiable, Hashable {
    let id = UUID().uuidString
    let name: String
    let type: String
    let power: Double
    let selectedDate: Date
    let image: Date

}

class Scams: ObservableObject {
    @Published var items: [ScamItem] = [ScamItem]()
}
