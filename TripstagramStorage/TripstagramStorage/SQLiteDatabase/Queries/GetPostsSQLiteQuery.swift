import SQLite3
import TripstagramSQLite3

class GetPostsSQLiteQuery {
    
    let imageOnlyPostType = "imageOnlyPost"
    let videoOnlyPostType = "videoOnlyPost"
    let multiSourcePostType = "multiSourcePost"
    
    func selectAllOrderByPostedAt(databaseConnection: OpaquePointer) throws -> [any PostRow] {
        var statement = "SELECT '\(imageOnlyPostType)' AS type, id, posted_at" + " \n"
        statement += "FROM image_only_post" + " \n"
        
        statement += "UNION ALL" + " \n"
        
        statement += "SELECT '\(videoOnlyPostType)' AS type, id, posted_at" + " \n"
        statement += "FROM video_only_post" + " \n"
        
        statement += "UNION ALL" + " \n"
        
        statement += "SELECT '\(multiSourcePostType)' AS type, id, posted_at" + " \n"
        statement += "FROM multi_source_post" + " \n"
        
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
        var selectedRows: [any PostRow] = []
        while(try sqlite3StepRow(preparedStatement)) {
            let selectedRow = extractPostRow(preparedStatement)
            selectedRows.append(selectedRow)
        }
        try sqlite3Finalize(preparedStatement)
        return selectedRows
    }
    
    // MARK: - Row
    
    protocol PostRow {
        var id: String { get }
        var postedAt: Int64 { get }
    }
    
    struct ImageOnlyPostRow: PostRow {
        let id: String
        let postedAt: Int64
    }
    
    private func extractPostRow(_ preparedStatement: OpaquePointer) -> any PostRow {
        fatalError()
    }
}
