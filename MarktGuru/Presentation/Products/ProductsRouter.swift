//
//  ProductsRouter.swift
//  MarktGuru
//
//  Created by Ahmed Madian on 28.04.25.
//

import SwiftUI

@Observable
class ProductsRouter {
    // MARK: - Destinations

    enum Destination: Hashable {
        case detail(ProductViewModel)
    }

    var path: [Destination] = []

    func navigateToDetail(_ item: ProductViewModel) {
        path.append(.detail(item))
    }
}
