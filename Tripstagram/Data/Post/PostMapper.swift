import Foundation
import TripstagramPresentation
import TripstagramNetwork
import TripstagramStorage

class PostMapper {
    
    // MARK: - Presentation
    
    static func mapToPresentation(networkPost: any NetworkPost) throws -> any PresentationPost {
        switch networkPost {
        case let imageOnlyPost as NetworkImageOnlyPost:
            return mapToPresentation(networkImageOnlyPost: imageOnlyPost)
        case let videoOnlyPost as NetworkVideoOnlyPost:
            return mapToPresentation(networkVideoOnlyPost: videoOnlyPost)
        case let multiSourcePost as NetworkMultiSourcePost:
            return try mapToPresentation(networkMultiSourcePost: multiSourcePost)
        default:
            throw Error("Unsupported post type")
        }
    }
    
    private static func mapToPresentation(networkImageOnlyPost networkPost: NetworkImageOnlyPost) -> PresentationImageOnlyPost {
        let presentationPost = PresentationImageOnlyPost(
            id: networkPost.id,
            attachmentRemoteURL: networkPost.source.url
        )
        return presentationPost
    }
    
    private static func mapToPresentation(networkVideoOnlyPost networkPost: NetworkVideoOnlyPost) -> PresentationVideoOnlyPost {
        let presentationPost = PresentationVideoOnlyPost(
            id: networkPost.id,
            attachmentRemoteURL: networkPost.source.url
        )
        return presentationPost
    }
    
    private static func mapToPresentation(networkMultiSourcePost networkPost: NetworkMultiSourcePost) throws -> PresentationMultiSourcePost {
        let presentationSources = try networkPost.sources.map({ try PostSourceMapper.mapToPresentation(networkPostSource: $0) })
        let presentationPost = PresentationMultiSourcePost(
            id: networkPost.id,
            sources: presentationSources
        )
        return presentationPost
    }
    
    static func mapToPresentation(storagePost: any StoragePost) throws -> any PresentationPost {
        switch storagePost {
        case let imageOnlyPost as StorageImageOnlyPost:
            return mapToPresentation(storageImageOnlyPost: imageOnlyPost)
        case let videoOnlyPost as StorageVideoOnlyPost:
            return mapToPresentation(storageVideoOnlyPost: videoOnlyPost)
        case let multiSourcePost as StorageMultiSourcePost:
            return try mapToPresentation(storageMultiSourcePost: multiSourcePost)
        default:
            throw Error("Unsupported storage post type")
        }
    }
    
    private static func mapToPresentation(storageImageOnlyPost storagePost: StorageImageOnlyPost) -> PresentationImageOnlyPost {
        let presentationPost = PresentationImageOnlyPost(
            id: storagePost.id,
            attachmentRemoteURL: storagePost.attachmentRemoteURL
        )
        return presentationPost
    }
    
    private static func mapToPresentation(storageVideoOnlyPost storagePost: StorageVideoOnlyPost) -> PresentationVideoOnlyPost {
        let presentationPost = PresentationVideoOnlyPost(
            id: storagePost.id,
            attachmentRemoteURL: storagePost.attachmentRemoteURL
        )
        return presentationPost
    }
    
    private static func mapToPresentation(storageMultiSourcePost storagePost: StorageMultiSourcePost) throws -> PresentationMultiSourcePost {
        let presentationSources = try storagePost.sources.map({ try PostSourceMapper.mapToPresentation(storagePostSource: $0) })
        let presentationPost = PresentationMultiSourcePost(
            id: storagePost.id,
            sources: presentationSources
        )
        return presentationPost
    }
    
}

typealias PresentationPost = TripstagramPresentation.Post
typealias PresentationImageOnlyPost = TripstagramPresentation.ImageOnlyPost
typealias PresentationVideoOnlyPost = TripstagramPresentation.VideoOnlyPost
typealias PresentationMultiSourcePost = TripstagramPresentation.MultiSourcePost
typealias NetworkPost = TripstagramNetwork.Post
typealias NetworkImageOnlyPost = TripstagramNetwork.ImageOnlyPost
typealias NetworkVideoOnlyPost = TripstagramNetwork.VideoOnlyPost
typealias NetworkMultiSourcePost = TripstagramNetwork.MultiSourcePost
typealias StoragePost = TripstagramStorage.Post
typealias StorageImageOnlyPost = TripstagramStorage.ImageOnlyPost
typealias StorageVideoOnlyPost = TripstagramStorage.VideoOnlyPost
typealias StorageMultiSourcePost = TripstagramStorage.MultiSourcePost
