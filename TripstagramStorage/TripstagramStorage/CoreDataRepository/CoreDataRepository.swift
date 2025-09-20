import CoreData

class CoreDataRepository {
    
    private let persistentContainer: NSPersistentContainer

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    func savePosts(_ posts: [any Post]) async throws {
    }
    
    func fetchPosts() async throws -> [any Post] {
        return []
    }
}
