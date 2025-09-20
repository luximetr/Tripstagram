import CoreData

class CoreDataMultiSourcePost: CoreDataPost {
    @NSManaged var sources: [CoreDataPostSource]
}

