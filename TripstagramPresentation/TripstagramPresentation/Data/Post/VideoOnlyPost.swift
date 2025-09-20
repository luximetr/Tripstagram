import Foundation

public struct VideoOnlyPost: Post {
    public let id: String
    public let source: PostVideoSource
    
    public init(id: String, source: PostVideoSource) {
        self.id = id
        self.source = source
    }
}
