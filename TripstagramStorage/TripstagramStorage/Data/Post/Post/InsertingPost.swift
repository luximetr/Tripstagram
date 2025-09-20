import Foundation

public protocol InsertingPost {
    var id: String { get }
    var postedAt: Date { get }
}
