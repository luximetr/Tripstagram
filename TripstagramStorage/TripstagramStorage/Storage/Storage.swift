import Foundation
import CoreData

public class Storage {
    
    // MARK: - Init
    
    public init() {
        self.sqlDatabaseFilename = "TripstagramDatabase"
        self.fileManager = FileManager.default
        self.userDefaultsRepository = UserDefaultsRepository(userDefaults: UserDefaults.standard)
    }
    
    public func initialize() throws {
        let storageVersionRaw = userDefaultsRepository.storageVersion()
        if storageVersionRaw == nil {
            try sqliteDatabase().create()
            let migratedToVersion: StorageVersion = .latest
            userDefaultsRepository.setStorageVersion(migratedToVersion.stringValue)
        }
    }
    
    // MARK: - UserDefaults
    
    let userDefaultsRepository: UserDefaultsRepository
    
    // MARK: - FileManager
    
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
    
    var _postAttachmentsDirectoryURL: URL?
    var _imageOnlyPostAttachmentsDirectoryURL: URL?
    var _videoOnlyPostAttachmentsDirectoryURL: URL?
    var _multiSourcePostAttachmentsDirectoryURL: URL?
    
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
    
    // MARK: - Queues
    
    private lazy var mainQueue = DispatchQueue.main
    private lazy var backgroundReadQueue = DispatchQueue(label: "com.storage.tripstagram.background.read.queue", qos: .userInitiated, attributes: .concurrent)
    private lazy var backgroundWriteQueue = DispatchQueue(label: "com.storage.tripstagram.background.write.queue", qos: .userInitiated)
    
    func performMainThreadReadTask<T>(_ action: (OpaquePointer) throws -> T) throws -> T {
        if Thread.isMainThread {
            let databaseConnection = try sqliteDatabase().mainQueueReadConnection()
            return try action(databaseConnection)
        } else {
            return try mainQueue.sync {
                let databaseConnection = try sqliteDatabase().mainQueueReadConnection()
                return try action(databaseConnection)
            }
        }
    }
    
    func performBackgroundReadTask<T>(_ action: @escaping (OpaquePointer) throws -> T) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            backgroundReadQueue.async { [weak self] in
                guard let self = self else {
                    continuation.resume(throwing: Error("Cannot unwrap weak self"))
                    return
                }
                do {
                    let databaseConnection = try self.sqliteDatabase().backgroundQueueReadConnection()
                    let result = try action(databaseConnection)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func performBackgroundWriteTask<T>(_ action: @escaping (OpaquePointer) throws -> T) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            backgroundWriteQueue.async { [weak self] in
                guard let self = self else {
                    continuation.resume(throwing: Error("Cannot unwrap weak self"))
                    return
                }
                do {
                    let databaseConnection = try self.sqliteDatabase().backgroundQueueWriteConnection()
                    let result = try action(databaseConnection)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // MARK: - Transaction
    
    public func performInBackgroundWriteTransaction<T>(_ actions: @escaping (StorageTransaction) throws -> T) async throws -> T {
        return try await performBackgroundWriteTask { [weak self] databaseConnection in
            guard let self = self else { throw Error("Cannot unwrap weak self") }
            let storageTransaction = StorageTransaction(databaseConnection: databaseConnection)
            do {
                try self.sqliteDatabase().beginTransaction(databaseConnection: databaseConnection)
                let result = try actions(storageTransaction)
                try self.sqliteDatabase().commitTransaction(databaseConnection: databaseConnection)
                return result
            } catch let transactionError {
                do {
                    try self.sqliteDatabase().rollbackTransaction(databaseConnection: databaseConnection)
                    let error = Error("Unable to commit transaction\n\(transactionError)")
                    throw error
                } catch let rollbackError {
                    let error = Error("Unable to rollback transaction\n\(transactionError)\n\(rollbackError)")
                    throw error
                }
            }
        }
    }
}
