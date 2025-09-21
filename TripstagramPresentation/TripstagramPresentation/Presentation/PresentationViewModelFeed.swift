import Foundation

extension PresentationViewModel {
    
    // MARK: - Feed
    
    func createFeedScreenView() -> FeedScreenView {
        let viewModel = FeedScreenViewModel()
        viewModel.onLoadPosts = { [weak self] in
            guard let self else { throw Error.unwrapWeakSelf }
            return try await self.getPosts()
        }
        viewModel.onLoadImageOnlyPostAttachment = { [weak self] post in
            guard let self else { throw Error.unwrapWeakSelf }
            return try await self.downloadImageOnlyPostAttachment(post)
        }
        let view = FeedScreenView(viewModel: viewModel)
        return view
    }
}
