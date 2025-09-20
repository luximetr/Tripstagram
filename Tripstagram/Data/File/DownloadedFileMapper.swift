import Foundation
import TripstagramStorage
import TripstagramNetwork

class DownloadedFileMapper {
    
    static func mapToStorage(networkDownloadedFile: NetworkDownloadedFile) -> StorageDownloadedFile {
        let storageFile = StorageDownloadedFile(
            tempURL: networkDownloadedFile.tempURL,
            mimeType: networkDownloadedFile.mimeType,
            suggestedFilename: networkDownloadedFile.suggestedFilename
        )
        return storageFile
    }
}

typealias StorageDownloadedFile = TripstagramStorage.DownloadedFile
typealias NetworkDownloadedFile = TripstagramNetwork.DownloadedFile
