import Foundation
import TripstagramPresentation
import TripstagramNetwork

typealias PresentationPost = TripstagramPresentation.Post
typealias PresentationImageOnlyPost = TripstagramPresentation.ImageOnlyPost
typealias PresentationVideoOnlyPost = TripstagramPresentation.VideoOnlyPost
typealias PresentationMultiSourcePost = TripstagramPresentation.MultiSourcePost
typealias NetworkPost = TripstagramNetwork.Post
typealias NetworkImageOnlyPost = TripstagramNetwork.ImageOnlyPost
typealias NetworkVideoOnlyPost = TripstagramNetwork.VideoOnlyPost
typealias NetworkMultiSourcePost = TripstagramNetwork.MultiSourcePost

class PostMapper {
    
    static func mapToPresentation(_ networkPost: any NetworkPost) throws -> any PresentationPost {
        switch networkPost {
        case let imageOnlyPost as NetworkImageOnlyPost:
            return mapToPresentation(imageOnlyPost)
        case let videoOnlyPost as NetworkVideoOnlyPost:
            return mapToPresentation(videoOnlyPost)
        case let multiSourcePost as NetworkMultiSourcePost:
            return try mapToPresentation(multiSourcePost)
        default:
            throw Error("Unsupported post type")
        }
    }
    
    private static func mapToPresentation(_ networkPost: NetworkImageOnlyPost) -> PresentationImageOnlyPost {
        let presentationPost = PresentationImageOnlyPost(
            id: networkPost.id,
            source: PostSourceMapper.mapToPresentation(networkPost.source)
        )
        return presentationPost
    }
    
    private static func mapToPresentation(_ networkPost: NetworkVideoOnlyPost) -> PresentationVideoOnlyPost {
        let presentationPost = PresentationVideoOnlyPost(
            id: networkPost.id,
            source: PostSourceMapper.mapToPresentation(networkPost.source)
        )
        return presentationPost
    }
    
    private static func mapToPresentation(_ networkPost: NetworkMultiSourcePost) throws -> PresentationMultiSourcePost {
        let presentationSources = try networkPost.sources.map({ try PostSourceMapper.mapToPresentation($0) })
        let presentationPost = PresentationMultiSourcePost(
            id: networkPost.id,
            sources: presentationSources
        )
        return presentationPost
    }
    
}
