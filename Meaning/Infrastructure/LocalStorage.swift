//
//  File.swift
//  
//
//  Created by Adrian Bilescu on 13.01.2023.
//

import Foundation

public protocol LocalStorage {
    func setValue<T: Codable>(_ value: T, forKey key: String)
    func value<T: Codable>(forKey key: String) -> T?
    func removeValue(forKey key: String)
    func clearStorage()
}

