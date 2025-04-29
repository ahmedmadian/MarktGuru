//
//  ProductsAPIClientPreview.swift
//  MarktGuru
//
//  Created by Ahmed Madian on 28.04.25.
//

import Foundation

final class ProductsAPIClientPreview {
    private enum Constants {
        static let productsResource = "products"
    }

    private func stubData<T: Decodable>(for resource: String) -> T {
        guard
            let url = Bundle.main.url(forResource: resource, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let stubData = try? JSONDecoder().decode(T.self, from: data)
        else {
            fatalError("Unable to Load Stub Data")
        }

        return stubData
    }
}

// MARK: - ProductsAPIClientType

extension ProductsAPIClientPreview: ProductsAPIClientType {
    func fetchProducts(offset: Int, limit: Int) async throws -> [Product] {
        stubData(for: Constants.productsResource)
    }
}
