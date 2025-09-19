import Foundation

public struct ImageOnlyPost: Post {
    public let id: UUID
    public let source: PostImageSource
    
    public init(id: UUID, source: PostImageSource) {
        self.id = id
        self.source = source
    }
}
