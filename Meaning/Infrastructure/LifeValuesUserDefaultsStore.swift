//
//  LifeValuesUserDefaultsStore.swift
//  Meaning
//
//  Created by Adrian Bilescu on 30.12.2023.
//

import Foundation

struct LifeValuesUserDefaultsStore: SaveLifeValuesUseCase, LoadLifeValuesUseCase {
    let localStorage: LocalStorage
    private let storageKey = String(describing: LifeValue.self)
    
    func save(values: [LifeValue]) async throws {
        localStorage.setValue(values, forKey: storageKey)
    }
    
    func load() async throws -> [LifeValue] {
        guard let values: [LifeValue] = localStorage.value(forKey: storageKey) else {
            throw NoDataFoundException()
        }
        return values
    }
    
    
}
