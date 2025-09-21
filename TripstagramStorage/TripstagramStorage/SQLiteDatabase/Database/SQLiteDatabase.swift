import Foundation
import SQLite3
import TripstagramSQLite3

class SQLiteDatabase {
    
    // MARK: - Initialization
    
    init(databaseURL: URL) {
        self.databaseURL = databaseURL
    }
    
    // MARK: - Database URL
    
    private let databaseURL: URL
    
    // MARK: - Queues
    
    private var _backgroundQueueReadConnection: OpaquePointer?
    func backgroundQueueReadConnection() throws -> OpaquePointer {
        do {
            if let backgroundQueueReadConnection = _backgroundQueueReadConnection {
                return backgroundQueueReadConnection
            } else {
                let flags = SQLITE_OPEN_READONLY | SQLITE_OPEN_SHAREDCACHE | SQLITE_OPEN_FULLMUTEX
                let backgroundQueueReadConnection = try sqlite3OpenV2(databaseURL.path, flags: flags, zVfs: nil)
                _backgroundQueueReadConnection = backgroundQueueReadConnection
                return backgroundQueueReadConnection
            }
        } catch {
            throw Error("Error\n\(error)")
        }
    }
    
    private var _backgroundQueueWriteConnection: OpaquePointer?
    func backgroundQueueWriteConnection() throws -> OpaquePointer {
        do {
            if let backgroundQueueWriteConnection = _backgroundQueueWriteConnection {
                return backgroundQueueWriteConnection
            } else {
                let backgroundQueueWriteConnection = try sqlite3Open(databaseURL.path)
                _backgroundQueueWriteConnection = backgroundQueueWriteConnection
                return backgroundQueueWriteConnection
            }
        } catch {
            throw Error("Error\n\(error)")
        }
    }
    
    private var _mainQueueReadConnection: OpaquePointer?
    func mainQueueReadConnection() throws -> OpaquePointer {
        do {
            if let mainQueueReadConnection = _mainQueueReadConnection {
                return mainQueueReadConnection
            } else {
                let mainQueueReadConnection = try sqlite3Open(databaseURL.path)
                _mainQueueReadConnection = mainQueueReadConnection
                return mainQueueReadConnection
            }
        } catch {
            throw Error("Error\n\(error)")
        }
    }
    
    private var _mainQueueWriteConnection: OpaquePointer?
    func mainQueueWriteConnection() throws -> OpaquePointer {
        do {
            if let mainQueueWriteConnection = _mainQueueWriteConnection {
                return mainQueueWriteConnection
            } else {
                let mainQueueWriteConnection = try sqlite3Open(databaseURL.path)
                _mainQueueWriteConnection = mainQueueWriteConnection
                return mainQueueWriteConnection
            }
        } catch {
            throw Error("Error\n\(error)")
        }
    }
    
    // MARK: - Create
    
    func create() throws {
        let databaseConnection = try mainQueueWriteConnection()
        do {
            try setupJournalMode(databaseConnection: databaseConnection)
            try setupSynchronousMode(databaseConnection: databaseConnection)
            try setupWALAutoCheckpoint(databaseConnection: databaseConnection)
            try beginTransaction(databaseConnection: databaseConnection)
            try imageOnlyPostTable().create(databaseConnection: databaseConnection)
            try videoOnlyPostTable().create(databaseConnection: databaseConnection)
            try multiSourcePostTable().create(databaseConnection: databaseConnection)
            try multiSourcePostImageAttachmentTable().create(databaseConnection: databaseConnection)
            try multiSourcePostVideoAttachmentTable().create(databaseConnection: databaseConnection)
            try commitTransaction(databaseConnection: databaseConnection)
        } catch let transactionError {
            do {
                try rollbackTransaction(databaseConnection: databaseConnection)
                let error = Error("Unable to commit transaction\n\(transactionError)")
                throw error
            } catch let rollbackError {
                let error = Error("Unable to rollback transaction\n\(transactionError)\n\(rollbackError)")
                throw error
            }
        }
    }
    
    // MARK: - Setup
    
    private func setupJournalMode(databaseConnection: OpaquePointer) throws {
        do {
            let statement = "PRAGMA journal_mode=WAL;"
            try sqlite3Exec(databaseConnection: databaseConnection, statement)
        } catch let execError {
            let error = Error("Error setting DB journal_mode: \(execError)")
            throw error
        }
    }
    
    private func setupSynchronousMode(databaseConnection: OpaquePointer) throws {
        do {
            let statement = "PRAGMA synchronous=NORMAL;"
            try sqlite3Exec(databaseConnection: databaseConnection, statement)
        } catch let execError {
            let error = Error("Error setting DB synchronous: \(execError)")
            throw error
        }
    }
    
