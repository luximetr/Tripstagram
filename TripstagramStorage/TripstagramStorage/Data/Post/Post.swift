import Foundation

public protocol Post: Identifiable {
    var id: UUID { get }
    var postedAt: Date { get }
}
