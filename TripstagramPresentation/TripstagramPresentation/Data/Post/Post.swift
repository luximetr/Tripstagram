import Foundation

public protocol Post: Identifiable {
    var id: UUID { get }
}
