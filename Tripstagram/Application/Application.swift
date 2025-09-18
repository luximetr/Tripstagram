import SwiftUI
import TripstagramPresentation

@main
struct Application: App {
    
    // MARK: - View model
    
    @StateObject var viewModel: ApplicationViewModel
    
    // MARK: - Init
    
    init() {
        _viewModel = StateObject(wrappedValue: ApplicationViewModel())
    }
    
    // MARK: - Content

    var body: some Scene {
        WindowGroup {
            if viewModel.isInitialized {
                if let presentationViewModel = viewModel.presentationViewModel {
                    contentView(viewModel: presentationViewModel)
                } else {
                    errorView
                }
            } else {
                ProgressView()
                    .onAppear {
                    do {
                        try self.viewModel.initialize()
                    } catch {
                        print("Initialization failed: \(error)")
                    }
                }
            }
                
        }
    }
    
    var errorView: some View {
        Text("Application failed to initialize")
    }
    
    func contentView(viewModel: PresentationViewModel) -> some View {
        PresentationView(viewModel: viewModel)
    }
}
