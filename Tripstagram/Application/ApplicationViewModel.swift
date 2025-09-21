import Combine
import TripstagramPresentation
import TripstagramStorage
import TripstagramNetwork

@MainActor
class ApplicationViewModel: ObservableObject {
    
    var presentationViewModel: PresentationViewModel!
    var storage: Storage!
    var network: Network!
    
    @Published var isInitialized: Bool = false
    
    // MARK: - Init
    
    func initialize() throws {
        try initializeStorage()
        initializeNetwork()
        initializePresentation()
        isInitialized = true
    }
    
    private func initializeStorage() throws {
        self.storage = Storage()
        try storage.initialize()
    }
    
    private func initializeNetwork() {
        self.network = Network()
    }
    
    private func initializePresentation() {
        presentationViewModel = PresentationViewModel()
        weak var weakSelf = self
        presentationViewModel.loadPosts = weakSelf?.presentationLoadPosts
        presentationViewModel.loadCachedPosts = weakSelf?.presentationLoadCachedPosts
        presentationViewModel.loadRemoteImageOnlyPostAttachment = weakSelf?.presentationLoadRemoteImageOnlyPostAttachment
        presentationViewModel.getCachedImageOnlyPostAttachment = weakSelf?.presentationGetCachedImageOnlyPostAttachment
    }
}
