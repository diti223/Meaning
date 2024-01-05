//
//  LifeValueCollectionsView.swift
//  Meaning
//
//  Created by Adrian Bilescu on 01.01.2024.
//

import Foundation
import SwiftUI

struct LifeValueCollection: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    let name: String
    var values: [LifeValue]
}

struct LifeValueCollectionsView: View {
    
    @Binding var collections: [LifeValueCollection]
    @Binding var selectedCollection: LifeValueCollection?
    @FocusState var focusedID: LifeValueCollection.ID?
    
    var onDelete: (LifeValueCollection.ID) -> Void
    
    var body: some View {
        List {
            ForEach(collections) { collection in                
//                Button(action: {
//                    selectedCollection = collection
//                }, label: {
//                    Text(collection.name)
//                })
                
                Text(collection.name)
                    .containerShape(Rectangle())
                    .focused($focusedID, equals: collection.id)
                    .onTapGesture {
                        focusedID = collection.id
                        selectedCollection = collection
                    }
                    .contextMenu {
                        Button(
                            action: { onDelete(collection.id) },
                            label: { Label("Delete", systemImage: "trash.fill") }
                        )
                    }
//                    .toolbar {
//                        ToolbarItem {
//                            Menu("menus with long press") {
//                                Button("first") { }
//                                Button("second") { }
//                                Button("last") { }
//                            } primaryAction: {
//                                // execute primary action
//                            }
//                        }
//                    }
            }
        }
        .onDeleteCommand(perform: {
            deleteSelectedCollection()
        })
    }
    
    private func deleteSelectedCollection() {
        if let selectedCollection {
            onDelete(selectedCollection.id)
        }
    }
}
