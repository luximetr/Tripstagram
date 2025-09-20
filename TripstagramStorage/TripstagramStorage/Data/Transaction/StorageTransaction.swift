import Foundation

public struct StorageTransaction {
    let databaseConnection: OpaquePointer
    
    init(databaseConnection: OpaquePointer) {
        self.databaseConnection = databaseConnection
    }
}
