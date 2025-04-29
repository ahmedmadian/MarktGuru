//
//  MockProductsRepo.swift
//  MarktGuruTests
//
//  Created by Ahmed Madian on 28.04.25.
//

import Factory
@testable import MarktGuru

final class MockProductsRepo: ProductsRepoType {
    var favoriteIDs: Set<Int> = []
    var productsPages: [[Product]] = []
    var errorToThrow: Error?
    private(set) var toggledIDs: [Int] = []

    func fetchFavoriteIDs() -> Set<Int> {
        return favoriteIDs
    }

    func toggleFavorite(_ id: Int) {
        if favoriteIDs.contains(id) {
            favoriteIDs.remove(id)
        } else {
            favoriteIDs.insert(id)
        }
        toggledIDs.append(id)
    }

    func fetchProducts(offset: Int, limit: Int) async throws -> [Product] {
        if let error = errorToThrow {
            errorToThrow = nil
            throw error
        }

        let page = offset / limit
        guard page < productsPages.count else { return [] }
        return productsPages[page]
    }
}

// MARK: - Factory Registration

extension MockProductsRepo {
    class func register() -> MockProductsRepo {
        let mock = MockProductsRepo()
        Container.shared.productsRepo.register { mock }
        return mock
    }
}
