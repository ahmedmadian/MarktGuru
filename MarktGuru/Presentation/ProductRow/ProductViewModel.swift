//
//  ProductViewModel.swift
//  MarktGuru
//
//  Created by Ahmed Madian on 28.04.25.
//

import Foundation

@Observable
class ProductViewModel: Identifiable, Hashable {
    var id: Int
    var imagesURLs: [URL]
    var thumbnailURL: URL?
    var title: String
    var price: Double
    var currency: String
    var description: String
    var isFavorite: Bool
    var category: String

    init(product: Product, isFavorite: Bool) {
        id = product.id
        imagesURLs = product.images.compactMap(URL.init(string:))
        thumbnailURL = URL(string: product.images.first ?? "")
        title = product.title
        price = product.price
        currency = Locale.current.currency?.identifier ?? "EUR"
        description = product.description
        self.isFavorite = isFavorite
        category = product.category.name
    }

    static func == (lhs: ProductViewModel, rhs: ProductViewModel) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
