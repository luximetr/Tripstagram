import Foundation

@MainActor
class MultiSourceCarouselPostCellViewModel: ObservableObject, @MainActor PostCellViewModel {
    
    // MARK: - Init
    
    init(post: MultiSourcePost) {
        self.post = post
    }
    
    // MARK: - Post
    
    var id: String { post.id }
    let post: MultiSourcePost
}
