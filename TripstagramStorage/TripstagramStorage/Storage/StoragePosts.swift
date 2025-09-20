import Foundation

extension Storage {
    
    public func insertPosts(_ posts: [any Post]) async throws {
        try await performInBackgroundWriteTransaction { [weak self] transaction in
            guard let self else { throw Error.unwrapWeakSelf }
            try posts.forEach { post in
                try self.insert(databaseConnection: transaction.databaseConnection, post: post)
            }
        }
    }
    
    private func insert(databaseConnection: OpaquePointer, post: any Post) throws {
        switch post {
        case let imageOnlyPost as ImageOnlyPost:
            try self.insert(databaseConnection: databaseConnection, imageOnlyPost: imageOnlyPost)
        case let videoOnlyPost as VideoOnlyPost:
            try self.insert(databaseConnection: databaseConnection, videoOnlyPost: videoOnlyPost)
        case let multiSourcePost as MultiSourcePost:
            try self.insert(databaseConnection: databaseConnection, multiSourcePost: multiSourcePost)
        default:
            throw Error("Unsupported post type")
        }
    }
    
    private func insert(databaseConnection: OpaquePointer, imageOnlyPost: ImageOnlyPost) throws {
        try self.sqliteDatabase().imageOnlyPostTable().insert(
            databaseConnection: databaseConnection,
            id: imageOnlyPost.id,
            postedAt: DateConvertor.toInt64(date: imageOnlyPost.postedAt)
        )
    }
    
    private func insert(databaseConnection: OpaquePointer, videoOnlyPost: VideoOnlyPost) throws {
        
    }
    
    private func insert(databaseConnection: OpaquePointer, multiSourcePost: MultiSourcePost) throws {
        
    }
    
    public func fetchAllPosts() async throws -> [any Post] {
        return try await performBackgroundReadTask { [weak self] databaseConnection in
            guard let self else { throw Error.unwrapWeakSelf }
            let postRows = try self.sqliteDatabase().getPostsQuery().selectAllOrderByPostedAt(databaseConnection: databaseConnection)
            let posts = postRows.map({ PostMapper.mapToPost($0) })
            return posts
        }
    }
    
}
