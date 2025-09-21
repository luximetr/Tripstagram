import SwiftUI

struct ImagePostCell: View {
    
    // MARK: - Init
    
    init(viewModel: ImagePostCellViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: - ViewModel
    
    @StateObject var viewModel: ImagePostCellViewModel
    
    // MARK: - Appearance
    
    @Environment(\.appearance) private var appearance
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            if let imageURL = viewModel.imageURL {
                LocalImageView(fileURL: imageURL)
            } else {
                ZStack {
                    Rectangle()
                        .fill(appearance.colors.secondaryBackground)
                    ProgressView()
                        .tint(appearance.colors.secondaryText)
                }
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit)
            }
            PostActionsView()
            .padding(.vertical, 5)
            HStack {
                Text("Comment...")
                    .foregroundStyle(appearance.colors.primaryText)
                Text("more")
                    .foregroundStyle(appearance.colors.secondaryText)
                Spacer()
            }
            HStack {
                Text("12 hours ago")
                    .foregroundStyle(appearance.colors.primaryText)
                Spacer()
            }
        }
        .listRowBackground(appearance.colors.primaryBackground)
        .onAppear {
            viewModel.onAppear()
        }
    }
}

#Preview {
    @Previewable @Environment(\.colorScheme) var colorScheme
    
    let imageURL = URL(string: "https://i.imgur.com/UUiBY.png")!
    let post = ImageOnlyPost(id: "1", attachmentRemoteURL: imageURL)
    let viewModel = ImagePostCellViewModel(post: post)
    viewModel.onLoadRemoteImageURL = {
        return imageURL
    }
    
    return ImagePostCell(
        viewModel: viewModel
    )
    .environment(\.appearance, CompositeAppearance(colorScheme: colorScheme))
}
