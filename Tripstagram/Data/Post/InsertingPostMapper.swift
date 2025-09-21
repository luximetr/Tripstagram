import Foundation
import TripstagramNetwork
import TripstagramStorage

class InsertingPostMapper {
    
    static func mapToStorage(networkPost: any NetworkPost) throws -> any StorageInsertingPost {
        switch networkPost {
        case let imageOnlyPost as NetworkImageOnlyPost:
            return mapToStorage(networkImageOnlyPost: imageOnlyPost)
        case let videoOnlyPost as NetworkVideoOnlyPost:
            return mapToStorage(networkVideoOnlyPost: videoOnlyPost)
        case let multiSourcePost as NetworkMultiSourcePost:
            return mapToStorage(networkMultiSourcePost: multiSourcePost)
        default:
            throw Error("Unsupported network post type")
        }
    }
    
    private static func mapToStorage(networkImageOnlyPost: NetworkImageOnlyPost) -> StorageInsertingImageOnlyPost {
        let storagePost = StorageInsertingImageOnlyPost(
            id: networkImageOnlyPost.id,
            postedAt: networkImageOnlyPost.postedAt,
            attachmentRemoteURL: networkImageOnlyPost.source.url
        )
        return storagePost
    }
    
    private static func mapToStorage(networkVideoOnlyPost: NetworkVideoOnlyPost) -> StorageInsertingVideoOnlyPost {
        let storagePost = StorageInsertingVideoOnlyPost(
            id: networkVideoOnlyPost.id,
            postedAt: networkVideoOnlyPost.postedAt,
            attachmentRemoteURL: networkVideoOnlyPost.source.url
        )
        return storagePost
    }
    
    private static func mapToStorage(networkMultiSourcePost: NetworkMultiSourcePost) -> StorageInsertingMultiSourcePost {
        let storagePost = StorageInsertingMultiSourcePost(
            id: networkMultiSourcePost.id,
            postedAt: networkMultiSourcePost.postedAt
        )
        return storagePost
    }
}

typealias StorageInsertingPost = TripstagramStorage.InsertingPost
typealias StorageInsertingImageOnlyPost = TripstagramStorage.InsertingImageOnlyPost
typealias StorageInsertingVideoOnlyPost = TripstagramStorage.InsertingVideoOnlyPost
typealias StorageInsertingMultiSourcePost = TripstagramStorage.InsertingMultiSourcePost
