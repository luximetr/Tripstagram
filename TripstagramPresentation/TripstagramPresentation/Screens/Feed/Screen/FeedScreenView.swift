import SwiftUI

struct FeedScreenView: View {
    
    // MARK: - Init
    
    init(viewModel: FeedScreenViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: - ViewModel
    
    @StateObject var viewModel: FeedScreenViewModel
    
    // MARK: - Appearance
    
    @Environment(\.appearance) private var appearance
    
    // MARK: - Body
    
    var body: some View {
        List(viewModel.posts, id: \.id) { postViewModel in
            switch postViewModel {
            case let imagePostViewModel as ImagePostCellViewModel:
                ImagePostCell(viewModel: imagePostViewModel)
            case let videoPostViewModel as VideoPostCellViewModel:
                VideoPostCell(viewModel: videoPostViewModel)
            case let multiSourcePostViewModel as MultiSourceCarouselPostCellViewModel:
                MultiSourceCarouselPostCell(viewModel: multiSourcePostViewModel)
            default:
                Text("Unsupported post type")
            }
        }
        .listStyle(.plain)
        .background(appearance.colors.primaryBackground)
        .scrollContentBackground(.hidden)
        .onAppear {
            viewModel.onAppear()
        }
    }
}

#Preview {
    @Previewable @Environment(\.colorScheme) var colorScheme
    let viewModel = FeedScreenViewModel()
    
    return FeedScreenView(viewModel: viewModel)
        .environment(\.appearance, CompositeAppearance(colorScheme: colorScheme))
}
