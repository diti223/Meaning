//
//  SaveLifeValuesUseCase.swift
//  Meaning
//
//  Created by Adrian Bilescu on 30.12.2023.
//

import Foundation

protocol SaveLifeValuesUseCase {
    func save(values: [LifeValue]) async throws
}

extension UseCase: SaveLifeValuesUseCase where Input == [LifeValue], Output == Void {
    func save(values: [LifeValue]) async throws {
        try await execute(values)
    }
}
