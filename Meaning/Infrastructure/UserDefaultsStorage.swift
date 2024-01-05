//
//  UserDefaultsStorage.swift
//  YAPSaudi
//
//  Created by Adrian Bilescu on 13.01.2023.
//

import Foundation

struct UserDefaultsStorage: LocalStorage {
    let userDefaults: UserDefaults

    func setValue<T: Codable>(_ value: T, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(value)
            userDefaults.set(data, forKey: key)
            userDefaults.synchronize()
        } catch {
            print(error)
        }
    }
    
    func value<T: Codable>(forKey key: String) -> T? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
    
    func removeValue(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    func clearStorage() {
        let dictionary = userDefaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            userDefaults.removeObject(forKey: key)
        }
    }
}
