import Foundation
import TripstagramNetwork
import TripstagramStorage

extension ApplicationViewModel {
    
    func presentationGetPosts() async throws -> [any PresentationPost] {
        let networkPosts = try await network.getPosts()
        try cachePosts(networkPosts)
        let presentationPosts = try networkPosts.map({ try PostMapper.mapToPresentation($0) })
        return presentationPosts
    }
    
    func presentationGetCachedPosts() async throws -> [any PresentationPost] {
        let storagePosts = try await storage.fetchAllPosts()
        return []
    }
    
    private func cachePosts(_ posts: [any NetworkPost]) throws {
        Task {
            let storagePosts = try posts.map({ try InsertingPostMapper.mapToStorage(networkPost: $0) })
            try await storage.insertPosts(storagePosts)
        }
    }
    
    func presentationDownloadPostAttachment(url: URL) -> URL {
        return url
    }
}
