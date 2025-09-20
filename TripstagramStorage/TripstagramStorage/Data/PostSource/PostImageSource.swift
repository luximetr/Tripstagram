import Foundation

public struct PostImageSource: PostSource {
    public let url: URL
    
    public init(url: URL) {
        self.url = url
    }
}
