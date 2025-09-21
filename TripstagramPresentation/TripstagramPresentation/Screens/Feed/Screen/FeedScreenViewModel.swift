import Foundation

@MainActor
class FeedScreenViewModel: ObservableObject {
    
    // MARK: - View life cycle
    
    func onAppear() {
        loadPosts()
    }
    
    // MARK: - Posts
    
    @Published var posts: [any Post] = []
    
    var onLoadPosts: (() async throws -> [any Post])?
    
    func loadPosts() {
        guard let onLoadPosts else { return }
        Task {
            do {
                posts = try await onLoadPosts()
            } catch {
                print(error)
            }
        }
    }
}
