import Foundation
import TripstagramPresentation
import TripstagramNetwork

typealias PresentationPostSource = TripstagramPresentation.PostSource
typealias PresentationPostImageSource = TripstagramPresentation.PostImageSource
typealias PresentationPostVideoSource = TripstagramPresentation.PostVideoSource
typealias NetworkPostSource = TripstagramNetwork.PostSource
typealias NetworkPostImageSource = TripstagramNetwork.PostImageSource
typealias NetworkPostVideoSource = TripstagramNetwork.PostVideoSource

class PostSourceMapper {
    
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
}
