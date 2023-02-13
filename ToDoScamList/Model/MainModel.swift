//
//  MainModel.swift
//  ToDoScamList
//
//  Created by Denis Zhesterev on 08.02.2023.
//

import Foundation
import SwiftUI

struct MainModel {
    var editIsShown = false
    var mdIsShown = false
    var indexOfMoreDetailed = 0
    var editIsCanceled = false
    var editInput = ""
    var editpower: Double = 0
    var indexOfEditScam = 0
    var pickerSelection = 1
    var indexOfImage = 0
    var showImage = Image("Scam")
    var imageIsShown = false
}
