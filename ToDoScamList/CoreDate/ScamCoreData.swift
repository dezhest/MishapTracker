//
//  Scam.swift
//  ToDoScamList
//
//  Created by Denis Zhesterev on 13.02.2023.
//

import Foundation
import CoreData

@objc(ScamCoreData)
public class ScamCoreData: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "ScamCoreData"), insertInto: CoreDataManager.instance.managedObjectContext)
    }
}

extension ScamCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScamCoreData> {
        return NSFetchRequest<ScamCoreData>(entityName: "ScamCoreData")
    }

    @NSManaged public var power: Double
    @NSManaged public var imageD: Data?
    @NSManaged public var title: String
    @NSManaged public var selectedDate: Date
    @NSManaged public var type: String
    @NSManaged public var typeArray: String
    @NSManaged public var scamDescription: String

}

extension ScamCoreData: Identifiable {
}


