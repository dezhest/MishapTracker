//
//  NewScamModelDefaultValues.swift
//  ToDoScamList
//
//  Created by Denis Zhesterev on 10.02.2023.
//

import Foundation

extension NewScamModel {
    static let typeDefaultValue = "Financial"
    static let typesArrayDefaultValues =  [
        NSLocalizedString("Emotional", comment: ""),
        NSLocalizedString("Financial", comment: ""),
        NSLocalizedString("Custom", comment: ""),
        NSLocalizedString("Clear", comment: "")
    ]
}
