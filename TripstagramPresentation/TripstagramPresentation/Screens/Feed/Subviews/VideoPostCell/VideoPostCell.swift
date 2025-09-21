import SwiftUI
import AVFoundation

struct VideoPostCell: View {

    // MARK: - Init
    
    init(viewModel: VideoPostCellViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: - ViewModel
    
    @StateObject var viewModel: VideoPostCellViewModel
    
    // MARK: - Appearance
    
    @Environment(\.appearance) private var appearance
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 8) {
            VideoPlayerView(player: viewModel.player)
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
        .onAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
    }
}
