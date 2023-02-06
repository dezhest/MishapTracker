//
//  ImageModifier.swift
//  ToDoScamList
//
//  Created by Denis Zhesterev on 07.02.2023.
//

import Foundation
import SwiftUI

extension Image {
    func backButton() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 20, alignment: .leading)
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .font(Font.body.bold())
            .frame(height: 30)
            .background(Circle().fill(Color.orange))

    }
}

