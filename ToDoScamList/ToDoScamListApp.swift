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
    @StateObject var main = MainViewModel()
    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(main)

        }
    }
}
