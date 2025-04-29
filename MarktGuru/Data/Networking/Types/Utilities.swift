//
//  Utilities.swift
//  MarktGuru
//
//  Created by Ahmed Madian on 28.04.25.
//

import Foundation

// MARK: - ContentType

enum ContentType: String {
    case json = "application/json"
}

// MARK: - HTTPMethod

enum HTTPMethod: String {
    case get
    case post
    case put
    case delete
}

//MARK: - HTTPHeaderField

enum HTTPHeaderField: String {
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case cacheControl = "Cache-Control"
}
