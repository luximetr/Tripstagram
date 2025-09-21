import SwiftUI

@MainActor
public class PresentationViewModel: ObservableObject {
    
    public init() {
        
    }
    
    // MARK: - Posts
    
    public var loadPosts: (() async throws -> [any Post])!
    public var loadCachedPosts: (() async throws -> [any Post])!
    public var loadRemoteImageOnlyPostAttachment: ((ImageOnlyPost) async throws -> URL)!
    public var getCachedImageOnlyPostAttachment: ((ImageOnlyPost) throws -> URL?)!
}
