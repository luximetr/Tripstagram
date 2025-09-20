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
    
    
}
