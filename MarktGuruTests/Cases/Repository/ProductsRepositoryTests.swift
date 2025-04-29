//
//  ProductsRepositoryTests.swift
//  MarktGuruTests
//
//  Created by Ahmed Madian on 28.04.25.
//

import XCTest
import Factory
@testable import MarktGuru

@MainActor
final class ProductsRepoTests: XCTestCase {
    private var apiClient: MockProductsAPIClient!
    private var favoritesDataSource: MockFavoritesDataSource!
    private var sut: ProductsRepoType!

    override func setUp() {
        super.setUp()

        apiClient = MockProductsAPIClient.register()
        favoritesDataSource = MockFavoritesDataSource.register()
        sut = ProductsRepo()
    }

    override func tearDown() {
        sut = nil
        favoritesDataSource = nil
        apiClient = nil

        super.tearDown()
    }

    func testFetchProducts_Success() async throws {
        // given
        let expected = [
            Product(id: 1,
                    title: "A",
                    price: 10,
                    description: "Test",
                    images: [""],
                    category: Category(name: "Clothes")),
            Product(id: 2,
                    title: "A",
                    price: 10,
                    description: "Test",
                    images: [""],
                    category: Category(name: "Clothes"))
        ]

        apiClient.resultToReturn = expected

        // when
        let result = try await sut.fetchProducts(offset: 10, limit: 5)

        // then
        XCTAssertEqual(apiClient.lastOffset, 10)
        XCTAssertEqual(apiClient.lastLimit, 5)
        XCTAssertEqual(result, expected)
    }

    func testFetchProducts_Failure() async {
        // given
        apiClient.errorToThrow = APIClientError.serviceError

        do {
            _ = try await sut.fetchProducts(offset: 0, limit: 1)
            XCTFail("Should throw an error")
        } catch {
            // success
        }
    }

    func testFetchFavoriteIDs() {
        // given
        favoritesDataSource.favorites = [111, 222]

        // when
        let ids = sut.fetchFavoriteIDs()

        // then
        XCTAssertEqual(favoritesDataSource.fetchCount, 1)
        XCTAssertEqual(ids, [111, 222])
    }
    
    func testToggleFavorite() {
        // given
        favoritesDataSource.favorites = [1]

        // when
        sut.toggleFavorite(1)
        sut.toggleFavorite(2)
        
        // then
        XCTAssertEqual(favoritesDataSource.toggledIDs, [1, 2], "should forward each toggle call")
        XCTAssertFalse(favoritesDataSource.favorites.contains(1), "existing should be removed")
        XCTAssertTrue(favoritesDataSource.favorites.contains(2), "new should be added")
    }
}
