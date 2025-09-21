import SQLite3
import TripstagramSQLite3

class MultiSourcePostImageAttachmentSQLiteTable {
    
    // MARK: - Create
    
    func create(databaseConnection: OpaquePointer) throws {
        do {
            let statement =
                """
                CREATE TABLE
                multi_source_post_image_attachment(
                    id TEXT PRIMARY KEY,
                    post_id TEXT,
                    order_number INTEGER,
                    remote_url TEXT,
                    FOREIGN KEY(post_id) REFERENCES multi_source_post(id)
                );
                """
            let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
            try sqlite3StepDone(preparedStatement)
            try sqlite3Finalize(preparedStatement)
        } catch {
            throw error
        }
    }
    
    // MARK: - Insert
    
    func insert(databaseConnection: OpaquePointer, id: String, postId: String, orderNumber: Int64, remoteURL: String) throws {
        do {
            let statement =
                """
                INSERT INTO multi_source_post_image_attachment(id, post_id, order_number, remote_url)
                VALUES (?, ?, ?, ?);
                """
            let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
            try sqlite3BindText(preparedStatement, 1, id)
            try sqlite3BindText(preparedStatement, 2, postId)
            try sqlite3BindInt64(preparedStatement, 3, orderNumber)
            try sqlite3BindText(preparedStatement, 4, remoteURL)
            try sqlite3StepDone(preparedStatement)
            try sqlite3Finalize(preparedStatement)
        } catch {
            throw error
        }
    }
    
    // MARK: - Select
    
    func select(databaseConnection: OpaquePointer, wherePostId postId: String) throws -> [Row] {
        do {
            let statement =
                """
                SELECT id, post_id, order_number, remote_url FROM multi_source_post_image_attachment
                WHERE post_id = ?;
                """
            let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
            try sqlite3BindText(preparedStatement, 1, postId)
            var rows: [Row] = []
            while(try sqlite3StepRow(preparedStatement)) {
                let row = try extractRow(preparedStatement)
                rows.append(row)
            }
            try sqlite3Finalize(preparedStatement)
            return rows
        } catch {
            throw error
        }
    }
    
    typealias Row = (id: String, postId: String, orderNumber: Int64, remoteURL: String)
    
    private func extractRow(_ preparedStatement: OpaquePointer) throws -> Row {
        do {
            let id = try sqlite3ColumnText(preparedStatement, 0)
            let postId = try sqlite3ColumnText(preparedStatement, 1)
            let orderNumber = try sqlite3ColumnInt64(preparedStatement, 2)
            let remoteURL = try sqlite3ColumnText(preparedStatement, 3)
            let row = Row(id: id, postId: postId, orderNumber: orderNumber, remoteURL: remoteURL)
            return row
        } catch {
            throw error
        }
    }
}
