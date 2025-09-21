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
        guard let onLoadCachedImageURL = onLoadCachedImageURL else { return }
        guard let onCacheRemoteImageURL = onCacheRemoteImageURL else { return }
        if let cachedImageURL = try? onLoadCachedImageURL(post.id) {
            self.imageURL = cachedImageURL
        } else {
            Task {
                let cachedImageURL = try await onCacheRemoteImageURL(post.id)
                self.imageURL = cachedImageURL
            }
        }
    }
    
    // MARK: - Cached image
    
    var onLoadCachedImageURL: ((String) throws -> URL?)?
    
    // MARK: - Remote image
    
    var onCacheRemoteImageURL: ((String) async throws -> URL?)?
}
