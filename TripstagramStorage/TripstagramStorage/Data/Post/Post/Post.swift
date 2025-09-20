import Foundation

public protocol Post {
    var id: String { get }
    var postedAt: Date { get }
}
