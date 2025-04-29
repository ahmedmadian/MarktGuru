//
//  Container+Repository.swift
//  MarktGuru
//
//  Created by Ahmed Madian on 28.04.25.
//

import Factory

extension Container {
    var productsRepo: Factory<ProductsRepoType> {
        self { ProductsRepo() }
    }
}
