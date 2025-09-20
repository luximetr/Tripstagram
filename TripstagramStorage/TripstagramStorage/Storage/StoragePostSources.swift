import Foundation
import UniformTypeIdentifiers

extension Storage {
    
    // MARK: - Directories
    
    func postAttachmentsDirectoryURL() throws -> URL {
        do {
            if let postAttachmentsDirectoryURL = _postAttachmentsDirectoryURL {
                return postAttachmentsDirectoryURL
            } else {
                let postAttachmentsDirectoryURL = try documentDirectoryURL().appendingPathComponent("PostAttachments", isDirectory: true)
                _postAttachmentsDirectoryURL = postAttachmentsDirectoryURL
                return postAttachmentsDirectoryURL
            }
        } catch {
            throw Error("Unable to construct attachments directory URL\n\(error)")
        }
    }
    
    func imageOnlyPostAttachmentsDirectoryURL() throws -> URL {
        do {
            if let imageOnlyPostAttachmentsDirectoryURL = _imageOnlyPostAttachmentsDirectoryURL {
                return imageOnlyPostAttachmentsDirectoryURL
            } else {
                let imageOnlyPostAttachmentsDirectoryURL = try postAttachmentsDirectoryURL().appendingPathComponent("ImageOnlyPosts", isDirectory: true)
                _imageOnlyPostAttachmentsDirectoryURL = imageOnlyPostAttachmentsDirectoryURL
                return imageOnlyPostAttachmentsDirectoryURL
            }
        } catch {
            throw Error("Unable to construct image-only attachments directory URL\n\(error)")
        }
    }
    
    // MARK: - Save
    
    func saveImageOnlyPostAttachment(postId: String, attachment: DownloadedFile) throws {
        let directory = try imageOnlyPostAttachmentsDirectoryURL()
        let postDirectoryURL = directory.appendingPathComponent(postId, isDirectory: true)
        try fileManager.createDirectory(at: postDirectoryURL, withIntermediateDirectories: true)
        let filename = attachment.suggestedFilename ?? "\(postId).\(getFileExtension(attachment: attachment))"
        let destinationURL = postDirectoryURL.appendingPathComponent(filename, isDirectory: false)
        try fileManager.moveItem(at: attachment.tempURL, to: destinationURL)
    }
    
    // MARK: - Get
    
    func getPostOrderedSourceURLs(byPostId postId: String, inDirectory directory: URL) throws -> [URL] {
        var sourceURLs: [URL] = []
        let postDirectoryURL = directory.appendingPathComponent(postId, isDirectory: true)
        if !fileManager.fileExists(atPath: postDirectoryURL.path) {
            return []
        }
        let postDirectoryDirectories: [URL] = try fileManager.contentsOfDirectory(at: postDirectoryURL, includingPropertiesForKeys: nil, options: [])
        let postDirectoryDirectoriesCount = postDirectoryDirectories.count
        for postSourceOrderNumber in 0..<postDirectoryDirectoriesCount {
            let postSourceURL = postDirectoryDirectories[postSourceOrderNumber]
            sourceURLs.append(postSourceURL)
        }
        return sourceURLs
    }
    
    func getPostSourceURL(byPostId postId: String, inDirectory directory: URL) throws -> URL? {
        return nil
    }
    
    // MARK: - File extension
    
    private func getFileExtension(attachment: DownloadedFile) -> String {
        if let mimeType = attachment.mimeType {
            if let utType = UTType(mimeType: mimeType), let fileExtension = utType.preferredFilenameExtension {
                return fileExtension
            } else {
                let fileExtension = mimeType.split(separator: "/")[1]
                return String(fileExtension)
            }
        } else {
            return attachment.tempURL.lastPathComponent
        }
    }
}
