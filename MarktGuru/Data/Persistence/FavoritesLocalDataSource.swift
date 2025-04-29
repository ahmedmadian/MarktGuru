//
//  FavoritesLocalDataSource.swift
//  MarktGuru
//
//  Created by Ahmed Madian on 28.04.25.
//

import Foundation
import Factory
import CoreData

// MARK: - FavoritesLocalDataSourceType

protocol FavoritesLocalDataSourceType {
    func fetchFavoriteIDs() -> Set<Int>
    func toggleFavorite(_ id: Int)
}

// MARK: - FavoritesLocalDataSource

final class FavoritesLocalDataSource {
    @Injected(\.viewContext)private var context: NSManagedObjectContext

    private var fetchRequest: NSFetchRequest<Favorite> {
        NSFetchRequest<Favorite>(entityName: Favorite.entityName)
    }
}

// MARK: - FavoritesLocalDataSourceType

extension FavoritesLocalDataSource: FavoritesLocalDataSourceType {
    func fetchFavoriteIDs() -> Set<Int> {
        do {
            let favorites = try context.fetch(fetchRequest)
            return Set(favorites.map { Int($0.id) })
        } catch {
            print("⚠️ FavoritesLocalDataSource.fetchFavoriteIDs failed:", error)
            return []
        }
    }

    func toggleFavorite(_ id: Int) {
        let request = fetchRequest
        request.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let existing = try context.fetch(request)
            if let object = existing.first {
                context.delete(object)
            } else {
                let fav = Favorite(context: context)
                fav.id = id
            }
            try context.save()
        } catch {
            print("⚠️ FavoritesLocalDataSource.toggleFavorite failed:", error)
        }
    }
}
