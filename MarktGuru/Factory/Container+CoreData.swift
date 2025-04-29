//
//  Container+CoreData.swift
//  MarktGuru
//
//  Created by Ahmed Madian on 28.04.25.
//

import Factory
import CoreData

extension Container {
    var persistentContainer: Factory<NSPersistentContainer> {
        self {
            let model = NSManagedObjectModel.favoriteProductModel()
            let container = NSPersistentContainer(name: "MarktGuru", managedObjectModel: model)

            let storeURL = FileManager
                .default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first!
                .appendingPathComponent("MarktGuru.sqlite")
            
            let desc = NSPersistentStoreDescription(url: storeURL)
            desc.type = NSSQLiteStoreType
            container.persistentStoreDescriptions = [desc]

            container.loadPersistentStores { storeDesc, error in
                if let error = error {
                    fatalError("Core Data load error: \(error)")
                }
            }
            return container
        }
        .singleton
    }

    var viewContext: Factory<NSManagedObjectContext> {
        self { self.persistentContainer().viewContext }
    }
}