    private func setupWALAutoCheckpoint(databaseConnection: OpaquePointer) throws {
        do {
            let statement = "PRAGMA wal_autocheckpoint=1000;"
            try sqlite3Exec(databaseConnection: databaseConnection, statement)
        } catch let execError {
            let error = Error("Error setting DB wal_autocheckpoint: \(execError)")
            throw error
        }
    }
    
    // MARK: - Transaction
    
    func beginTransaction(databaseConnection: OpaquePointer) throws {
        do {
            let statement = "BEGIN TRANSACTION;"
            let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
            try sqlite3StepDone(preparedStatement)
            try sqlite3Finalize(preparedStatement)
        } catch {
            let error = Error("\(self) Cannot begin transaction\n\(error)")
            throw error
        }
    }
    
    func commitTransaction(databaseConnection: OpaquePointer) throws {
        do {
            let statement = "COMMIT TRANSACTION;"
            let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
            try sqlite3StepDone(preparedStatement)
            try sqlite3Finalize(preparedStatement)
        } catch {
            let error = Error("\(self) Cannot commit transaction\n\(error)")
            throw error
        }
    }
    
    func rollbackTransaction(databaseConnection: OpaquePointer) throws {
        do {
            let statement = "ROLLBACK TRANSACTION;"
            let preparedStatement = try sqlite3PrepareV2(databaseConnection, statement)
            try sqlite3StepDone(preparedStatement)
            try sqlite3Finalize(preparedStatement)
        } catch {
            let error = Error("\(self) Cannot rollback transaction\n\(error)")
            throw error
        }
    }
    
    // MARK: - Tables
    
    private var _imageOnlyPostTable: ImageOnlyPostSQLiteTable?
    func imageOnlyPostTable() throws -> ImageOnlyPostSQLiteTable {
        if let imageOnlyPostTable = _imageOnlyPostTable {
            return imageOnlyPostTable
        } else {
            let imageOnlyPostTable = ImageOnlyPostSQLiteTable()
            _imageOnlyPostTable = imageOnlyPostTable
            return imageOnlyPostTable
        }
    }
    
    private var _videoOnlyPostTable: VideoOnlyPostSQLiteTable?
    func videoOnlyPostTable() throws -> VideoOnlyPostSQLiteTable {
        if let videoOnlyPostTable = _videoOnlyPostTable {
            return videoOnlyPostTable
        } else {
            let videoOnlyPostTable = VideoOnlyPostSQLiteTable()
            _videoOnlyPostTable = videoOnlyPostTable
            return videoOnlyPostTable
        }
    }
    
    private var _multiSourcePostTable: MultiSourcePostSQLiteTable?
    func multiSourcePostTable() throws -> MultiSourcePostSQLiteTable {
        if let multiSourcePostTable = _multiSourcePostTable {
            return multiSourcePostTable
        } else {
            let multiSourcePostTable = MultiSourcePostSQLiteTable()
            _multiSourcePostTable = multiSourcePostTable
            return multiSourcePostTable
        }
    }
    
    private var _multiSourcePostImageAttachmentTable: MultiSourcePostImageAttachmentSQLiteTable?
    func multiSourcePostImageAttachmentTable() throws -> MultiSourcePostImageAttachmentSQLiteTable {
        if let multiSourcePostImageAttachmentTable = _multiSourcePostImageAttachmentTable {
            return multiSourcePostImageAttachmentTable
        } else {
            let multiSourcePostImageAttachmentTable = MultiSourcePostImageAttachmentSQLiteTable()
            _multiSourcePostImageAttachmentTable = multiSourcePostImageAttachmentTable
            return multiSourcePostImageAttachmentTable
        }
    }
    
    private var _multiSourcePostVideoAttachmentTable: MultiSourcePostVideoAttachmentSQLiteTable?
    func multiSourcePostVideoAttachmentTable() throws -> MultiSourcePostVideoAttachmentSQLiteTable {
        if let multiSourcePostVideoAttachmentTable = _multiSourcePostVideoAttachmentTable {
            return multiSourcePostVideoAttachmentTable
        } else {
            let multiSourcePostVideoAttachmentTable = MultiSourcePostVideoAttachmentSQLiteTable()
            _multiSourcePostVideoAttachmentTable = multiSourcePostVideoAttachmentTable
            return multiSourcePostVideoAttachmentTable
        }
    }
    
    // MARK: - Queries
    
    private var _getPostsQuery: GetPostsSQLiteQuery?
    func getPostsQuery() throws -> GetPostsSQLiteQuery {
        if let getPostsQuery = _getPostsQuery {
            return getPostsQuery
        } else {
            let getPostsQuery = GetPostsSQLiteQuery()
            _getPostsQuery = getPostsQuery
            return getPostsQuery
        }
    }
}
