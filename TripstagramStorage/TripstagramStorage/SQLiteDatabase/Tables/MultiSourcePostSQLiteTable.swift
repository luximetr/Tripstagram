import SQLite3
import TripstagramSQLite3

class MultiSourcePostSQLiteTable {
    
    // MARK: - Create
    
    func create(databaseConnection: OpaquePointer) throws {
        do {
            let statement =
                """
                CREATE TABLE
                multi_source_post(
                    id TEXT PRIMARY KEY,
                    posted_at INTEGER
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
            CREATE INDEX "index_posted_at_multi_source_post" ON "multi_source_post" (
                "posted_at"    DESC
            );
            """
        let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
        try sqlite3StepDone(preparedStatement)
        try sqlite3Finalize(preparedStatement)
    }
    
    // MARK: - Insert
    
    func insert(databaseConnection: OpaquePointer, id: String, postedAt: Int64) throws {
        do {
            let statement =
                """
                INSERT INTO multi_source_post(id, posted_at)
                VALUES (?, ?);
                """
            let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
            try sqlite3BindText(preparedStatement, 1, id)
            try sqlite3BindInt64(preparedStatement, 2, postedAt)
            try sqlite3StepDone(preparedStatement)
            try sqlite3Finalize(preparedStatement)
        } catch {
            throw error
        }
    }
    
    // MARK: - Select
    
    func select(databaseConnection: OpaquePointer) throws -> [Row] {
        do {
            let statement =
                """
                SELECT id, posted_at FROM multi_source_post;
                """
            let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
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
    
    typealias Row = (id: String, postedAt: Int64)
    
    private func extractRow(_ preparedStatement: OpaquePointer) throws -> Row {
        do {
            let id = try sqlite3ColumnText(preparedStatement, 0)
            let postedAt = try sqlite3ColumnInt64(preparedStatement, 1)
            let expenseSelectedRow = Row(id: id, postedAt: postedAt)
            return expenseSelectedRow
        } catch {
            throw error
        }
    }
    
    // MARK: - Update
    
    // MARK: - Delete
    
    // MARK: - Row
}
