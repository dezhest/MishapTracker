//
//  MainModel.swift
//  ToDoScamList
//
//  Created by Denis Zhesterev on 08.02.2023.
//

import Foundation
import SwiftUI

struct MainModel {
    var mdIsShown = false
    var indexOfMoreDetailed = 0
    var editIsCanceled = false
    var editInput = ""
    var editpower: Double = 0
    var indexOfEditScam = 0
    var pickerSelection = SortType.date
    var indexOfImage = 0
    var showImage = Image("Scam")
    var imageIsShown = false
    var newScamIsShown = false
    var mDeditIsCanceled = false
    var mDeditInput = ""
    var statIsShown = false
    var title: String = ""
    var description: String = ""
    var image: Data = Data()
}
