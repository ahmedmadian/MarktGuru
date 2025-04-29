//
//  ProductsViewModelTests.swift
//  MarktGuruTests
//
//  Created by Ahmed Madian on 29.04.25.
//

import XCTest
@testable import MarktGuru

final class ProductsViewModelTests: XCTestCase {
    private var mockRepo: MockProductsRepo!
    private var sut: ProductsViewModel!

    override func setUp() {
        super.setUp()

        mockRepo = MockProductsRepo.register()
    }

    override func tearDown() {
        sut = nil
        mockRepo = nil

        super.tearDown()
    }

    func testInitialLoadSuccess() async {
        // Given
        let products = [Product(id: 1,
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
                                 category: Category(name: "Clothes"))]
        mockRepo.favoriteIDs = [1]
        mockRepo.productsPages = [products]

        // When
        sut = ProductsViewModel()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        XCTAssertEqual(sut.state, .data(products: [
            ProductViewModel(product: products[0], isFavorite: true),
            ProductViewModel(product: products[1], isFavorite: false)
        ]))

        XCTAssertFalse(sut.isLoadingMore)
    }

    func testLoadMoreIfNeeded() async {
        // Given
        let products = [Product(id: 1,
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
                                 category: Category(name: "Clothes"))]
        mockRepo.productsPages = [products]

        sut = ProductsViewModel()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // When
        await sut.loadMoreIfNeeded(currentProductId: 1)
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        XCTAssertEqual(sut.state, .data(products: [
            ProductViewModel(product: products[0], isFavorite: false),
            ProductViewModel(product: products[1], isFavorite: false)
        ]))
    }

    func testToggleFavorite() async {
        // Given
        let products = [Product(id: 1,
                                 title: "A",
                                 price: 10,
                                 description: "Test",
                                 images: [""],
                                 category: Category(name: "Clothes"))]
        mockRepo.favoriteIDs = []
        mockRepo.productsPages = [products]

        sut = ProductsViewModel()
        try? await Task.sleep(nanoseconds: 100_000_000)

        // When
        sut.toggleFavorite(1)

        //Then
        XCTAssertEqual(mockRepo.toggledIDs, [1])
        XCTAssertEqual(sut.state, .data(products: [
            ProductViewModel(product: products[0], isFavorite: true)
        ]))
    }

    func testRetryAfterError() async {
        // Given
        let products = [Product(id: 1,
                                 title: "A",
                                 price: 10,
                                 description: "Test",
                                 images: [""],
                                 category: Category(name: "Clothes"))]

        mockRepo.errorToThrow = APIClientError.serviceError
        mockRepo.productsPages = [products]

        // When
        sut = ProductsViewModel()
        try? await Task.sleep(nanoseconds: 100_000_000)

        //Then
        await sut.retry()
        try? await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertEqual(sut.state, .data(products: [
            ProductViewModel(product: products[0], isFavorite: false)
        ]))
    }
}
