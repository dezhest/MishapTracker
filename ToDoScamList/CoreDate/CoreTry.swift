//
//  CoreTry.swift
//  ToDoScamList
//
//  Created by Denis Zhesterev on 12.02.2023.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func fetchData(completion: @escaping ([String]) -> Void) {
        let context = persistentContainer.newBackgroundContext()
        context.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
            do {
                let persons = try context.fetch(fetchRequest)
                let names = persons.map { $0.value(forKey: "name") as! String }
                completion(names)
            } catch {
                print("Error fetching data: \(error)")
                completion([])
            }
        }
    }
}

class CoreDataViewModel: ObservableObject {
    @Published var scams = [Scam]()
    let viewContext = PersistenceController.shared.container.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Scam")
    func unsortedScams(){
        do {
            let results = try viewContext.fetch(fetchRequest)
            let entities = results as! [Scam]
            scams = entities
        }
        catch {
            print("error")
        }
    }
//    init() {
//        CoreDataManager.shared.fetchData { [weak self] title in
//            self?.scams = title
//        }
//    }
}





