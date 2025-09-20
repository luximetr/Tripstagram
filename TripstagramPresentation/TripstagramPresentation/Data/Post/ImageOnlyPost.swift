import Foundation

public struct ImageOnlyPost: Post {
    public let id: String
    public let source: PostImageSource
    
    public init(id: String, source: PostImageSource) {
        self.id = id
        self.source = source
    }
}
