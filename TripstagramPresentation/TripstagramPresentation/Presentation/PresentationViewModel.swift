import SwiftUI

@MainActor
public class PresentationViewModel: ObservableObject {
    
    public init() {
        self.appearance = CompositeAppearance(colorScheme: .light)
        self.colorScheme = .light
    }
    
    // MARK: - Appearance
    
    @Published var appearance: Appearance
    private(set) var colorScheme: ColorScheme
    
    func setColorScheme(_ colorScheme: ColorScheme) {
        self.colorScheme = colorScheme
        appearance = CompositeAppearance(colorScheme: colorScheme)
    }
    
    // MARK: - Posts
    
    public var loadPosts: (() async throws -> [any Post])!
    public var loadCachedPosts: (() async throws -> [any Post])!
    public var loadRemoteImageOnlyPostAttachment: ((ImageOnlyPost) async throws -> URL)!
    public var getCachedImageOnlyPostAttachment: ((ImageOnlyPost) throws -> URL?)!
}
