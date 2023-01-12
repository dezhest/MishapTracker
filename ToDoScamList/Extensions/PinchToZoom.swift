//
//  PinchToZoom.swift
//  ToDoScamList
//
//  Created by Денис Жестерев on 13.01.2023.
//

import Foundation
import SwiftUI

extension View {
    func pinchToZoom() -> some View {
        self.modifier(PinchToZoom())
    }
}
