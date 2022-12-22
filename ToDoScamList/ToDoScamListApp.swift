//
//  ToDoScamListApp.swift
//  ToDoScamList
//
//  Created by Денис Жестерев on 16.12.2022.
//

import SwiftUI

@main
struct ToDoScamListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
