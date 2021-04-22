//
//  DataManager.swift
//  GlobalTest
//
//  Created by Shayan Mehranpoor on 4/21/21.
//

import Foundation

class DataManager {
    
    static var shared: DataManager = DataManager()
    
    private init () {
        self.responseCode    = UserDefaultsConfig.responseCode
        self.counter = UserDefaultsConfig.counter
    }
    
    var responseCode: String! {
        didSet {
            UserDefaultsConfig.responseCode = responseCode
        }
    }
    
    var counter: Int! {
        didSet {
            UserDefaultsConfig.counter = counter
        }
    }
    
    func purgeAllData() {
        UserDefaultsConfig.clearAllUserDefault()
        DataManager.shared = DataManager()
    }
}
