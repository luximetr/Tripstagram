import Foundation

public struct ImageOnlyPost: Post {
    public let id: UUID
    public let postedAt: Date
    public let source: PostImageSource
    
    public init(id: UUID, postedAt: Date, source: PostImageSource) {
        self.id = id
        self.postedAt = postedAt
        self.source = source
    }
}
