import Foundation

@MainActor
class FeedScreenViewModel: ObservableObject {
    
    // MARK: - View life cycle
    
    func onAppear() {
        loadPosts()
    }
    
    // MARK: - Posts
    
    @Published var posts: [any PostCellViewModel] = []
    
    var onLoadPosts: (() async throws -> [any Post])?
    
    func loadPosts() {
        guard let onLoadPosts else { return }
        Task {
            do {
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
                return nil
            }
        })
        self.posts = viewModels
    }
    
    private func createPostViewModel(post: any Post) throws -> any PostCellViewModel {
        switch post {
        case let imageOnlyPost as ImageOnlyPost:
            return createImagePostCellViewModel(post: imageOnlyPost)
        default:
            throw Error("Unsupported post type")
        }
    }
    
    var onLoadImageOnlyPostAttachment: ((ImageOnlyPost) async throws -> URL)?
    
    private func createImagePostCellViewModel(post: ImageOnlyPost) -> ImagePostCellViewModel {
        let viewModel = ImagePostCellViewModel(post: post)
        viewModel.onCacheRemoteImageURL = { [weak self] postId in
            guard let self else { throw Error.unwrapWeakSelf }
            guard let onLoadImageOnlyPostAttachment else { throw Error("onLoadImageOnlyPostAttachment is not set")}
            return try await onLoadImageOnlyPostAttachment(post)
        }
        viewModel.onLoadCachedImageURL = { [weak self] postId in
            guard let self else { throw Error.unwrapWeakSelf }
            return nil
//            guard let onLoadImageOnlyPostAttachment else { throw Error("onLoadImageOnlyPostAttachment is not set")}
//            return try await onLoadImageOnlyPostAttachment(post)
        }
        return viewModel
    }
}
