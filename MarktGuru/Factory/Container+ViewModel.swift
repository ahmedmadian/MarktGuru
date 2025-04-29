//
//  Container+ViewModel.swift
//  MarktGuru
//
//  Created by Ahmed Madian on 28.04.25.
//

import Factory

extension Container {
    var productsViewModel: Factory<ProductsViewModelType> {
        self { ProductsViewModel() }
    }

    var productDetailViewModel: ParameterFactory<ProductViewModel, ProductDetailViewModelType> {
        .init(self) { productViewModel in
            ProductDetailViewModel(product: productViewModel)
        }
    }
}
