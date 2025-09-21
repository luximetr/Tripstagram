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
    
    func videoOnlyPostAttamchntsDirectoryURL() throws -> URL {
        do {
            if let videoOnlyPostAttachmentsDirectoryURL = _videoOnlyPostAttachmentsDirectoryURL {
                return videoOnlyPostAttachmentsDirectoryURL
            } else {
                let videoOnlyPostAttachmentsDirectoryURL = try postAttachmentsDirectoryURL().appendingPathComponent("VideoOnlyPosts", isDirectory: true)
                _videoOnlyPostAttachmentsDirectoryURL = videoOnlyPostAttachmentsDirectoryURL
                return videoOnlyPostAttachmentsDirectoryURL
            }
        } catch {
            throw Error("Unable to construct video-only attachments directory URL\n\(error)")
        }
    }
    
    func multiSourcePostAttachmentsDirectoryURL() throws -> URL {
        do {
            if let multiSourcePostAttachmentsDirectoryURL = _multiSourcePostAttachmentsDirectoryURL {
                return multiSourcePostAttachmentsDirectoryURL
            } else {
                let multiSourcePostAttachmentsDirectoryURL = try postAttachmentsDirectoryURL().appendingPathComponent("MultiSourcePosts", isDirectory: true)
                _multiSourcePostAttachmentsDirectoryURL = multiSourcePostAttachmentsDirectoryURL
                return multiSourcePostAttachmentsDirectoryURL
            }
        } catch {
            throw Error("Unable to construct multi-source attachments directory URL\n\(error)")
        }
    }
    
    // MARK: - Save
    
    public func saveImageOnlyPostAttachment(postId: String, attachment: DownloadedFile) throws -> URL {
        let directory = try imageOnlyPostAttachmentsDirectoryURL()
        return try savePostAttachment(postId: postId, attachment: attachment, directory: directory)
    }
    
    public func saveVideoOnlyPostAttachment(postId: String, attachment: DownloadedFile) throws -> URL {
        let directory = try videoOnlyPostAttamchntsDirectoryURL()
        return try savePostAttachment(postId: postId, attachment: attachment, directory: directory)
    }
    
    public func saveMultiSourcePostAttachments(postId: String, attachments: [DownloadedFile]) throws {
        let directory = try multiSourcePostAttachmentsDirectoryURL()
        return try saveOrderedPostAttachments(postId: postId, attachments: attachments, directory: directory)
    }
    
    private func savePostAttachment(postId: String, attachment: DownloadedFile, directory: URL) throws -> URL {
        let postDirectoryURL = directory.appendingPathComponent(postId, isDirectory: true)
        try fileManager.createDirectory(at: postDirectoryURL, withIntermediateDirectories: true)
        let filename = attachment.suggestedFilename ?? "\(postId).\(getFileExtension(attachment: attachment))"
        let destinationURL = postDirectoryURL.appendingPathComponent(filename, isDirectory: false)
        try fileManager.moveItem(at: attachment.tempURL, to: destinationURL)
        return destinationURL
    }
    
    private func saveOrderedPostAttachments(postId: String, attachments: [DownloadedFile], directory: URL) throws {
        let postDirectoryURL = directory.appendingPathComponent(postId, isDirectory: true)
        try fileManager.createDirectory(at: postDirectoryURL, withIntermediateDirectories: true)
        for (index, attachment) in attachments.enumerated() {
            let filename = attachment.suggestedFilename ?? "\(postId).\(getFileExtension(attachment: attachment))"
            let orderNumberDirectory = postDirectoryURL.appendingPathComponent("\(index)", isDirectory: true)
            try fileManager.createDirectory(at: orderNumberDirectory, withIntermediateDirectories: true)
            let destinationURL = orderNumberDirectory.appendingPathComponent(filename, isDirectory: false)
            try fileManager.moveItem(at: attachment.tempURL, to: destinationURL)
        }
    }
    
    // MARK: - Get
    
    public func getCachedImageOnlyAttachmentURL(postId: String) throws -> URL? {
        let directory = try imageOnlyPostAttachmentsDirectoryURL()
        let attachmentURL = try getPostSourceURL(byPostId: postId, inDirectory: directory)
        return attachmentURL
    }
    
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
        let postDirectoryURL = directory.appending(path: postId)
        guard fileManager.fileExists(atPath: postDirectoryURL.path) else { return nil }
        let fileURLs = try fileManager.contentsOfDirectory(at: postDirectoryURL, includingPropertiesForKeys: nil, options: [])
        guard let firstFileURL = fileURLs.first else { return nil }
        guard fileManager.fileExists(atPath: firstFileURL.path) else { return nil }
        return firstFileURL
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
