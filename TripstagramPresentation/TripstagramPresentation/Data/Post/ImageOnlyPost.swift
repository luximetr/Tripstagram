import Foundation

public struct ImageOnlyPost: Post, Sendable {
    public let id: String
    public let attachmentRemoteURL: URL
    
    public init(id: String, attachmentRemoteURL: URL) {
        self.id = id
        self.attachmentRemoteURL = attachmentRemoteURL
    }
}
