//
//  ProductsAPIClient.swift
//  MarktGuru
//
//  Created by Ahmed Madian on 28.04.25.
//

import Foundation

// MARK: - ProductsAPIClientType

protocol ProductsAPIClientType: Sendable {
    func fetchProducts(offset: Int, limit: Int) async throws -> [Product]
}

// MARK: - ProductsAPIClient

final class ProductsAPIClient: ProductsAPIClientType, APIClientType {
    typealias Endpoint = ProductsAPIEndpoint

    func fetchProducts(offset: Int, limit: Int) async throws -> [Product] {
        let endpoint = ProductsAPIEndpoint.products(offset: offset, limit: limit)
        let products: [Product] = try await request(endpoint)
        return products
    }
}
