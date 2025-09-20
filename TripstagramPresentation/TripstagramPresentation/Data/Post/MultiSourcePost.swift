import Foundation

public struct MultiSourcePost: Post {
    public let id: String
    public let sources: [PostSource]
    
    public init(id: String, sources: [PostSource]) {
        self.id = id
        self.sources = sources
    }
}
