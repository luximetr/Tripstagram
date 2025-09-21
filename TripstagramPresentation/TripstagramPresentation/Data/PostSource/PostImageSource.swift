import Foundation

public struct PostImageSource: PostSource, Sendable {
    public let url: URL
    
    public init(url: URL) {
        self.url = url
    }
}
