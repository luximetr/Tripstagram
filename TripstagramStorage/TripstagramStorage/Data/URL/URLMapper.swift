import Foundation

class URLMapper {
    
    static func toString(url: URL) -> String {
        return url.absoluteString
    }
    
    static func toURL(string: String) throws -> URL {
        guard let url = URL(string: string) else { throw Error("Unable to convert string to URL") }
        return url
    }
}
