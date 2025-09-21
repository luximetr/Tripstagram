import Foundation
import TripstagramNetwork
import TripstagramStorage

extension ApplicationViewModel {
    
    func presentationGetPosts() async throws -> [any PresentationPost] {
        let networkPosts = try await network.getPosts()
        try cachePosts(networkPosts)
        let presentationPosts = try networkPosts.map({ try PostMapper.mapToPresentation($0) })
        return presentationPosts
    }
    
    func presentationGetCachedPosts() async throws -> [any PresentationPost] {
        let storagePosts = try await storage.fetchAllPosts()
        return []
    }
    
    private func cachePosts(_ posts: [any NetworkPost]) throws {
        for post in posts {
            if let imageOnlyPost = post as? NetworkImageOnlyPost {
//                Task {
//                    do {
//                        let downloadedFile = try await network.downloadFile(remoteURL: imageOnlyPost.source.url)
//                        let storageDownloadedFile = DownloadedFileMapper.mapToStorage(networkDownloadedFile: downloadedFile)
//                        let storageImageOnlyPost = StorageInsertingImageOnlyPost(id: post.id, postedAt: post.postedAt, attachment: storageDownloadedFile)
//                        try await storage.insertPosts([storageImageOnlyPost])
//                    } catch {
//                        print(error)
//                    }
//                }
            } else if let videoOnlyPost = post as? NetworkVideoOnlyPost {
                Task {
                    do {
                        let downloadedFile = try await network.downloadFile(remoteURL: videoOnlyPost.source.url)
                        let storageDownloadedFile = DownloadedFileMapper.mapToStorage(networkDownloadedFile: downloadedFile)
                        let storageVideoOnlyPost = StorageInsertingVideoOnlyPost(id: post.id, postedAt: post.postedAt, attachment: storageDownloadedFile)
                        try await storage.insertPosts([storageVideoOnlyPost])
                    } catch {
                        print(error)
                    }
                }
            } else if let multiSourcePost = post as? NetworkMultiSourcePost {
                Task {
                    do {
                        var downloadedFiles: [NetworkDownloadedFile] = []
                        for source in multiSourcePost.sources {
                            if let imageSource = source as? NetworkPostImageSource {
                                downloadedFiles.append(try await network.downloadFile(remoteURL: imageSource.url))
                            } else if let videoSource = source as? NetworkPostVideoSource {
                                downloadedFiles.append(try await network.downloadFile(remoteURL: videoSource.url))
                            }
                        }
                        let storageDownloadedFiles = downloadedFiles.map({ DownloadedFileMapper.mapToStorage(networkDownloadedFile: $0) })
                        let storageMultiSourcePost = StorageInsertingMultiSourcePost(id: post.id, postedAt: post.postedAt, attachments: storageDownloadedFiles)
                        try await storage.insertPosts([storageMultiSourcePost])
                    } catch {
                        print(error)
                    }
                }
            }
        }
//        let storagePosts = try posts.map({ try PostMapper.mapToStorage($0) })
//        
//        Task {
//            try await storage.insertPosts(storagePosts)
//        }
//        storage.savePosts(posts)
//        let videoOnlyPosts = posts.compactMap({ $0 as? VideoOnlyPost })
//        if let videoOnlyPost = videoOnlyPosts.first {
//            Task {
//                do {
//                    let url = try await network.downloadFile(remoteURL: videoOnlyPost.source.url)
//                    print(url)
//                } catch {
//                    print(error)
//                }
//            }
//        }
    }
}
