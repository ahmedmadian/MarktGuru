//
//  MockAPIClient.swift
//  MarktGuruTests
//
//  Created by Ahmed Madian on 28.04.25.
//

import Foundation
@testable import MarktGuru

struct MockAPIClient: APIClientType {
    typealias Endpoint = MockEndpoint
}
