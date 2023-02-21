//
//  ToDoScamListApp.swift
//  ToDoScamList
//
//  Created by Денис Жестерев on 16.12.2022.
//

import SwiftUI
import CoreData

@main
struct ToDoScamListApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                .environment(\.managedObjectContext, CoreDataManager.instance.managedObjectContext)
                .environment(\.colorScheme, .light)
        }
    }
}
