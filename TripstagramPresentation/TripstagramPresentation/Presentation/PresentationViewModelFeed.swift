import Foundation

extension PresentationViewModel {
    
    // MARK: - Feed
    
    func createFeedScreenView() -> FeedScreenView {
        let viewModel = FeedScreenViewModel()
        viewModel.onLoadPosts = { [weak self] in
            guard let self else { throw Error.unwrapWeakSelf }
            return try await self.getPosts()
        }
        let view = FeedScreenView(viewModel: viewModel)
        return view
    }
}
