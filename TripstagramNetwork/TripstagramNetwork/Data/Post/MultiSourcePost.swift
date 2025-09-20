import Foundation

public struct MultiSourcePost: Post {
    public let id: String
    public let postedAt: Date
    public let sources: [PostSource]
}
