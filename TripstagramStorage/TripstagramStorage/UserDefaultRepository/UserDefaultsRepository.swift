import Foundation

class UserDefaultsRepository {
    
    // MARK: - Init
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - UserDefaults
    
    private let userDefaults: UserDefaults
    
    // MARK: - Storage version
    
    private let storageVersionKey = "storageVersionKey"
    
    func setStorageVersion(_ version: String) {
        userDefaults.set(version, forKey: storageVersionKey)
    }
    
    func storageVersion() -> String? {
        return userDefaults.string(forKey: storageVersionKey)
    }
}
