import SwiftUI

public class PresentationViewModel: ObservableObject {
    
    public init() {
        
    }
    
    // MARK: - Posts
    
    public var getPosts: (() async throws -> [any Post])?
}
