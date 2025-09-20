import Foundation

public struct ImageOnlyPost: Post {
    public let id: String
    public let postedAt: Date
    public let source: PostImageSource
}
