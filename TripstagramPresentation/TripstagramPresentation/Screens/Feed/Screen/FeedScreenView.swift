import SwiftUI

struct FeedScreenView: View {
    
    // MARK: - Init
    
    init(viewModel: FeedScreenViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: - ViewModel
    
    @StateObject var viewModel: FeedScreenViewModel
    
    // MARK: - Body
    
    var body: some View {
        List(viewModel.posts, id: \.id) { postViewModel in
            if let imagePostViewModel = postViewModel as? ImagePostCellViewModel {
                ImagePostCell(post: imagePostViewModel.post, viewModel: imagePostViewModel)
            } else {
                Text("Unsupported post type")
            }
        }
//        List(viewModel.posts, id: \.id) { post in
//            if let imagePost = post as? ImageOnlyPost {
//                ImagePostCell(post: imagePost, viewModel: ImagePostCellViewModel(post: imagePost))
//            } else if let video = post as? VideoOnlyPost {
//                VideoPostCell(post: video)
//            } else if let multiSource = post as? MultiSourcePost {
//                MultiSourceCarouselPostCell(post: multiSource)
//            } else {
//                Text("Unsupported post type")
//            }
//        }
        .listStyle(.inset)
        .onAppear {
            viewModel.onAppear()
        }
    }
}

#Preview {
    let viewModel = FeedScreenViewModel()
    FeedScreenView(viewModel: viewModel)
}
