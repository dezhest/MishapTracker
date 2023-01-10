//
//  Scam+CoreDataProperties.swift
//  ToDoScamList
//
//  Created by Денис Жестерев on 22.12.2022.
//
//

import Foundation
import CoreData

extension Scam {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Scam> {
        return NSFetchRequest<Scam>(entityName: "Scam")
    }

    @NSManaged public var power: Double
    @NSManaged public var imageD: Data?
    @NSManaged public var name: String
    @NSManaged public var selectedDate: Date
    @NSManaged public var type: String
    @NSManaged public var typeArray: String

}

extension Scam: Identifiable {
}
