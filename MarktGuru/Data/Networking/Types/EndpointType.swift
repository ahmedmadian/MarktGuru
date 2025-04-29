//
//  EndpointType.swift
//  MarktGuru
//
//  Created by Ahmed Madian on 28.04.25.
//

import Foundation

protocol EndpointType {
    var method: HTTPMethod { get }
    var baseURL: String { get }
    var path: String { get }
    var headers: [String: String] { get }
    var urlParams: [String: any CustomStringConvertible] { get }
    var body: Data? { get }
    var urlRequest: URLRequest? { get }
    var apiVersion: String { get }
}

extension EndpointType {
    var urlRequest: URLRequest? {
        let urlString = [baseURL, apiVersion, path].joined(separator: "/")
        var components = URLComponents(string: urlString)
        components?.queryItems = urlParams.map { key, value in
            URLQueryItem(name: key, value: String(describing: value))
        }

        guard let url = components?.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.httpShouldHandleCookies = false
        request.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        request.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        request.setValue("no-cache", forHTTPHeaderField: HTTPHeaderField.cacheControl.rawValue)

        return request
    }
}
