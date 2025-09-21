import SQLite3
import TripstagramSQLite3

class ImageOnlyPostSQLiteTable {
    
    // MARK: - Create
    
    func create(databaseConnection: OpaquePointer) throws {
        do {
            let statement =
                """
                CREATE TABLE
                image_only_post(
                    id TEXT PRIMARY KEY,
                    posted_at INTEGER,
                    attachment_remote_url TEXT
                );
                """
            let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
            try sqlite3StepDone(preparedStatement)
            try sqlite3Finalize(preparedStatement)
        } catch {
            throw error
        }
    }
    
    func createPostedAtIndex(databaseConnection: OpaquePointer) throws {
        let statement =
            """
            CREATE INDEX "index_posted_at_image_only_post" ON "image_only_post" (
                "posted_at"    DESC
            );
            """
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
        try sqlite3StepDone(preparedStatement)
        try sqlite3Finalize(preparedStatement)
    }
    
    // MARK: - Insert
    
    func insert(databaseConnection: OpaquePointer, id: String, postedAt: Int64, attachmentRemoteURL: String) throws {
        do {
            let statement =
                """
                INSERT INTO image_only_post(id, posted_at, attachment_remote_url)
                VALUES (?, ?, ?);
                """
            let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
            try sqlite3BindText(preparedStatement, 1, id)
            try sqlite3BindInt64(preparedStatement, 2, postedAt)
            try sqlite3BindText(preparedStatement, 3, attachmentRemoteURL)
            try sqlite3StepDone(preparedStatement)
            try sqlite3Finalize(preparedStatement)
        } catch {
            throw error
        }
    }
    
    // MARK: - Select
    
    // MARK: - Update
    
    // MARK: - Delete
    
    // MARK: - Row
}
