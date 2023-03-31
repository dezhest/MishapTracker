//
//  ArrayOfStringLoc.swift
//  Mishap tracker
//
//  Created by Denis Zhesterev on 31.03.2023.
//

import Foundation

extension String {
    var localized: String {
           return NSLocalizedString(self, comment: "")
       }

       func localized(_ arguments: CVarArg...) -> String {
           return String(format: self.localized, arguments: arguments)
       }
}
