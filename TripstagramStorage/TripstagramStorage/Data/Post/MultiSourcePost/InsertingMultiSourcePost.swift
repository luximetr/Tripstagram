import Foundation

public struct InsertingMultiSourcePost: InsertingPost {
    public let id: String
    public let postedAt: Date
    public let attachments: [DownloadedFile]
    
    public init(id: String, postedAt: Date, attachments: [DownloadedFile]) {
        self.id = id
        self.postedAt = postedAt
        self.attachments = attachments
    }
}
