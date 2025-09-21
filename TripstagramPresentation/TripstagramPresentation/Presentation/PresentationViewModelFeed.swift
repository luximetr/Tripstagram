import Foundation

extension PresentationViewModel {
    
    // MARK: - Feed
    
    func createFeedScreenView() -> FeedScreenView {
        let viewModel = FeedScreenViewModel()
        viewModel.onLoadPosts = { [weak self] in
            guard let self else { throw Error.unwrapWeakSelf }
            return try await self.loadPosts()
        }
        viewModel.onLoadCachedPosts = { [weak self] in
            guard let self else { throw Error.unwrapWeakSelf }
            return try await self.loadCachedPosts()
        }
        viewModel.onLoadRemoteImageOnlyPostAttachment = { [weak self] post in
            guard let self else { throw Error.unwrapWeakSelf }
            return try await self.loadRemoteImageOnlyPostAttachment(post)
        }
        viewModel.onGetCachedImageOnlyPostAttachment = { [weak self] post in
            guard let self else { throw Error.unwrapWeakSelf }
            return try self.getCachedImageOnlyPostAttachment(post)
        }
        let view = FeedScreenView(viewModel: viewModel)
        return view
    }
}
