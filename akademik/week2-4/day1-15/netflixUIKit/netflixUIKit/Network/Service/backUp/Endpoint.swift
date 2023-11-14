//
//  Endpoint.swift
//  netflixUIKit
//
//  Created by Muhammad Fahmi on 05/11/23.
//

import Foundation

enum Endpoint {
    case fetchRocket
    case getDetailRocket(Int)
    
    func path() -> String {
        switch self {
        case .fetchRocket:
            return "/rockets"
        case .getDetailRocket(let id):
            return "/rockets/\(id)"
        }
    }
    
    func method() -> String {
        switch self {
        case .fetchRocket, .getDetailRocket:
            return "GET"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .fetchRocket:
            return nil
        case .getDetailRocket:
            let params: [String: Any] = [:]
            return params
        }
    }
    
    var headers: [String: Any]? {
        switch self {
        case .fetchRocket, .getDetailRocket:
            let params: [String: Any]? = ["Content-Type": "application/json"]
            return params
        }
    }
    
    func urlString() -> String {
        return BaseConstant.baseUrl + self.path() // Cannot find 'BaseConstant' in scope
    }
    
    struct BaseConstant {
        static let baseUrl = "https://api.example.com"
    }
}
