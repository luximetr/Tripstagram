import Foundation
import TripstagramNetwork

extension ApplicationViewModel {
    
    func presentationGetPosts() async throws -> [any PresentationPost] {
        let networkPosts = try await network.getPosts()
        let presentationPosts = try networkPosts.map({ try PostMapper.mapToPresentation($0) })
        return presentationPosts
    }
}
