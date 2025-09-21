import Foundation

extension Storage {
    
    public func insertPosts(_ posts: [any InsertingPost]) async throws {
        try await performInBackgroundWriteTransaction { [weak self] transaction in
            guard let self else { throw Error.unwrapWeakSelf }
            try posts.forEach { post in
                try self.insert(databaseConnection: transaction.databaseConnection, post: post)
            }
        }
    }
    
    private func insert(databaseConnection: OpaquePointer, post: any InsertingPost) throws {
        switch post {
        case let imageOnlyPost as InsertingImageOnlyPost:
            try self.insert(databaseConnection: databaseConnection, imageOnlyPost: imageOnlyPost)
        case let videoOnlyPost as InsertingVideoOnlyPost:
            try self.insert(databaseConnection: databaseConnection, videoOnlyPost: videoOnlyPost)
        case let multiSourcePost as InsertingMultiSourcePost:
            try self.insert(databaseConnection: databaseConnection, multiSourcePost: multiSourcePost)
        default:
            throw Error("Unsupported post type")
        }
    }
    
    private func insert(databaseConnection: OpaquePointer, imageOnlyPost: InsertingImageOnlyPost) throws {
        do {
            try self.sqliteDatabase().imageOnlyPostTable().insert(
                databaseConnection: databaseConnection,
                id: imageOnlyPost.id,
                postedAt: DateConvertor.toInt64(date: imageOnlyPost.postedAt),
                attachmentRemoteURL: URLMapper.toString(url: imageOnlyPost.attachmentRemoteURL)
            )
        } catch {
            throw error
        }
    }
    
    private func insert(databaseConnection: OpaquePointer, videoOnlyPost: InsertingVideoOnlyPost) throws {
        do {
            try sqliteDatabase().videoOnlyPostTable().insert(
                databaseConnection: databaseConnection,
                id: videoOnlyPost.id,
                postedAt: DateConvertor.toInt64(date: videoOnlyPost.postedAt),
                attachmentRemoteURL: URLMapper.toString(url: videoOnlyPost.attachmentRemoteURL)
            )
        } catch {
            throw error
        }
    }
    
    private func insert(databaseConnection: OpaquePointer, multiSourcePost: InsertingMultiSourcePost) throws {
        do {
            try sqliteDatabase().multiSourcePostTable().insert(
                databaseConnection: databaseConnection,
                id: multiSourcePost.id,
                postedAt: DateConvertor.toInt64(date: multiSourcePost.postedAt)
            )
            for (index, postSource) in multiSourcePost.sources.enumerated() {
                try insert(databaseConnection: databaseConnection, multiSourcePostSource: postSource, postId: multiSourcePost.id, orderNumber: index)
            }
        } catch {
            throw error
        }
    }
    
    private func insert(databaseConnection: OpaquePointer, multiSourcePostSource: PostSource, postId: String, orderNumber: Int) throws {
        switch multiSourcePostSource {
        case let postImageSource as PostImageSource:
            try insert(databaseConnection: databaseConnection, multiSourcePostImageSource: postImageSource, postId: postId, orderNumber: orderNumber)
        case let postVideoSource as PostVideoSource:
            try insert(databaseConnection: databaseConnection, multiSourcePostVideoSource: postVideoSource, postId: postId, orderNumber: orderNumber)
        default:
            throw Error("Unsupported post source type")
        }
    }
    
    private func insert(databaseConnection: OpaquePointer, multiSourcePostImageSource: PostImageSource, postId: String, orderNumber: Int) throws {
        try sqliteDatabase().multiSourcePostImageAttachmentTable().insert(
            databaseConnection: databaseConnection,
            id: UUID().uuidString,
            postId: postId,
            orderNumber: Int64(orderNumber),
            remoteURL: URLMapper.toString(url: multiSourcePostImageSource.url)
        )
    }
    
    private func insert(databaseConnection: OpaquePointer, multiSourcePostVideoSource: PostVideoSource, postId: String, orderNumber: Int) throws {
        try sqliteDatabase().multiSourcePostVideoAttachmentTable().insert(
            databaseConnection: databaseConnection,
            id: UUID().uuidString,
            postId: postId,
            orderNumber: Int64(orderNumber),
            remoteURL: URLMapper.toString(url: multiSourcePostVideoSource.url)
        )
    }
    
    public func fetchAllPosts() async throws -> [any Post] {
        return try await performBackgroundReadTask { [weak self] databaseConnection in
            guard let self else { throw Error.unwrapWeakSelf }
            let postRows = try self.sqliteDatabase().getPostsQuery().selectAllOrderByPostedAt(databaseConnection: databaseConnection)
            var posts: [any Post] = []
            for postRow in postRows {
                switch postRow.type {
                case GetPostsSQLiteQuery.imageOnlyPostType:
                    guard let attachmentURL = URL(string: postRow.attachmentRemoteURL ?? "") else { throw Error("Invalid attachment URL") }
                    let imageOnlyPost = ImageOnlyPost(id: postRow.id, postedAt: DateConvertor.toDate(int64: postRow.postedAt), attachmentRemoteURL: attachmentURL)
                    posts.append(imageOnlyPost)
                case GetPostsSQLiteQuery.videoOnlyPostType:
                    guard let attachmentURL = URL(string: postRow.attachmentRemoteURL ?? "") else { throw Error("Invalid attachment URL") }
                    let videoOnlyPost = VideoOnlyPost(id: postRow.id, postedAt: DateConvertor.toDate(int64: postRow.postedAt), attachmentRemoteURL: attachmentURL)
                    posts.append(videoOnlyPost)
                case GetPostsSQLiteQuery.multiSourcePostType:
                    let imageAttachmentRows = try self.sqliteDatabase().multiSourcePostImageAttachmentTable().select(databaseConnection: databaseConnection, wherePostId: postRow.id)
                    let videoAttachmentRows = try self.sqliteDatabase().multiSourcePostVideoAttachmentTable().select(databaseConnection: databaseConnection, wherePostId: postRow.id)
                    var sourcesByOrderNumber: [Int64: any PostSource] = [:]
                    for imageAttachmentRow in imageAttachmentRows {
                        guard let attachmentURL = URL(string: imageAttachmentRow.remoteURL) else { throw Error("Invalid attachment URL") }
                        let imageSource = PostImageSource(url: attachmentURL)
                        sourcesByOrderNumber[imageAttachmentRow.orderNumber] = imageSource
                    }
                    for videoAttachmentRow in videoAttachmentRows {
                        guard let attachmentURL = URL(string: videoAttachmentRow.remoteURL) else { throw Error("Invalid attachment URL") }
                        let videoSource = PostVideoSource(url: attachmentURL)
                        sourcesByOrderNumber[videoAttachmentRow.orderNumber] = videoSource
                    }
                    let sources = sourcesByOrderNumber.sorted(by: { $0.key < $1.key }).map({ $0.value })
                    let multiSourcePost = MultiSourcePost(id: postRow.id, postedAt: DateConvertor.toDate(int64: postRow.postedAt), sources: sources)
                    posts.append(multiSourcePost)
                default:
                    continue
                }
            }
            return posts
        }
    }
    
}
