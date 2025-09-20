import Foundation
import CoreData

public struct Storage {
    
    // MARK: - Init
    
    public init() {
        fileManager = FileManager.default
        coreDataRepository = CoreDataRepository(persistentContainer: NSPersistentContainer(name: "Tripstagram"))
    }
    
    public func initialize() throws {
    }
    
    // MARK: - File manager
    
    let fileManager: FileManager
    
    // MARK: - CoreData repository
    
    let coreDataRepository: CoreDataRepository
    
    // MARK: - Posts
    
    func savePosts() throws {
    }
    
    func fetchPosts() throws {
    }
}
