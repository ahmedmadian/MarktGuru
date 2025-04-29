//
//  MockProductsAPIClient.swift
//  MarktGuruTests
//
//  Created by Ahmed Madian on 28.04.25.
//

import Factory
@testable import MarktGuru

@MainActor
final class MockProductsAPIClient: ProductsAPIClientType {
    var lastOffset: Int?
    var lastLimit: Int?
    var resultToReturn: [Product] = []
    var errorToThrow: Error?

    func fetchProducts(offset: Int, limit: Int) async throws -> [Product] {
        lastOffset = offset
        lastLimit = limit
        if let e = errorToThrow { throw e }
        return resultToReturn
    }
}

// MARK: - Factory Registration

extension MockProductsAPIClient {
    class func register() -> MockProductsAPIClient {
        let mock = MockProductsAPIClient()
        Container.shared.productsAPIClient.register { mock }
        return mock
    }
}
