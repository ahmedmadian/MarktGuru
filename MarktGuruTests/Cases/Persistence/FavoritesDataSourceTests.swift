//
//  FavoritesDataSourceTests.swift
//  MarktGuruTests
//
//  Created by Ahmed Madian on 28.04.25.
//

import XCTest
import CoreData
import Factory
@testable import MarktGuru

final class FavoritesDataSourceTests: XCTestCase {
    private var inMemoryContainer: NSPersistentContainer!
    private var sut: FavoritesDataSource!

    override func setUp() {
        let model = NSManagedObjectModel.favoriteProductModel()
        inMemoryContainer = NSPersistentContainer(name: "TestContainer", managedObjectModel: model)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        inMemoryContainer.persistentStoreDescriptions = [description]
        var loadError: Error?
        inMemoryContainer.loadPersistentStores { _, error in
            loadError = error
        }
        XCTAssertNil(loadError)

        let contextFactory = inMemoryContainer.viewContext
        Container.shared.viewContext.register { contextFactory }

        sut = FavoritesDataSource()
    }

    override func tearDown() {
        inMemoryContainer = nil

        super.tearDown()
    }

    func testFetchFavoriteIDs_WithData() async throws {
        // Given
        let context = inMemoryContainer.viewContext
        let fav1 = Favorite(context: context)
        fav1.id = 1
        let fav2 = Favorite(context: context)
        fav2.id = 2
        try context.save()

        // When
        let ids = sut.fetchFavoriteIDs()

        // Then
        XCTAssertEqual(ids, Set([1, 2]))
    }

    func testToggleFavorite_InsertsWhenNotExists() async throws {
        // Given
        sut.toggleFavorite(3)
        let ids = sut.fetchFavoriteIDs()

        // Then
        XCTAssertEqual(ids, Set([3]))
    }

    func testToggleFavorite_RemovesWhenExists() async throws {
        // Given
        let context = inMemoryContainer.viewContext
        let fav = Favorite(context: context)
        fav.id = 4
        try context.save()

        // When
        sut.toggleFavorite(4)
        let ids = sut.fetchFavoriteIDs()

        // Then
        XCTAssertTrue(ids.isEmpty)
    }
}
