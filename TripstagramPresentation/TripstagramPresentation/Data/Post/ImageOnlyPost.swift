import Foundation

public struct ImageOnlyPost: Post, Sendable {
    public let id: String
    public let source: PostImageSource
    
    public init(id: String, source: PostImageSource) {
        self.id = id
        self.source = source
    }
}
