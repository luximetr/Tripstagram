import Foundation

public class Network {
    
    private let urlSession: URLSession
    
    // MARK: - Initialization
    
    public init() {
        urlSession = URLSession.shared
    }
    
}
