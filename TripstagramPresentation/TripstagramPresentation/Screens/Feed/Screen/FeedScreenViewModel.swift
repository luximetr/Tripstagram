import Foundation

@MainActor
class FeedScreenViewModel: ObservableObject {
    
    // MARK: - View life cycle
    
    func onAppear() {
        loadPosts()
    }
    
    // MARK: - Posts
    
    @Published var posts: [any PostCellViewModel] = []
    
    var onLoadCachedPosts: (() async throws -> [any Post])?
    var onLoadPosts: (() async throws -> [any Post])?
    
    func loadPosts() {
        guard let onLoadCachedPosts else { return }
        guard let onLoadPosts else { return }
        Task(priority: .userInitiated) {
            do {
                let cachedPosts = try await onLoadCachedPosts()
                updatePosts(cachedPosts)
                let posts = try await onLoadPosts()
                updatePosts(posts)
            } catch {
                print(error)
            }
        }
    }
    
    private func updatePosts(_ posts: [any Post]) {
        let viewModels = posts.compactMap({ post in
            do {
                return try createPostViewModel(post: post)
            } catch {
                print(error)
                return nil
            }
        })
        self.posts = viewModels
    }
    
    private func createPostViewModel(post: any Post) throws -> any PostCellViewModel {
        switch post {
        case let imageOnlyPost as ImageOnlyPost:
            return createImagePostCellViewModel(post: imageOnlyPost)
        case let videoOnlyPost as VideoOnlyPost:
            return createVideoPostCellViewModel(post: videoOnlyPost)
        case let multiSourcePost as MultiSourcePost:
            return createMultiSourcePostCellViewModel(post: multiSourcePost)
        default:
            throw Error("Unsupported post type")
        }
    }
    
    var onLoadRemoteImageOnlyPostAttachment: ((ImageOnlyPost) async throws -> URL)?
    var onGetCachedImageOnlyPostAttachment: ((ImageOnlyPost) throws -> URL?)?
    
    private func createImagePostCellViewModel(post: ImageOnlyPost) -> ImagePostCellViewModel {
        let viewModel = ImagePostCellViewModel(post: post)
        viewModel.onLoadRemoteImageURL = { [weak self] in
            guard let self else { throw Error.unwrapWeakSelf }
            guard let onLoadRemoteImageOnlyPostAttachment else { throw Error("onLoadRemoteImageOnlyPostAttachment is not set")}
            return try await onLoadRemoteImageOnlyPostAttachment(post)
        }
        viewModel.onGetCachedImageURL = { [weak self] in
            guard let self else { throw Error.unwrapWeakSelf }
            guard let onGetCachedImageOnlyPostAttachment else { throw Error("onGetCachedImageOnlyPostAttachment is not set") }
            return try onGetCachedImageOnlyPostAttachment(post)
        }
        return viewModel
    }
    
    private func createVideoPostCellViewModel(post: VideoOnlyPost) -> VideoPostCellViewModel {
        let viewModel = VideoPostCellViewModel(post: post)
        return viewModel
    }
    
    private func createMultiSourcePostCellViewModel(post: MultiSourcePost) -> MultiSourceCarouselPostCellViewModel {
        let viewModel = MultiSourceCarouselPostCellViewModel(post: post)
        return viewModel
    }
}
