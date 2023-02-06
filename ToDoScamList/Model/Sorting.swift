//
//  Sorting.swift
//  ToDoScamList
//
//  Created by Denis Zhesterev on 07.02.2023.
//

import Foundation
import SwiftUI

struct Sorting {
    @Binding var pickerSelection: Int
    @FetchRequest(entity: Scam.entity(), sortDescriptors: []) var entity: FetchedResults<Scam>
    var sortedScams: [Scam] {
        mutating get {
            switch pickerSelection {
            case(1): return entity.sorted(by: {$0.selectedDate > $1.selectedDate})
            case(2): return entity.sorted(by: {$0.title < $1.title})
            case(3): return entity.sorted(by: {$0.power > $1.power})
            case(4): return entity.sorted(by: {$0.type > $1.type})
            default: return []
            }
        }
    }
}
