import Foundation

extension Storage {
enum Version: Int {
    case v1_0_0
    
    static var latest: Version {
        return .v1_0_0
    }
    
    init(rawValue: String) throws {
        switch rawValue {
        case "1.0.0": self = .v1_0_0
        default: throw Error("Unable to init Storage.Version with rawValue \(rawValue)")
        }
    }
    
    var stringValue: String {
        switch self {
        case .v1_0_0: return "1.0.0"
        }
    }
}
}
