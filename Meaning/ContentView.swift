//
//  ContentView.swift
//  Meaning
//
//  Created by Adrian Bilescu on 30.12.2023.
//

import SwiftUI

struct ContentView: View {
    var fetchCollectionsUseCase: UseCaseFetcher<[LifeValueCollection]>
    var storeCollectionsUseCase: UseCaseSender<LifeValueCollection>
    var removeCollectionUseCase: UseCaseSender<LifeValueCollection.ID>
    
    var loadUseCase: LoadLifeValuesUseCase
    var storeUseCase: SaveLifeValuesUseCase
    @State private var selectedCollection: LifeValueCollection?
    @State private var collections: [LifeValueCollection] = []
    var values: [LifeValue]? {
        selectedCollection?.values
    }
    @State private var showSaveOption = false
    @State private var collectionName: String = ""
    
    @State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn
    var body: some View {
        
        NavigationSplitView(columnVisibility: $columnVisibility, sidebar: {
            LifeValueCollectionsView(
                collections: $collections,
                selectedCollection: $selectedCollection,
                onDelete: { id in
                    Task {
                        do {
                            try await removeCollectionUseCase.execute(id)
                            await loadCollections()
                        } catch {
                            // handle error
                        }
                    }
                }
            )
        }, detail: {
            Group {
                if let values {
                    ValuesList(
                        values: .init(get: { values }, set: { selectedCollection?.values = $0 }),
                        onSave: {
                            Task {
                                do {
                                    try await storeUseCase.save(values: values)
                                } catch {
                                    //TODO: handle error
                                }
                            }
                        }
                    ).padding()
                    
                    HStack {
                        Button(action: {
                            showSaveOption = true
                        }, label: {
                            Text("Save List")
                        })
                     
                        Button(action: {
                            selectedCollection?.values.shuffle()
                            Task {
                                storeCollectionsUseCase
                            }
                        }, label: {
                            Text("Shuffle Values")
                        })
                    }
                    .padding(.bottom)
                    .sheet(isPresented: $showSaveOption) {
                        VStack {
                            Text("Enter list name: ")
                            TextField("", text: $collectionName)
                            Spacer()
                            Button(action: {
                                Task {
                                    do {
                                        if let selectedCollection, collectionName == selectedCollection.name {
                                            try await self.storeCollectionsUseCase.execute(selectedCollection)
                                        } else {
                                            try await self.storeCollectionsUseCase.execute(LifeValueCollection(id: UUID(), name: collectionName, values: values))
                                        }
                                        await loadCollections()
                                        showSaveOption = false
                                    } catch {
                                        //TODO: handle error
                                    }
                                }
                                
                            }, label: {
                                Text("Save List")
                            })
                        }.padding()
                    }
                    
                } else {
                    ContentUnavailableView("Waiting for values", systemImage: "sun.haze")
                }
            }
            .navigationTitle(title)
            
        })
        .task {
            await loadCollections()
        }
        .onChange(of: selectedCollection) { oldValue, newValue in
            collectionName = newValue?.name ?? ""
        }
        
        
        var title: String {
            if let selectedCollection {
                return "Higher Values - \(selectedCollection.name)"
            }
            
            return "Higher Values"
        }
//        .padding()
//        .task {
//            do {
//                let values = try await loadUseCase.load()
//                self.values = values
//            } catch {
//                //TODO: handle error
//            }
//        }
    }
    
    private func loadCollections() async {
        do {
            self.collections = try await fetchCollectionsUseCase.execute()
        } catch {
            //TODO: handle error
        }
    }
}

struct ValuesList: View {
    @Binding var values: [LifeValue]
    
    @State private var hasChanges: Bool = false
    @State private var selection = Set<Int>()
    var onSave: () -> Void
    
    var body: some View {
        VStack {
            List(selection: $selection) {
                ForEach(Array(values.enumerated()), id: \.element.title) { (index, value) in
                    VStack(alignment: .leading, spacing: 0) {
                        Text("\(index + 1). \(value.icon) \(value.title)")
                        Text(value.description)
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                    }
                    .tag(index)
                }
                .onMove(perform: { indices, newOffset in
                    move(from: indices, to: newOffset)
                    selection.removeAll()
                    onSave()
                })
            }
        }
    }
    
    private var saveButton: some View {
        Button(action: {
            hasChanges = false
            onSave()
        }, label: {
            Text("Save")
        })
    }
    
    
    private func move(from source: IndexSet, to destination: Int) {
        values.move(fromOffsets: source, toOffset: destination)
        hasChanges = true
    }
}

#Preview {
    let store = InMemoryStore(initial: [
        LifeValue(title: "Value 1", description: "This is the first value", icon: "🎃"),
        LifeValue(title: "Value 2", description: "This is the second value", icon: "🤖")
    ])
    return ContentView(
        fetchCollectionsUseCase: UseCaseFetcher {
            [LifeValueCollection(id: UUID(), name: "First Collection", values: [])]
        },
        storeCollectionsUseCase: UseCaseSender { _ in }, 
        removeCollectionUseCase: UseCaseSender { _ in },
        loadUseCase: store,
        storeUseCase: store
    )
}

