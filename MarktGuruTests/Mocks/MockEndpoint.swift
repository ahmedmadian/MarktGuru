//
//  MockEndpoint.swift
//  MarktGuruTests
//
//  Created by Ahmed Madian on 28.04.25.
//

import Foundation
@testable import MarktGuru

struct MockEndpoint: EndpointType {
    let method: HTTPMethod
    let baseURL: String
    let path: String
    let headers: [String : String]
    let urlParams: [String : any CustomStringConvertible]
    let body: Data?
    let apiVersion: String
}
