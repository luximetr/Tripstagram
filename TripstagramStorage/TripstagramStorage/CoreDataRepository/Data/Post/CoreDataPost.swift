import CoreData

class CoreDataPost: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var postedAt: Date
}
