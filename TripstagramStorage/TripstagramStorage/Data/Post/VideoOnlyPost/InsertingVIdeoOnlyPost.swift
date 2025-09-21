import Foundation

public struct InsertingVideoOnlyPost: InsertingPost {
    public let id: String
    public let postedAt: Date
    public let attachmentRemoteURL: URL
    
    public init(id: String, postedAt: Date, attachmentRemoteURL: URL) {
        self.id = id
        self.postedAt = postedAt
        self.attachmentRemoteURL = attachmentRemoteURL
    }
}
