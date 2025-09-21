import Foundation

public struct InsertingMultiSourcePost: InsertingPost {
    public let id: String
    public let postedAt: Date
    public let sources: [PostSource]
    
    public init(id: String, postedAt: Date, sources: [PostSource]) {
        self.id = id
        self.postedAt = postedAt
        self.sources = sources
    }
}
