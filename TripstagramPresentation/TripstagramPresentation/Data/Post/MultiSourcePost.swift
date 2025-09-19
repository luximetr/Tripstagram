import Foundation

public struct MultiSourcePost: Post {
    public let id: UUID
    public let sources: [PostSource]
    
    public init(id: UUID, sources: [PostSource]) {
        self.id = id
        self.sources = sources
    }
}
