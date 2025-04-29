//
//  APIClientError.swift
//  MarktGuru
//
//  Created by Ahmed Madian on 28.04.25.
//

import Foundation

enum APIClientError: Error {
    case invalidURL
    case decodingFailed(_ error: any Error)
    case invalidResponse(_ data: Data)
    case statusCode(Int)
    case networkError(any Error)
    case requestFailed(_ error: any Error)
    case serviceError

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .decodingFailed(let error):
            return "Decoding Failed: \(error.localizedDescription)"
        case .invalidResponse(let data):
            return String(data: data, encoding: .utf8) ?? "Invalid Response Data"
        case let .statusCode(code):
            return "HTTP status code: \(code)"
        case .networkError(let error):
            return "Network Error: \(error.localizedDescription)"
        case .requestFailed(let error):
            return "Request Failed: \(error.localizedDescription)"
        case .serviceError:
            return "Service Error"
        }
    }
}
