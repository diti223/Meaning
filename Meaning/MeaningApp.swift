//
//  MeaningApp.swift
//  Meaning
//
//  Created by Adrian Bilescu on 30.12.2023.
//

import SwiftUI

@main
struct MeaningApp: App {
    let localStorage = UserDefaultsStorage(userDefaults: .standard)
    var store: LifeValuesUserDefaultsStore {
        LifeValuesUserDefaultsStore(localStorage: localStorage)
    }
    let collectionsStorageKey = "CollectionsStorageKey"
    var body: some Scene {
        WindowGroup {
            ContentView(
                fetchCollectionsUseCase: UseCaseFetcher {
                    if let collections: [LifeValueCollection] = localStorage.value(forKey: collectionsStorageKey) {
                        return collections
                    }
                    let values = try await store.load()
                    return [LifeValueCollection(id: UUID(), name: "Default", values: values)]
                },
                storeCollectionsUseCase: UseCaseSender { collection in
                    var collections: Set<LifeValueCollection> = Set(localStorage.value(forKey: collectionsStorageKey) ?? [])
                    collections.insert(collection)
                    localStorage.setValue(collections, forKey: collectionsStorageKey)
                },
                removeCollectionUseCase: UseCaseSender { id in
                    let collections: Set<LifeValueCollection> = Set(localStorage.value(forKey: collectionsStorageKey) ?? [])
                        .filter { $0.id != id }
                    localStorage.setValue(collections, forKey: collectionsStorageKey)
                },
                loadUseCase: UseCaseFetcher {
                    do {
                        return try await store.load()
                    } catch {
                        return LifeValue.higherValues
                    }
                },
                storeUseCase: store
            )
        }
        
    }
}
