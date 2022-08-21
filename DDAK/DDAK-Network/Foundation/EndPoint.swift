//
//  EndPoint.swift
//  DDAK-Network
//
//  Created by taekki on 2022/08/22.
//

import Foundation

enum EndPoint {
    case search(query: String, page: Int)
    case random(count: Int)
    
    var requestURL: String {
        switch self {
        case .search(let query, let page):
            return NetworkEnvironment.makeEndPointString("/search/photos?query=\(query)&page=\(page)")
        case .random(let count):
            return NetworkEnvironment.makeEndPointString("/photos/random?count=\(count)")
        }
    }
}
