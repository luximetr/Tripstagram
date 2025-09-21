import SQLite3
import TripstagramSQLite3

class GetPostsSQLiteQuery {
    
    static let imageOnlyPostType = "imageOnlyPost"
    static let videoOnlyPostType = "videoOnlyPost"
    static let multiSourcePostType = "multiSourcePost"
    
    func selectAllOrderByPostedAt(databaseConnection: OpaquePointer) throws -> [Row] {
        var statement = "SELECT '\(Self.imageOnlyPostType)' AS type, id, posted_at, attachment_remote_url" + " \n"
        statement += "FROM image_only_post" + " \n"
        
        statement += "UNION ALL" + " \n"
        
        statement += "SELECT '\(Self.videoOnlyPostType)' AS type, id, posted_at, attachment_remote_url" + " \n"
        statement += "FROM video_only_post" + " \n"
        
        statement += "UNION ALL" + " \n"
        
        statement += "SELECT '\(Self.multiSourcePostType)' AS type, id, posted_at, NULL" + " \n"
        statement += "FROM multi_source_post" + " \n"
        
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
        var selectedRows: [Row] = []
        while(try sqlite3StepRow(preparedStatement)) {
            let selectedRow = try extractPostRow(preparedStatement)
            selectedRows.append(selectedRow)
        }
        try sqlite3Finalize(preparedStatement)
        return selectedRows
    }
    
    // MARK: - Row
    
    typealias Row = (type: String, id: String, postedAt: Int64, attachmentRemoteURL: String?)
    
    private func extractPostRow(_ preparedStatement: OpaquePointer) throws -> Row {
        let type = try sqlite3ColumnText(preparedStatement, 0)
        let id = try sqlite3ColumnText(preparedStatement, 1)
        let postedAt = try sqlite3ColumnInt64(preparedStatement, 2)
        let attachmentRemoteURL = try sqlite3ColumnTextNull(preparedStatement, 3)
        let row = Row(type: type, id: id, postedAt: postedAt, attachmentRemoteURL: attachmentRemoteURL)
        return row
    }
}
