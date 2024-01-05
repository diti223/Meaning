//
//  InMemoryStore.swift
//  Meaning
//
//  Created by Adrian Bilescu on 30.12.2023.
//

import Foundation

class InMemoryStore: LoadLifeValuesUseCase, SaveLifeValuesUseCase {
    var values: [LifeValue]
    
    init(initial: [LifeValue]) {
        self.values = initial
    }
    
    func load() async throws -> [LifeValue] {
        values
    }
    
    func save(values: [LifeValue]) async throws {
        self.values.append(contentsOf: values)
    }
}
