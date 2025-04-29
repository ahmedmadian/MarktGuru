//
//  Product.swift
//  MarktGuru
//
//  Created by Ahmed Madian on 29.04.25.
//

import Foundation

struct Product: Decodable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let images: [String]
    let category: Category
}

// MARK: - Category

struct Category: Decodable {
    let name: String
}
