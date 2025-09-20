import Foundation

public struct ImageOnlyPost: Post {
    public let id: String
    public let postedAt: Date
    public let attachmentURL: URL
    
    public init(id: String, postedAt: Date, attachmentURL: URL) {
        self.id = id
        self.postedAt = postedAt
        self.attachmentURL = attachmentURL
    }
}
