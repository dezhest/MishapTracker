//
//  NewScamModel.swift
//  ToDoScamList
//
//  Created by Denis Zhesterev on 08.02.2023.
//

import Foundation
import SwiftUI

struct NewScamModel {
    var name: String = ""
    var power: Double = 0.0
    var selectedDate = Date()
    var calendarId: Int = 0
    var description: String = ""
    var imageData: Data = .init(capacity: 0)
    var types: [String] = NewScamModel.typesArrayDefaultValues
    var type: String = NewScamModel.typeDefaultValue
    var alertInput = ""
    var showsAddCustomType = false
    var showsAlertNameCount = false
    var showImageDialog = false
    var showsImagePicker = false
    var source: UIImagePickerController.SourceType = .photoLibrary
}
