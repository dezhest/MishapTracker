//
//  TextModifiers.swift
//  ToDoScamList
//
//  Created by Denis Zhesterev on 07.02.2023.
//

import Foundation
import SwiftUI

extension Text {
    func medium14() -> some View {
        self
            .font(.system(size: 14, weight: .medium, design: .default))
            .foregroundColor(.white)
            .padding(7)
            .background(Color(.orange))
            .cornerRadius(20)
            .padding(.bottom, 3)
    }
}
