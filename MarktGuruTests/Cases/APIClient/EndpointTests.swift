//
//  EndpointTests.swift
//  MarktGuruTests
//
//  Created by Ahmed Madian on 28.04.25.
//

import XCTest
@testable import MarktGuru

final class EndpointTests: XCTestCase {
    func testURLRequestConstruction_success() {
        // Given
        let endpoint = MockEndpoint(
            method: .get,
            baseURL: "https://api.example.com",
            path: "users",
            headers: ["Authorization": "Bearer token"],
            urlParams: ["include": "details"],
            body: nil,
            apiVersion: "v1"
        )

        // When
        let request = endpoint.urlRequest

        // Then
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.httpMethod, "GET")
        XCTAssertEqual(request?.url?.absoluteString, "https://api.example.com/v1/users?include=details")
        XCTAssertEqual(request?.allHTTPHeaderFields?["Authorization"], "Bearer token")
        XCTAssertNil(request?.httpBody)
    }

    func testURLRequestConstruction_noURLParams() {
        // Given
        let endpoint = MockEndpoint(
            method: .delete,
            baseURL: "https://api.example.com",
            path: "users/1",
            headers: [:],
            urlParams: [:],
            body: nil,
            apiVersion: "v1"
        )

        // When
        let request = endpoint.urlRequest

        // Then
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.httpMethod, "DELETE")
        XCTAssertEqual(request?.url?.absoluteString, "https://api.example.com/v1/users/1?")
        XCTAssertNil(request?.httpBody)
    }

    func testURLRequestConstruction_invalidURL() {
        // Given
        let endpoint = MockEndpoint(
            method: .get,
            baseURL: "invalid-url",
            path: "/users",
            headers: [:],
            urlParams: [:],
            body: nil,
            apiVersion: "v1"
        )

        // When
        let request = endpoint.urlRequest
        
        // Then
        XCTAssertNotNil(request, "Expected URLRequest to be non-nil")

        if let url = request?.url {
            let isValidURL = UIApplication.shared.canOpenURL(url)
            XCTAssertFalse(isValidURL, "Expected URL to be invalid but got a valid URL")
        } else {
            XCTFail("URLRequest URL should not be nil")
        }
    }

    func testURLRequestConstruction_withEmptyPath() {
        // Given
        let endpoint = MockEndpoint(
            method: .get,
            baseURL: "https://api.example.com",
            path: "",
            headers: [:],
            urlParams: [:],
            body: nil,
            apiVersion: "v1"
        )

        // When
        let request = endpoint.urlRequest

        // Then
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.url?.absoluteString, "https://api.example.com/v1/?")
    }
}
