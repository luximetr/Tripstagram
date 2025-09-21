import Foundation

class PostMapper {
    
    static func mapToPost(_ postRow: GetPostsSQLiteQuery.Row) throws -> any Post {
        switch postRow.type {
        case GetPostsSQLiteQuery.imageOnlyPostType:
            guard let attachmentURL = URL(string: postRow.attachmentRemoteURL ?? "") else { throw Error("Invalid attachment URL") }
            return ImageOnlyPost(id: postRow.id, postedAt: DateConvertor.toDate(int64: postRow.postedAt), attachmentRemoteURL: attachmentURL)
        case GetPostsSQLiteQuery.videoOnlyPostType:
            guard let attachmentURL = URL(string: postRow.attachmentRemoteURL ?? "") else { throw Error("Invalid attachment URL") }
            return VideoOnlyPost(id: postRow.id, postedAt: DateConvertor.toDate(int64: postRow.postedAt), attachmentRemoteURL: attachmentURL)
        case GetPostsSQLiteQuery.multiSourcePostType:
            return MultiSourcePost(id: postRow.id, postedAt: DateConvertor.toDate(int64: postRow.postedAt), sources: [])
        default:
            throw Error("Unsupported post type")
        }
    }
}
