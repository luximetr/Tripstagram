import Foundation
import CoreData

public class Storage {
    
    // MARK: - Init
    
    public init() {
        self.sqlDatabaseFilename = "TripstagramDatabase"
        self.fileManager = FileManager.default
    }
    
    public func initialize() throws {
    }
    
    // MARK: - File manager
    
    let fileManager: FileManager
    
    private var _documentDirectoryURL: URL?
    func documentDirectoryURL() throws -> URL {
        do {
            if let documentDirectoryURL = _documentDirectoryURL {
                return documentDirectoryURL
            } else {
                let documentDirectoryURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                _documentDirectoryURL = documentDirectoryURL
                return documentDirectoryURL
            }
        } catch {
            throw Error("Cannot construct document directory URL\n\(error)")
        }
    }
    
    // MARK: - SqliteDatabase
    
    private let sqlDatabaseFilename: String
    
    private var _sqliteDatabaseURL: URL?
    private func sqliteDatabaseURL() throws -> URL {
        do {
            if let sqliteDatabaseURL = _sqliteDatabaseURL {
                return sqliteDatabaseURL
            } else {
                let sqliteDatabaseURL = try documentDirectoryURL().appendingPathComponent("\(sqlDatabaseFilename).sqlite")
                print(sqliteDatabaseURL)
                _sqliteDatabaseURL = sqliteDatabaseURL
                return sqliteDatabaseURL
            }
        } catch {
            throw Error("Error\n\(error)")
        }
    }
        
    private var _sqliteDatabase: SQLiteDatabase?
    func sqliteDatabase() throws -> SQLiteDatabase {
        do {
            if let sqliteDatabase = _sqliteDatabase {
                return sqliteDatabase
            } else {
                let sqliteDatabaseURL = try sqliteDatabaseURL()
                let sqliteDatabase = SQLiteDatabase(databaseURL: sqliteDatabaseURL)
                _sqliteDatabase = sqliteDatabase
                return sqliteDatabase
            }
        } catch {
            throw Error("Error\n\(error)")
        }
    }
}
