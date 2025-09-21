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
                postedAt: DateConvertor.toInt64(date: imageOnlyPost.postedAt)
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
                postedAt: DateConvertor.toInt64(date: videoOnlyPost.postedAt)
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
        } catch {
            throw error
        }
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
