import Foundation
import TripstagramPresentation
import TripstagramNetwork
import TripstagramStorage

class PostSourceMapper {
    
    // MARK: - Presentation
    
    static func mapToPresentation(networkPostSource postSource: any NetworkPostSource) throws -> any PresentationPostSource {
        switch postSource {
        case let postImageSource as NetworkPostImageSource:
            return mapToPresentation(networkPostImageSource: postImageSource)
        case let postVideoSource as NetworkPostVideoSource:
            return mapToPresentation(networkPostVideoSource: postVideoSource)
        default:
            throw Error("Unsupported post source")
        }
    }
    
    static func mapToPresentation(networkPostImageSource postSource: NetworkPostImageSource) -> PresentationPostImageSource {
        return .init(url: postSource.url)
    }
    
    static func mapToPresentation(networkPostVideoSource postSource: NetworkPostVideoSource) -> PresentationPostVideoSource {
        return .init(url: postSource.url)
    }
    
    static func mapToPresentation(storagePostSource postSource: any StoragePostSource) throws -> any PresentationPostSource {
        switch postSource {
        case let postImageSource as StoragePostImageSource:
            return mapToPresentation(storagePostImageSource: postImageSource)
        case let postVideoSource as StoragePostVideoSource:
            return mapToPresentation(storagePostVideoSource: postVideoSource)
        default:
            throw Error("Unsupported post source")
        }
    }
    
    static func mapToPresentation(storagePostImageSource postSource: StoragePostImageSource) -> PresentationPostImageSource {
        return .init(url: postSource.url)
    }
    
    static func mapToPresentation(storagePostVideoSource postSource: StoragePostVideoSource) -> PresentationPostVideoSource {
        return .init(url: postSource.url)
    }
    
    // MARK: - Storage
    
    static func mapToStorage(networkPostSource postSource: any NetworkPostSource) throws -> any StoragePostSource {
        switch postSource {
        case let postImageSource as NetworkPostImageSource:
            return mapToStorage(networkPostImageSource: postImageSource)
        case let postVideoSource as NetworkPostVideoSource:
            return mapToStorage(networkPostVideoSource: postVideoSource)
        default:
            throw Error("Unsupported post source")
        }
    }
    
    static func mapToStorage(networkPostImageSource postSource: NetworkPostImageSource) -> StoragePostImageSource {
        return .init(url: postSource.url)
    }
    
    static func mapToStorage(networkPostVideoSource postSource: NetworkPostVideoSource) -> StoragePostVideoSource {
        return .init(url: postSource.url)
    }
}

typealias PresentationPostSource = TripstagramPresentation.PostSource
typealias PresentationPostImageSource = TripstagramPresentation.PostImageSource
typealias PresentationPostVideoSource = TripstagramPresentation.PostVideoSource
typealias NetworkPostSource = TripstagramNetwork.PostSource
typealias NetworkPostImageSource = TripstagramNetwork.PostImageSource
typealias NetworkPostVideoSource = TripstagramNetwork.PostVideoSource
typealias StoragePostSource = TripstagramStorage.PostSource
typealias StoragePostImageSource = TripstagramStorage.PostImageSource
typealias StoragePostVideoSource = TripstagramStorage.PostVideoSource
