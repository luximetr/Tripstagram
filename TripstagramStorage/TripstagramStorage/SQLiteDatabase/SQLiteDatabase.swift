import Foundation
import SQLite3
import TripstagramSQLite3

class SQLiteDatabase {
    
    // MARK: - Initialization
    
    init(databaseUrl: URL) {
        self.databaseUrl = databaseUrl
    }
    
    private let databaseUrl: URL
    
    
}
