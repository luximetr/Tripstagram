import Foundation

public struct PostVideoSource: PostSource {
    public let url: URL
    
    public init(url: URL) {
        self.url = url
    }
}
