//
//  PowerColor.swift
//  ToDoScamList
//
//  Created by Denis Zhesterev on 07.02.2023.
//

import Foundation
import SwiftUI

class PowerColor {
    func chooseColor(power: Int) -> Color {
        switch power {
        case 0: return Color(UIColor(red: 252/255, green: 191/255, blue: 41/255, alpha: 1.0))
        case 1: return Color(UIColor(red: 252/255, green: 178/255, blue: 43/255, alpha: 1.0))
        case 2: return Color(UIColor(red: 252/255, green: 164/255, blue: 45/255, alpha: 1.0))
        case 3: return Color(UIColor(red: 252/255, green: 153/255, blue: 47/255, alpha: 1.0))
        case 4: return Color(UIColor(red: 252/255, green: 141/255, blue: 48/255, alpha: 1.0))
        case 5: return Color(UIColor(red: 252/255, green: 127/255, blue: 49/255, alpha: 1.0))
        case 6: return Color(UIColor(red: 252/255, green: 114/255, blue: 50/255, alpha: 1.0))
        case 7: return Color(UIColor(red: 252/255, green: 102/255, blue: 51/255, alpha: 1.0))
        case 8: return Color(UIColor(red: 252/255, green: 88/255, blue: 51/255, alpha: 1.0))
        case 9: return Color(UIColor(red: 252/255, green: 72/255, blue: 51/255, alpha: 1.0))
        case 10: return Color(UIColor(red: 252/255, green: 55/255, blue: 51/255, alpha: 1.0))
        default: return Color(.black)
        }
    }
}
