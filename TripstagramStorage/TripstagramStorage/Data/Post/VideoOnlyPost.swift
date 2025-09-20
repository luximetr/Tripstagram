import Foundation

public struct VideoOnlyPost: Post {
    public let id: UUID
    public let postedAt: Date
    public let source: PostVideoSource
    
    public init(id: UUID, postedAt: Date, source: PostVideoSource) {
        self.id = id
        self.postedAt = postedAt
        self.source = source
    }
}
