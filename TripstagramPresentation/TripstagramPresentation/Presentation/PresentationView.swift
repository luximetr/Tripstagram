import SwiftUI

public struct PresentationView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @StateObject var viewModel: PresentationViewModel
    
    public init(viewModel: PresentationViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        Text("Presentation")
    }
    
}

#Preview {
    PresentationView(viewModel: PresentationViewModel())
}
