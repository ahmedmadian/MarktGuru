//
//  ProductsViewModel.swift
//  MarktGuru
//
//  Created by Ahmed Madian on 28.04.25.
//

import Foundation
import Factory

// MARK: - ProductsViewModelType

protocol ProductsViewModelType {
    var state: ProductsViewModel.State { get }
    var isLoadingMore: Bool { get }
    func toggleFavorite(_ productId: Int)
    func loadMoreIfNeeded(currentProductId: Int) async
    func retry() async
}

// MARK: - ProductsViewModel

@Observable
class ProductsViewModel: ProductsViewModelType {
    // MARK: - State

    enum State: Equatable {
        case fetching
        case data(products: [ProductViewModel])
        case error(message: String)
    }

    // Pagination
    private var offset = 0
    private let limit = 10
    private var canLoadMore = true

    // Data
    private var products: [ProductViewModel] = []
    private var favoriteIDs = Set<Int>()

    // Dependencies
    @ObservationIgnored
    @Injected(\.productsRepo) private var repo

    // Observable state
    var state: State = .fetching
    var isLoadingMore: Bool = false

    // MARK: - init

    init() {
        Task { await initialLoading() }
    }

    private func initialLoading() async {
        favoriteIDs = repo.fetchFavoriteIDs()
        await loadProducts()
    }

    private func loadProducts() async {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        defer { isLoadingMore = false }

        do {
            let newProducts = try await repo.fetchProducts(offset: offset, limit: limit)
            if newProducts.count < limit {
                canLoadMore = false
            }

            products += newProducts.map {
                ProductViewModel(product: $0,
                                 isFavorite: favoriteIDs.contains($0.id)
                )}
            offset += limit
            state = .data(products: products)
        } catch {
            state = .error(message: error.localizedDescription)
        }
    }

    private func reset() {
        offset = 0
        canLoadMore = true
        products = []
        favoriteIDs = []
    }

    // MARK: - Public API

    func toggleFavorite(_ productId: Int) {
        repo.toggleFavorite(productId)
        favoriteIDs = repo.fetchFavoriteIDs()

        if let idx = products.firstIndex(where: { $0.id == productId }) {
            products[idx].isFavorite = favoriteIDs.contains(productId)
        }

        state = .data(products: products)
    }

    func loadMoreIfNeeded(currentProductId: Int) async {
        guard
            let last = products.last,
            currentProductId == last.id,
            canLoadMore else { return }

        Task { await loadProducts() }
    }

    func retry() async {
        reset()
        state = .fetching
        await initialLoading()
    }
}

