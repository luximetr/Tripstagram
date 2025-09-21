import Foundation

public struct VideoOnlyPost: Post {
    public let id: String
    public let postedAt: Date
    public let attachmentRemoteURL: URL
}
