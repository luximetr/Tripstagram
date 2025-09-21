import Foundation

public struct InsertingVideoOnlyPost: InsertingPost {
    public let id: String
    public let postedAt: Date
    
    public init(id: String, postedAt: Date) {
        self.id = id
        self.postedAt = postedAt
    }
}
