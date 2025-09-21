import SwiftUI
import AVFoundation

struct MultiSourceCarouselPostCell: View {
    
    // MARK: - Init
    
    init(viewModel: MultiSourceCarouselPostCellViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: - ViewModel
    
    @StateObject var viewModel: MultiSourceCarouselPostCellViewModel
    
    // MARK: - Appearance
    
    @Environment(\.appearance) private var appearance
    
    // MARK: - Body

    var body: some View {
        VStack(spacing: 8) {
            TabView(selection: $viewModel.selection) {
                ForEach(Array(viewModel.post.sources.enumerated()), id: \.offset) { index, source in
                    Group {
                        if let imageSource = source as? PostImageSource {
                            AsyncImage(url: imageSource.url) { phase in
                                switch phase {
                                case .empty:
                                    ZStack {
                                        Rectangle().fill(.secondary.opacity(0.15))
                                        ProgressView()
                                    }
                                    .frame(maxWidth: .infinity)
                                    .aspectRatio(1.25, contentMode: .fit)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity)
                                case .failure:
                                    ZStack {
                                        Rectangle().fill(.secondary.opacity(0.15))
                                        Image(systemName: "photo")
                                            .imageScale(.large)
                                            .foregroundStyle(.secondary)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .aspectRatio(1.25, contentMode: .fit)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        } else if let videoSource = source as? PostVideoSource {
                            CarouselVideoPlayerView(source: videoSource, isVisible: viewModel.selection == index)
                        }
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page)
            .frame(maxWidth: .infinity)
            .aspectRatio(1.25, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 8))

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
    }
}
