//
//  LoadLifeValuesUseCase.swift
//  Meaning
//
//  Created by Adrian Bilescu on 30.12.2023.
//

import Foundation

protocol LoadLifeValuesUseCase {
    func load() async throws -> [LifeValue]
}

extension UseCase: LoadLifeValuesUseCase where Input == Void, Output == [LifeValue] {
    func load() async throws -> [LifeValue] {
        try await execute()
    }
}

struct NoDataFoundException: Error {}
