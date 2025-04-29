//
//  MockFavoritesDataSource.swift
//  MarktGuruTests
//
//  Created by Ahmed Madian on 28.04.25.
//

import Factory
@testable import MarktGuru

final class MockFavoritesDataSource: FavoritesDataSourceType {
    private(set) var fetchCount = 0
    private(set) var toggledIDs: [Int] = []
    var favorites: Set<Int> = []

    func fetchFavoriteIDs() -> Set<Int> {
        fetchCount += 1
        return favorites
    }

    func toggleFavorite(_ id: Int) {
        toggledIDs.append(id)
        if favorites.contains(id) { favorites.remove(id) }
        else { favorites.insert(id) }
    }
}

// MARK: - Factory Registration

extension MockFavoritesDataSource {
    class func register() -> MockFavoritesDataSource {
        let mock = MockFavoritesDataSource()
        Container.shared.favoritesDataSource.register { mock }
        return mock
    }
}
