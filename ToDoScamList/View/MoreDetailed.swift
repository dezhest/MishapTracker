//
//  MoreDetailed.swift
//  ToDoScamList
//
//  Created by Денис Жестерев on 17.01.2023.
//

import SwiftUI

struct MoreDetailed: View {
    @Binding var title: String
    var body: some View {
        Text(title)
    }
}

struct MoreDetailed_Previews: PreviewProvider {
    static var previews: some View {
        MoreDetailed(title: .constant(""))
    }
}
