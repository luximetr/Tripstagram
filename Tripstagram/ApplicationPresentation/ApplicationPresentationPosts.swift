import Foundation
import TripstagramPresentation
import TripstagramNetwork
import TripstagramStorage

extension ApplicationViewModel {
    
    func presentationLoadPosts() async throws -> [any PresentationPost] {
        let networkPosts = try await network.getPosts()
        try cachePosts(networkPosts)
        let presentationPosts = try networkPosts.map({ try PostMapper.mapToPresentation(networkPost: $0) })
        return presentationPosts
    }
    
    func presentationLoadCachedPosts() async throws -> [any PresentationPost] {
        let storagePosts = try await storage.fetchAllPosts()
        let presentationPosts = try storagePosts.map({ try PostMapper.mapToPresentation(storagePost: $0) })
        return presentationPosts
    }
    
    private func cachePosts(_ posts: [any NetworkPost]) throws {
        Task {
            let storagePosts = try posts.map({ try InsertingPostMapper.mapToStorage(networkPost: $0) })
            try await storage.insertPosts(storagePosts)
        }
    }
    
    func presentationLoadRemoteImageOnlyPostAttachment(post: PresentationImageOnlyPost) async throws -> URL {
        let networkDownloadedFile = try await network.downloadFile(remoteURL: post.attachmentRemoteURL)
        let storageDownloadedFile = DownloadedFileMapper.mapToStorage(networkDownloadedFile: networkDownloadedFile)
        let attachmentURL = try storage.saveImageOnlyPostAttachment(postId: post.id, attachment: storageDownloadedFile)
        return attachmentURL
    }
    
    func presentationGetCachedImageOnlyPostAttachment(post: PresentationImageOnlyPost) throws -> URL? {
        return try storage.getCachedImageOnlyAttachmentURL(postId: post.id)
    }
}
