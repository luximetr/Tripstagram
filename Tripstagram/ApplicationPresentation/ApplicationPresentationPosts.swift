import Foundation
import TripstagramNetwork

extension ApplicationViewModel {
    
    func presentationGetPosts() async throws -> [any PresentationPost] {
        let networkPosts = try await network.getPosts()
        cachePosts(networkPosts)
        let presentationPosts = try networkPosts.map({ try PostMapper.mapToPresentation($0) })
        return presentationPosts
    }
    
    func presentationGetCachedPosts() async throws -> [any PresentationPost] {
        return []
    }
    
    private func cachePosts(_ posts: [any NetworkPost]) {
        let videoOnlyPosts = posts.compactMap({ $0 as? VideoOnlyPost })
        if let videoOnlyPost = videoOnlyPosts.first {
            Task {
                do {
                    let url = try await network.downloadFile(remoteURL: videoOnlyPost.source.url)
                    print(url)
                } catch {
                    print(error)
                }
            }
        }
    }
}
