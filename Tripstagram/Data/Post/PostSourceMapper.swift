import Foundation
import TripstagramPresentation
import TripstagramNetwork
import TripstagramStorage

class PostSourceMapper {
    
    // MARK: - Presentation
    
    static func mapToPresentation(_ postSource: any NetworkPostSource) throws -> any PresentationPostSource {
        switch postSource {
        case let postImageSource as NetworkPostImageSource:
            return mapToPresentation(postImageSource)
        case let postVideoSource as NetworkPostVideoSource:
            return mapToPresentation(postVideoSource)
        default:
            throw Error("Unsupported post source")
        }
    }
    
    static func mapToPresentation(_ postSource: NetworkPostImageSource) -> PresentationPostImageSource {
        return .init(url: postSource.url)
    }
    
    static func mapToPresentation(_ postSource: NetworkPostVideoSource) -> PresentationPostVideoSource {
        return .init(url: postSource.url)
    }
    
    // MARK: - Storage
    
    static func mapToStorage(_ postSource: any NetworkPostSource) throws -> any StoragePostSource {
        switch postSource {
        case let postImageSource as NetworkPostImageSource:
            return mapToStorage(postImageSource)
        case let postVideoSource as NetworkPostVideoSource:
            return mapToStorage(postVideoSource)
        default:
            throw Error("Unsupported post source")
        }
    }
    
    static func mapToStorage(_ postSource: NetworkPostImageSource) -> StoragePostImageSource {
        return .init(url: postSource.url)
    }
    
    static func mapToStorage(_ postSource: NetworkPostVideoSource) -> StoragePostVideoSource {
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
