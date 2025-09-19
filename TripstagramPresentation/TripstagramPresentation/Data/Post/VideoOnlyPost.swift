import Foundation

public struct VideoOnlyPost: Post {
    public let id: UUID
    public let source: PostVideoSource
    
    public init(id: UUID, source: PostVideoSource) {
        self.id = id
        self.source = source
    }
}
