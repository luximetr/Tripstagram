import Foundation

public class Network {
    
    // MARK: - URL session
    
    private let urlSession: URLSession
    
    // MARK: - Initialization
    
    public init() {
        urlSession = URLSession.shared
    }
    
    // MARK: - Posts
    
    public func getPosts() async throws -> [any Post] {
        return try [
            ImageOnlyPost(id: UUID(), source: createPostImageSource(urlString: "https://i.imgur.com/96vtL.png")),
            ImageOnlyPost(id: UUID(), source: createPostImageSource(urlString: "https://i.imgur.com/UUiBY.png")),
            MultiSourcePost(id: UUID(), sources: [
                createPostImageSource(urlString: "https://i.imgur.com/ZXs3p5F.png"),
                createPostVideoSource(urlString: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4"),
                createPostImageSource(urlString: "https://i.imgur.com/h5T2a8G.jpeg")
            ]),
            VideoOnlyPost(id: UUID(), source: try createPostVideoSource(urlString: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")),
            VideoOnlyPost(id: UUID(), source: try createPostVideoSource(urlString: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4"))
        ]
    }
    
    private func createPostImageSource(urlString: String) throws -> PostImageSource {
        guard let url = URL(string: urlString) else { throw Error.invalidURL }
        return .init(url: url)
    }
    
    private func createPostVideoSource(urlString: String) throws -> PostVideoSource {
        guard let url = URL(string: urlString) else { throw Error.invalidURL }
        return .init(url: url)
    }
    
    // MARK: - Files
    
    public func downloadFile(remoteURL: URL) async throws -> URL {
        let (tempURL, _) = try await urlSession.download(from: remoteURL)
        return tempURL
    }
}

