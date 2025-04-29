//
//  ProductDetailViewModel.swift
//  MarktGuru
//
//  Created by Ahmed Madian on 28.04.25.
//

import Foundation
import Factory

// MARK: - ProductDetailViewModelType

protocol ProductDetailViewModelType {
    var product: ProductViewModel { get }
    func toggleFavorite()
}

// MARK: - ProductDetailViewModel

@Observable
class ProductDetailViewModel: ProductDetailViewModelType {
    private(set) var product: ProductViewModel

    // Dependencies
    @ObservationIgnored
    @Injected(\.productsRepo) private var repo

    // MARK: - init
    init(product: ProductViewModel) {
        self.product = product
    }

    // Actions
    func toggleFavorite() {
        repo.toggleFavorite(product.id)
        product.isFavorite.toggle()
    }
}
