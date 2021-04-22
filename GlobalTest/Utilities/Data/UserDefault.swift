//
//  UserDefault.swift
//  GlobalTest
//
//  Created by Shayan Mehranpoor on 4/21/21.
//

import Foundation

enum UserDefaultsKeys: String {
    
    case counter = "counter"
    case responseCode = "responseCode"
}

@propertyWrapper
struct UserDefault<T> {
    let key: UserDefaultsKeys
    let defaultValue: T

    init(_ key: UserDefaultsKeys, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key.rawValue) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key.rawValue)
        }
    }
}

struct UserDefaultsConfig {
    @UserDefault(.counter, defaultValue: 0)
    static var counter: Int
    
    @UserDefault(.responseCode, defaultValue: "")
    static var responseCode: String
    
    static func clearUserDefaultfor(_ key: UserDefaultsKeys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func clearAllUserDefault() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
        UserDefaults.standard.synchronize()
    }
}
