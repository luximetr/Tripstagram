import Foundation
import TripstagramPresentation
import TripstagramNetwork
import TripstagramStorage

class PostMapper {
    
    // MARK: - Presentation
    
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
            source: PostSourceMapper.mapToPresentation(networkPostImageSource: networkPost.source)
        )
        return presentationPost
    }
    
    private static func mapToPresentation(_ networkPost: NetworkVideoOnlyPost) -> PresentationVideoOnlyPost {
        let presentationPost = PresentationVideoOnlyPost(
            id: networkPost.id,
            source: PostSourceMapper.mapToPresentation(networkPostVideoSource: networkPost.source)
        )
        return presentationPost
    }
    
    private static func mapToPresentation(_ networkPost: NetworkMultiSourcePost) throws -> PresentationMultiSourcePost {
        let presentationSources = try networkPost.sources.map({ try PostSourceMapper.mapToPresentation(networkPostSource: $0) })
        let presentationPost = PresentationMultiSourcePost(
            id: networkPost.id,
            sources: presentationSources
        )
        return presentationPost
    }
    
    private static func mapToPresentation(_ storagePost: StorageImageOnlyPost) -> PresentationImageOnlyPost {
        let presentationPost = PresentationImageOnlyPost(
            id: storagePost.id,
            source: .init(url: storagePost.attachmentURL)
        )
        return presentationPost
    }
    
    private static func mapToPresentation(_ storagePost: StorageVideoOnlyPost) -> PresentationVideoOnlyPost {
        let presentationPost = PresentationVideoOnlyPost(
            id: storagePost.id,
            source: PostSourceMapper.mapToPresentation(storagePostVideoSource: storagePost.source)
        )
        return presentationPost
    }
    
    private static func mapToPresentation(_ storagePost: StorageMultiSourcePost) throws -> PresentationMultiSourcePost {
        let presentationSources = try storagePost.sources.map({ try PostSourceMapper.mapToPresentation(storagePostSource: $0) })
        let presentationPost = PresentationMultiSourcePost(
            id: storagePost.id,
            sources: presentationSources
        )
        return presentationPost
    }
    
    // MARK: - Storage
    
    static func mapToStorage(_ networkPost: any NetworkPost) throws -> any StoragePost {
        switch networkPost {
        case let imageOnlyPost as NetworkImageOnlyPost:
            return mapToStorage(imageOnlyPost)
        case let videoOnlyPost as NetworkVideoOnlyPost:
            return mapToStorage(videoOnlyPost)
        case let multiSourcePost as NetworkMultiSourcePost:
            return try mapToStorage(multiSourcePost)
        default:
            throw Error("Unsupported post type")
        }
    }
    
    private static func mapToStorage(_ networkPost: NetworkImageOnlyPost) -> StorageImageOnlyPost {
        let storagePost = StorageImageOnlyPost(
            id: networkPost.id,
            postedAt: networkPost.postedAt,
            attachmentURL: networkPost.source.url
        )
        return storagePost
    }
    
    private static func mapToStorage(_ networkPost: NetworkVideoOnlyPost) -> StorageVideoOnlyPost {
        let storagePost = StorageVideoOnlyPost(
            id: networkPost.id,
            postedAt: networkPost.postedAt,
            source: PostSourceMapper.mapToStorage(networkPostVideoSource: networkPost.source)
        )
        return storagePost
    }
    
    private static func mapToStorage(_ networkPost: NetworkMultiSourcePost) throws -> StorageMultiSourcePost {
        let presentationSources = try networkPost.sources.map({ try PostSourceMapper.mapToStorage(networkPostSource: $0) })
        let storagePost = StorageMultiSourcePost(
            id: networkPost.id,
            postedAt: networkPost.postedAt,
            sources: presentationSources
        )
        return storagePost
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
typealias StorageInsertingImageOnlyPost = TripstagramStorage.InsertingImageOnlyPost
typealias StorageVideoOnlyPost = TripstagramStorage.VideoOnlyPost
typealias StorageMultiSourcePost = TripstagramStorage.MultiSourcePost
