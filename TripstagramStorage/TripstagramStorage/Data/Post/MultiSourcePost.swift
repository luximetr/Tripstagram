import Foundation

public struct MultiSourcePost: Post {
    public let id: UUID
    public let postedAt: Date
    public let sources: [PostSource]
    
    public init(id: UUID, postedAt: Date, sources: [PostSource]) {
        self.id = id
        self.postedAt = postedAt
        self.sources = sources
    }
}
