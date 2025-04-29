//
//  APIClientType.swift
//  MarktGuru
//
//  Created by Ahmed Madian on 28.04.25.
//

import Foundation

protocol APIClientType {
    associatedtype Endpoint: EndpointType
}

extension APIClientType {
    func request<Model: Decodable & Sendable>(_ endpoint: any EndpointType) async throws -> Model {
        guard let request = endpoint.urlRequest else {
            throw APIClientError.invalidURL
        }

        let data = try await perform(request)

        do {
            return try JSONDecoder().decode(Model.self, from: data)
        } catch {
            throw APIClientError.decodingFailed(error)
        }
    }

    @discardableResult
    private func perform(_ request: URLRequest) async throws -> Data {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIClientError.invalidResponse(data)
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIClientError.statusCode(httpResponse.statusCode)
            }

            return data
        } catch {
            if let urlError = error as? URLError {
                throw APIClientError.networkError(urlError)
            } else {
                throw APIClientError.requestFailed(error)
            }
        }
    }
}
