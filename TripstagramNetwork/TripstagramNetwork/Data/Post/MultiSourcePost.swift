import Foundation

public struct MultiSourcePost: Post {
    public let id: UUID
    public let sources: [PostSource]
}
