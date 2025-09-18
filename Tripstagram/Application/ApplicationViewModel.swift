import Combine
import TripstagramPresentation

@MainActor
class ApplicationViewModel: ObservableObject {
    
    var presentationViewModel: PresentationViewModel!
    
    @Published var isInitialized: Bool = false
    
    // MARK: - Init
    
    func initialize() throws {
        initializePresentation()
        isInitialized = true
    }
    
    private func initializePresentation() {
        presentationViewModel = PresentationViewModel()
    }
}
