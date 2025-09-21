import Foundation

public struct InsertingVideoOnlyPost: InsertingPost {
    public let id: String
    public let postedAt: Date
    public let attachment: DownloadedFile
    
    public init(id: String, postedAt: Date, attachment: DownloadedFile) {
        self.id = id
        self.postedAt = postedAt
        self.attachment = attachment
    }
}
