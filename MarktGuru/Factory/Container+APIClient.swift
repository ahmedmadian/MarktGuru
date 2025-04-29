//
//  Container+APIClient.swift
//  MarktGuru
//
//  Created by Ahmed Madian on 28.04.25.
//

import Factory

extension Container {
    var productsAPIClient: Factory<ProductsAPIClientType> {
        self { ProductsAPIClient() }
            .onPreview { ProductsAPIClientPreview() }
    }
}
