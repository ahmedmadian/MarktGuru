//
//  ProductsRepo.swift
//  MarktGuru
//
//  Created by Ahmed Madian on 28.04.25.
//

import Factory
import CoreData

// MARK: - ProductsRepo

protocol ProductsRepoType {
    func fetchProducts(offset: Int, limit: Int) async throws -> [Product]
    func fetchFavoriteIDs() -> Set<Int>
    func toggleFavorite(_ id: Int)
}

// MARK: - ProductsRepo

final class ProductsRepo {
    @Injected(\.productsAPIClient) private var apiClient
    @Injected(\.favoritesDataSource) private var favoritesDataSource
}

// MARK: - ProductsRepoType

extension ProductsRepo: ProductsRepoType {
    func fetchProducts(offset: Int, limit: Int) async throws -> [Product] {
        try await apiClient.fetchProducts(offset: offset, limit: limit)
    }

    func fetchFavoriteIDs() -> Set<Int> {
        favoritesDataSource.fetchFavoriteIDs()
    }
    
    func toggleFavorite(_ id: Int) {
        favoritesDataSource.toggleFavorite(id)
    }
}
