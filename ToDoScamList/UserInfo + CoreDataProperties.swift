import Foundation
import CoreData

extension Scam {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Scam> {
        return NSFetchRequest<Scam>(entityName: "Scam")
    }
    
    @NSManaged public var name: String
    @NSManaged public var type: String
    @NSManaged public var amount: Double
    @NSManaged public var selectedDate: Date
    @NSManaged public var typeArray: String
    @NSManaged public var blob: NSData
}
