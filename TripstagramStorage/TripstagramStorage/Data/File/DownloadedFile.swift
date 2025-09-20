import Foundation

public struct DownloadedFile {
    public let tempURL: URL
    public let mimeType: String?
    public let suggestedFilename: String?
    
    public init(tempURL: URL, mimeType: String?, suggestedFilename: String?) {
        self.tempURL = tempURL
        self.mimeType = mimeType
        self.suggestedFilename = suggestedFilename
    }
}
