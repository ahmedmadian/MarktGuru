//
//  Container+LocalDataSource.swift
//  MarktGuru
//
//  Created by Ahmed Madian on 28.04.25.
//

import Factory

extension Container {
    var favoritesDataSource: Factory<FavoritesDataSourceType> {
        self { FavoritesDataSource() }
    }
}
