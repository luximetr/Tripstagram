import Foundation

@MainActor
class ImagePostCellViewModel: ObservableObject, @MainActor PostCellViewModel {
    
    // MARK: - Init
    
    init(post: ImageOnlyPost) {
        self.post = post
    }
    
    // MARK: - View Life Cycle
    
    func onAppear() {
        loadImage()
    }
    
    // MARK: - Post
    
    var id: String { post.id }
    let post: ImageOnlyPost
    
    // MARK: - Image
    
    @Published var imageURL: URL?
    
    private func loadImage() {
        guard let onGetCachedImageURL = onGetCachedImageURL else { return }
        guard let onLoadRemoteImageURL = onLoadRemoteImageURL else { return }
        if let cachedImageURL = try? onGetCachedImageURL() {
            self.imageURL = cachedImageURL
        } else {
            Task {
                let imageURL = try await onLoadRemoteImageURL()
                self.imageURL = imageURL
            }
        }
    }
    
    // MARK: - Cached image
    
    var onGetCachedImageURL: (() throws -> URL?)?
    
    // MARK: - Remote image
    
    var onLoadRemoteImageURL: (() async throws -> URL?)?
}
