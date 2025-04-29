//
//  ProductsAPIEndpoint.swift
//  MarktGuru
//
//  Created by Ahmed Madian on 28.04.25.
//

import Foundation

// MARK: - Constants

private enum Constants {
    static let baseURL = "https://api.escuelajs.co"
    static let productsPath = "products"

    enum APIVersion: String {
        case v1 = "api/v1"
    }
}

// MARK: - Endpoints

enum ProductsAPIEndpoint {
    case products(offset: Int, limit: Int)
}

// MARK: - EndpointType

extension ProductsAPIEndpoint: EndpointType {
    var method: HTTPMethod {
        switch self {
        case .products:
            return .get
        }
    }

    var baseURL: String {
        Constants.baseURL
    }

    var path: String {
        switch self {
        case .products:
            Constants.productsPath
        }
    }

    var headers: [String : String] {
        [:]
    }

    var urlParams: [String : any CustomStringConvertible] {
        switch self {
        case .products(offset: let offset, limit: let limit):
            return ["offset": offset, "limit": limit]
        }
    }
    
    var body: Data? {
        nil
    }

    var apiVersion: String {
        Constants.APIVersion.v1.rawValue
    }
}
