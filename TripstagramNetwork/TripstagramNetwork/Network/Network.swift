import Foundation

public class Network {
    
    // MARK: - Init
    
    public init() {
        urlSession = URLSession.shared
    }
    
    // MARK: - URL session
    
    private let urlSession: URLSession
    
    // MARK: - Posts
    
    public func getPosts() async throws -> [any Post] {
        return try [
            ImageOnlyPost(id: "imageOnlyPost1", postedAt: Date().addingTimeInterval(-86_400), source: createPostImageSource(urlString: "https://i.imgur.com/96vtL.png")),
            ImageOnlyPost(id: "imageOnlyPost2", postedAt: Date().addingTimeInterval(-43_200), source: createPostImageSource(urlString: "https://i.imgur.com/UUiBY.png")),
            MultiSourcePost(id: "multiSourcePost1", postedAt: Date().addingTimeInterval(-21_600), sources: [
                createPostImageSource(urlString: "https://i.imgur.com/ZXs3p5F.png"),
                createPostVideoSource(urlString: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4"),
                createPostImageSource(urlString: "https://i.imgur.com/h5T2a8G.jpeg")
            ]),
            VideoOnlyPost(id: "videoOnlyPost1", postedAt: Date().addingTimeInterval(-10_800), source: try createPostVideoSource(urlString: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")),
            VideoOnlyPost(id: "videoOnlyPost2", postedAt: Date().addingTimeInterval(-3_600), source: try createPostVideoSource(urlString: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4"))
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
    
    public func downloadFile(remoteURL: URL) async throws -> DownloadedFile {
        let (tempURL, response) = try await urlSession.download(from: remoteURL)
        let file = DownloadedFile(
            tempURL: tempURL,
            mimeType: response.mimeType,
            suggestedFilename: response.suggestedFilename
        )
        return file
    }
}

