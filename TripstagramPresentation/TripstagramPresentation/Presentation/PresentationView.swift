import SwiftUI
import AVKit

public struct PresentationView: View {
    
    // MARK: - Init
    
    public init(viewModel: PresentationViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: - ViewModel
    
    @StateObject var viewModel: PresentationViewModel
    
    // MARK: - Appearance
    
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - Body
    
    public var body: some View {
        viewModel.createFeedScreenView()
            .environment(\.appearance, viewModel.appearance)
            .onAppear {
                viewModel.setColorScheme(colorScheme)
            }
            .onChange(of: colorScheme) {
                viewModel.setColorScheme(colorScheme)
            }
    }
}

#Preview {
    PresentationView(viewModel: PresentationViewModel())
}
