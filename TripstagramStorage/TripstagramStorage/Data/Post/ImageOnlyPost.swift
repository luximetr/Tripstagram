import Foundation

public struct ImageOnlyPost: Post {
    public let id: String
    public let postedAt: Date
    public let source: PostImageSource
    
    public init(id: String, postedAt: Date, source: PostImageSource) {
        self.id = id
        self.postedAt = postedAt
        self.source = source
    }
}
